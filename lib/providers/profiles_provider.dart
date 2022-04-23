import 'package:flutter/foundation.dart';
import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';
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

  List<ProfileModel> get notSyncedProfiles {
    return _profiles
        .where((element) => element.syncFlag != SyncFlags.none)
        .toList();
  }

  //? getting the active profile id
  String get activatedProfileId {
    return _activatedProfileId;
  }

  //? getting not deleted profiles
  List<ProfileModel> get profiles {
    return [
      ..._profiles
          .where((element) => element.deleted == false)
          .toList()
          .reversed
          .toList()
    ];
  }

  //? getting all profiles with the deleted ones (will be used for syncing)
  List<ProfileModel> get allProfiles {
    return [..._profiles];
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
    return _profiles.firstWhere(
      (element) => element.id == activatedProfileId,
    );
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
      rethrow;
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
      List<ProfileModel> fetchedProfiles = data.map(
        (profile) {
          ProfileModel profileModel = ProfileModel(
            id: profile['id'],
            name: profile['name'],
            income: double.parse(profile['income']),
            outcome: double.parse(profile['outcome']),
            createdAt: DateTime.parse(profile['createdAt']),
            lastActivatedDate: profile['lastActivatedDate'] == null ||
                    profile['lastActivatedDate'] == 'null'
                ? null
                : DateTime.parse(profile['lastActivatedDate']),
            syncFlag: stringToSyncFlag(profile['syncFlag']),
            deleted: profile['deleted'] == dbTrue ? true : false,
          );

          return profileModel;
        },
      ).toList();

      fetchedProfiles.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      _profiles = fetchedProfiles;
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching profiles from the database');
      }
      rethrow;
    }
    notifyListeners();
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
        'syncFlag': SyncFlags.add.name,
        'deleted': dbFalse,
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error creating new money profile');
      }
      rethrow;
    }

    ProfileModel newProfile = ProfileModel(
      id: id,
      name: name,
      income: 0,
      outcome: 0,
      createdAt: createdAt,
      syncFlag: SyncFlags.add,
      deleted: false,
    );
    _profiles.add(newProfile);
    notifyListeners();
    return id;
  }

  Future<void> changeSyncFlag(String id, SyncFlags newSyncFlag) async {
    await editProfile(id: id, syncFlags: newSyncFlag);
  }

  //? editing an existing profile
  Future<void> editProfile(
      {required String id,
      String? name,
      double? income,
      double? outcome,
      DateTime? lastActivatedDate,
      SyncFlags? syncFlags,
      bool? deleted}) async {
    //* rejecting edit if no argument is provided
    if (name == null &&
        income == null &&
        outcome == null &&
        lastActivatedDate == null &&
        syncFlags == null &&
        deleted == null) {
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
    DateTime? newLastActiveDate =
        lastActivatedDate ?? editedProfile.lastActivatedDate;
    //? if syncFlags is null, check if the profile flag is add to add it cause it won't be there is firestore for editing
    //? and if it not add then mark it as edit
    //? and if the syncFlags is set it will be only SyncFlags.none
    SyncFlags newSyncFlag = syncFlags ??
        (editedProfile.syncFlag == SyncFlags.add
            ? SyncFlags.add
            : SyncFlags.edit);
    bool newDeleted = deleted ?? editedProfile.deleted;
    //* edit the profile in database first
    try {
      await DBHelper.insert(profilesTableName, {
        'id': id,
        'name': newName,
        'income': newIncome,
        'outcome': newOutcome,
        'createdAt': createdAt.toIso8601String(),
        'lastActivatedDate': newLastActiveDate == null
            ? 'null'
            : newLastActiveDate.toIso8601String(),
        'syncFlag': newSyncFlag.name,
        'deleted': newDeleted ? dbTrue : dbFalse,
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
        lastActivatedDate: newLastActiveDate,
        syncFlag: newSyncFlag,
        deleted: newDeleted,
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
    //* checking if the deleted profile is the active profile
    if (profileId == activatedProfileId) {
      throw CustomError('You can\'t delete the active profile');
    }
    //? here i need to check if the profile is flagged as add
    //? if it is still new (add flag) then you can't update it in the firestore so you need to keep the add flag
    ProfileModel profileToDelete = getProfileById(profileId);
    if (profileToDelete.syncFlag == SyncFlags.add) {
      return editProfile(id: profileId, deleted: true);
    }
    //* when deleting a profile that is still not added to the firestore yet it will be flagged as deleted
    return editProfile(
        id: profileId, deleted: true, syncFlags: SyncFlags.delete);
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
      rethrow;
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
