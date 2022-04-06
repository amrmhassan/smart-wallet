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
  //? holding the profiles
  List<ProfileModel> _profiles = [];
  //? holding the active profile id
  String _activatedProfileId = '';

  //? getting the active profile id
  String get activatedProfileId {
    return _activatedProfileId;
  }

  //? getting profiles
  List<ProfileModel> get profiles {
    return [..._profiles.reversed.toList()];
  }

  //? getting the total money in all profiles
  double getTotalMoney() {
    return _profiles.fold(
        0, (previousValue, profile) => previousValue + profile.totalMoney);
  }

  //? getting the total income for all profiles
  double getTotalIncome() {
    return _profiles.fold(
        0, (previousValue, profile) => previousValue + profile.income);
  }

//? getting total outcome for all profiles
  double getTotalOutcome() {
    return _profiles.fold(
        0, (previousValue, profile) => previousValue + profile.outcome);
  }

//? getting a profile by id
  ProfileModel getProfileById(String id) {
    return _profiles.firstWhere((element) => id == element.id);
  }

  //? getting the active profile info
  ProfileModel get getActiveProfile {
    //* fixed by setting the currentActiveId when fetching profile and there is no profiles
    //* and by adding the loading to the holder screen to prevent showing the home screen that will ask for the current active id
    //* before loading them from the database
    // fix that error , this will create an error first time the app loads cause
    // i think this is called before the profiles loads
    return _profiles.firstWhere((element) => element.id == activatedProfileId);
  }

  //? getting profile age
  int getProfileAgeInDays(ProfileModel profile) {
    DateTime now = DateTime.now();
    DateTime createdAt = profile.createdAt;
    var diff = now.difference(createdAt);
    return diff.inDays;
  }

  //? getting the active profile id from the shared preferences
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

  //? fetching and updating profiles from database
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

  //? fetching dummy profiles only for testing
  void fetchDummyProfiles() {
    _profiles = _profiles + dummyProfiles;
    notifyListeners();
  }

  //? adding a new profile
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

  //? editing an existing profile
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

  //? editing the current active profile
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

  //? deleting a profile
  Future<void> deleteProfile(String profileId) async {
    _profiles.removeWhere((element) => element.id == profileId);

    //* delete from the database second
    try {
      await DBHelper.deleteById(profileId, profilesTableName);
    } catch (error) {
      if (kDebugMode) {
        print(error);
        print('An error occurred during deleting a profile');
      }
    }
    notifyListeners();
  }

  //? edit the last active property when activating a profile
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

  //? setting the active profile id
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
