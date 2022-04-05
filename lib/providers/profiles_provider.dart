import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/shared_pref_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/models/profile_model.dart';

import '../constants/profiles_constants.dart';
import '../helpers/db_helper.dart';

class ProfilesProvider extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  String _activatedProfileId = '';

  //* for getting the activated profile id
  String get activatedProfileId {
    return _activatedProfileId;
  }

  //* for getting the profiles
  List<ProfileModel> get profiles {
    return [..._profiles.reversed.toList()];
  }

  //* for getting the current active profile
  ProfileModel get getActiveProfile {
    //* fixed by setting the currentActiveId when fetching profile and there is no profiles
    //* and by adding the loading to the holder screen to prevent showing the home screen that will ask for the current active id
    //* before loading them from the database
    // fix that error , this will create an error first time the app loads cause
    // i think this is called before the profiles loads
    return _profiles.firstWhere((element) => element.id == activatedProfileId);
  }

  int getProfileAgeInDays() {
    DateTime now = DateTime.now();
    DateTime createdAt = getActiveProfile.createdAt;
    var diff = now.difference(createdAt);
    return diff.inDays;
  }

  //* for fetching and update the activated profile id from shared preferences
  Future<void> fetchAndUpdateActivatedProfileId() async {
    String activatedId;

    try {
      String? savedActivatedId =
          await SharedPrefHelper.getString(kActivatedProfileIdKey);
      if (savedActivatedId == null) {
        activatedId = profiles[0].id;
        await setActivatedProfile(activatedId);
      } else {
        activatedId = savedActivatedId;
      }
      _activatedProfileId = activatedId;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching activated profile id');
      }
    }
  }

  //* for getting and updating the profiles from database
  Future<void> fetchAndUpdateProfiles() async {
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(profilesTableName);
      //* if there is no profile yet just create the default one and add it to the _profiles
      if (data.isEmpty) {
        String id = await addProfile(defaultProfile.name);
        return setActivatedProfile(id);
      }
      //? i will need to rearrange the profiles according to the lastActivated date then the createdAt date

      List<ProfileModel> fetchedProfiles = data
          .map(
            (profile) => ProfileModel(
              id: profile['id'],
              name: profile['name'],
              income: double.parse(profile['income']),
              outcome: double.parse(profile['outcome']),
              createdAt: DateTime.parse(profile['createdAt']),
              activated: profile['activated'] == 'false' ? false : true,
              lastActivatedDate: profile['lastActivatedDate'] == null
                  ? null
                  : DateTime.parse(profile['lastActivatedDate']),
            ),
          )
          .toList();
      //? i was trying to make the activated profiles come first
      //? it will need some more thinking and planning

      // List<ProfileModel> activatedBefore = fetchedProfiles
      //     .where((element) => element.lastActivatedDate != null)
      //     .toList();
      // List<ProfileModel> neverActivated = fetchedProfiles
      //     .where((element) => element.lastActivatedDate == null)
      //     .toList();

      // activatedBefore.sort((a, b) {
      //   return a.lastActivatedDate!.compareTo(b.lastActivatedDate!);
      // });

      _profiles = fetchedProfiles;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching profiles from the database');
      }
      // rethrow;
    }
  }

  void fetchDummyProfiles() {
    _profiles = _profiles + dummyProfiles;
    notifyListeners();
  }

  //* for adding a profile to database and to the _profiles
  Future<String> addProfile(String name) async {
    //* checking if the profile name already exists
    bool profileNameExists = false;
    for (var element in _profiles) {
      if (name == element.name) {
        profileNameExists = true;
      }
    }
    if (profileNameExists) {
      throw CustomError('Profile Name already exists');
    }

    //* initializing the transaction data like (createdAt, id, ratioToTotal...)
    String id = const Uuid().v4();
    DateTime createdAt = DateTime.now();

    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(profilesTableName, {
        'id': id,
        'name': name,
        'income': 0,
        'outcome': 0,
        'createdAt': createdAt.toIso8601String(),
        'activated': 'false',
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error creating new money profile');
      }
      rethrow;
    }

    ProfileModel newProfile = ProfileModel(
        id: id, name: name, income: 0, outcome: 0, createdAt: createdAt);
    _profiles.add(newProfile);
    notifyListeners();
    return id;
  }

  //* for editing a profile
  Future<void> editProfile({
    required String id,
    String? name,
    double? income,
    double? outcome,
    DateTime? lastActivatedDate,
  }) async {
    //* rejecting edit if no argument is provided
    if (name == null &&
        income == null &&
        outcome == null &&
        lastActivatedDate == null) {
      throw CustomError(
          'You must enter one argument at least to edit the profile');
    }

    //* checking if the profile name already exists if the changing parameter is the name
    bool profileNameExists = false;
    for (var element in _profiles) {
      if (name == element.name) {
        profileNameExists = true;
      }
    }
    if (profileNameExists) {
      throw CustomError('Profile Name already exists');
    }

    //* setting the active profile to the current active profile
    ProfileModel editedProfile =
        _profiles.firstWhere((element) => element.id == id);
    String newName = name ?? editedProfile.name;
    double newIncome = income ?? editedProfile.income;
    double newOutcome = outcome ?? editedProfile.outcome;
    DateTime createdAt = editedProfile.createdAt;
    bool activated = editedProfile.activated;
    DateTime? newLastActiveDate =
        lastActivatedDate ?? editedProfile.lastActivatedDate;
    //* edit the profile in database first
    try {
      await DBHelper.insert(profilesTableName, {
        'id': id,
        'name': newName,
        'income': newIncome,
        'outcome': newOutcome,
        'createdAt': createdAt.toIso8601String(),
        'activated': activated ? 'true' : 'false',
        'lastActivatedDate': newLastActiveDate == null
            ? 'null'
            : newLastActiveDate.toIso8601String(),
      });

      //* edit it on the _profiles
      int index = _profiles.indexOf(editedProfile);
      _profiles.removeAt(index);
      ProfileModel newProfile = ProfileModel(
        id: id,
        name: newName,
        income: newIncome,
        outcome: newOutcome,
        createdAt: createdAt,
        activated: activated,
        lastActivatedDate: newLastActiveDate,
      );
      _profiles.insert(index, newProfile);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error editting the profile new money profile');
      }
      rethrow;
    }
  }

  Future<void> editActiveProfile({
    String? name,
    double? income,
    double? outcome,
    DateTime? lastActivatedDate,
  }) async {
    //* setting the active profile to the current active profile
    ProfileModel activeProfile = getActiveProfile;
    String id = activeProfile.id;
    return editProfile(
      id: id,
      name: name,
      income: income,
      outcome: outcome,
      lastActivatedDate: lastActivatedDate,
    );
  }

  //* for setting the lastActivated property for the profile
  Future<void> editLastActivatedForProfile() async {
    try {
      return editActiveProfile(lastActivatedDate: DateTime.now());
    } catch (error) {
      if (kDebugMode) {
        print(error);
        print('Error setting the lastActivated Property in the profile');
      }
    }
  }

  //* for setting the active profile id in the shared preferences
  Future<void> setActivatedProfile(String id) async {
    try {
      await SharedPrefHelper.setString(kActivatedProfileIdKey, id);
      _activatedProfileId = id;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error setting the active profile');
      }
      rethrow;
    }

    //* edit the lastActivated property in the profile
    // add that code to the first created profile
    editLastActivatedForProfile();
  }
}
