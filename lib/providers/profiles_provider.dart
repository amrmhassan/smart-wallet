import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/utils/general_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/shared_pref_constants.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/shared_pref_helper.dart';
import 'package:smart_wallet/models/profile_model.dart';

import '../constants/profiles_constants.dart';
import '../helpers/db_helper.dart';

class ProfilesProvider extends ChangeNotifier {
  //? all user profiles
  List<ProfileModel> _profiles = [];
  //? active profile id
  String _activatedProfileId = '';

//? need syncing profiles
  List<ProfileModel> get notSyncedProfiles {
    return _profiles
        .where((element) => element.syncFlag != SyncFlags.noSyncing)
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

  //? getting the active profile info
  ProfileModel getActiveProfile() {
    //* fixed by setting the currentActiveId when fetching profile and there is no profiles
    //* and by adding the loading to the holder screen to prevent showing the home screen that will ask for the current active id
    //* before loading them from the database
    // fix that error , this will create an error first time the app loads cause
    // i think this is called before the profiles loads
    // no this the error beause the this is called before the activatedProfileId update from the fetch and update profile Id
    try {
      return _profiles.firstWhere(
        (element) => element.id == activatedProfileId,
      );
    } catch (error) {
      //! this is not the final solution
      return ProfileModel(
        id: 'id',
        name: 'name',
        income: 0,
        outcome: 0,
        createdAt: DateTime.now(),
        lastActivatedDate: DateTime.now(),
      );
    }
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

//? clear the proriles array
  void clearAllProfiles() async {
    _profiles.clear();
  }

//? adding an array of profiles to the local databas
  Future<void> setProfiles(List<ProfileModel> profiles) async {
    //! here add the profiles to the local database
    for (var profile in profiles) {
      try {
        await DBHelper.insert(profilesTableName, profile.toJSON());
      } catch (error) {
        if (kDebugMode) {
          print('Error setting profiles from firestore');
        }
        throw CustomError(error);
      }
    }
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
      throw CustomError(error);
    }
  }

  //? fetching and updating profiles from database
  Future<void> fetchAndUpdateProfiles([BuildContext? context]) async {
    showStackedSnackBar(context, '1 getting the profiles');
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(profilesTableName);
      showStackedSnackBar(context, '2 profiles get from database');

      //* if there is no profile yet just create the default one and add it to the _profiles
      if (data.isEmpty) {
        String id = await addProfile(defaultProfile.name);
        showStackedSnackBar(context, '3 the first profile added');
        return setActivatedProfile(id);
      }
      showStackedSnackBar(context, '4 after adding the first profile');
      //* getting the profiles again after adding the default profile
      data = await DBHelper.getData(profilesTableName);
      showStackedSnackBar(context,
          '5 after getting the profiles from database for the second time');

      // i will need to rearrange the profiles according to the lastActivated date then the createdAt date

      List<ProfileModel> fetchedProfiles = data.map(
        (profile) {
          showStackedSnackBar(
              context, profile.entries.toString() + profile.values.toString());
          return ProfileModel.fromJSON(profile);
        },
      ).toList();

      showStackedSnackBar(
          context, '6 after setting the fetched profiles array');
      await setActivatedProfile('id');
      showStackedSnackBar(context,
          '7 fetched profiles set with length of ${fetchedProfiles.length}');

      fetchedProfiles.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      _profiles = fetchedProfiles;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('Error fetching profiles from the database');
      }
      showStackedSnackBar(context, error.toString() + stackTrace.toString());
      throw CustomError(error);
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

    ProfileModel newProfile = ProfileModel(
      id: id,
      name: name,
      income: 0,
      outcome: 0,
      createdAt: createdAt,
      syncFlag: SyncFlags.add,
      deleted: false,
    );

    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(profilesTableName, newProfile.toJSON());
    } catch (error) {
      if (kDebugMode) {
        print('Error creating new money profile');
      }
      throw CustomError(error);
    }

    _profiles.add(newProfile);
    notifyListeners();
    return id;
  }

  Future<void> changeSyncFlag(String id, SyncFlags newSyncFlag) async {
    await editProfile(id: id, syncFlags: newSyncFlag);
  }

  //? editing an existing profile
  Future<void> editProfile({
    required String id,
    String? name,
    double? income,
    double? outcome,
    DateTime? lastActivatedDate,
    SyncFlags? syncFlags,
    bool? deleted,
  }) async {
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
    ProfileModel editedProfile;
    try {
      //* setting the active profile to the current active profile
      editedProfile = _profiles.firstWhere((element) => element.id == id);
    } catch (error) {
      return;
    }

    String newName = name ?? editedProfile.name;
    double newIncome = income ?? editedProfile.income;
    double newOutcome = outcome ?? editedProfile.outcome;
    DateTime createdAt = editedProfile.createdAt;
    DateTime? newLastActiveDate =
        lastActivatedDate ?? editedProfile.lastActivatedDate;
    // if syncFlags is null, check if the profile flag is add to add it cause it won't be there is firestore for editing
    // and if it not add then mark it as edit
    // and if the syncFlags is set it will be only SyncFlags.noSyncing
    SyncFlags newSyncFlag = syncFlags ??
        (editedProfile.syncFlag == SyncFlags.add
            ? SyncFlags.add
            : SyncFlags.edit);
    bool newDeleted = deleted ?? editedProfile.deleted;
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
    //* edit the profile in database first
    try {
      await DBHelper.insert(profilesTableName, newProfile.toJSON());

      //* edit it on the _profiles
      int index = _profiles.indexOf(editedProfile);
      _profiles.removeAt(index);

      _profiles.insert(index, newProfile);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error editting the profile new money profile');
      }
      throw CustomError(error);
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
    ProfileModel activeProfile = getActiveProfile();
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
    // here i need to check if the profile is flagged as add
    // if it is still new (add flag) then you can't update it in the firestore so you need to keep the add flag
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
      throw CustomError(error);
    }
  }

  //? setting the active profile id
  Future<void> setActivatedProfile(String id, [BuildContext? context]) async {
    showStackedSnackBar(context, '44 before setting the active profile');
    try {
      showStackedSnackBar(context, '55 before setting the active profile');
      await SharedPrefHelper.setString(kActivatedProfileIdKey, id);
      showStackedSnackBar(context, '66 after setting the active profile');

      _activatedProfileId = id;
      showStackedSnackBar(context, '77 before notifying listeners');

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error setting the active profile');
      }
      throw CustomError(error);
    }

    //* edit the lastActivated property in the profile
    // add that code to the first created profile
    return editLastActivatedForProfile();
  }

//? clear the active profile id from the shared preferences
  Future<bool> clearActiveProfileId() async {
    return SharedPrefHelper.removeKey(kActivatedProfileIdKey);
  }
}
