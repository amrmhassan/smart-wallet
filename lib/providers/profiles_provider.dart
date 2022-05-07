import 'package:flutter/cupertino.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/debt_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
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
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
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

  //? get profile income
  Future<double> getProfileIncome(
    TransactionProvider transactionProvider,
    DebtsProvider debtsProvider,
    String profileId,
  ) async {
    double incomeTransactions = (await transactionProvider
            .getProfileTransations(profileId))
        .where((element) => element.transactionType == TransactionType.income)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    double borrowedDebts = debtsProvider.debts
        .where((element) => element.borrowingProfileId == profileId)
        .fold(0, (previousValue, element) => element.amount);

    return incomeTransactions + borrowedDebts;
  }

  //? get profile income
  Future<double> getProfileOutcome(
    TransactionProvider transactionProvider,
    DebtsProvider debtsProvider,
    String profileId,
  ) async {
    double outcomeTransactions = (await transactionProvider
            .getProfileTransations(profileId))
        .where((element) => element.transactionType == TransactionType.outcome)
        .fold(0, (previousValue, element) => previousValue + element.amount);

    double fulfilledDebts = debtsProvider.debts
        .where((element) => element.fullfillingProfileId == profileId)
        .fold(0, (previousValue, element) => element.amount);

    return outcomeTransactions + fulfilledDebts;
  }

//? getting the highest profile with total money
  ProfileModel highestProfile() {
    List<ProfileModel> arrangedProfiles = [...profiles];
    //* this will arrage the profile with the lowest first
    arrangedProfiles.sort((a, b) => a.totalMoney.compareTo(b.totalMoney));
    return arrangedProfiles.last;
  }

  //? getting the total money in all profiles
  double getTotalMoney() {
    return profiles.fold(
        0, (previousValue, profile) => previousValue + profile.totalMoney);
  }

  //? getting the total income for all profiles
  double getTotalIncome() {
    return profiles.fold(
        0, (previousValue, profile) => previousValue + profile.income);
  }

//? getting total outcome for all profiles
  double getTotalOutcome() {
    return profiles.fold(
        0, (previousValue, profile) => previousValue + profile.outcome);
  }

//? getting a profile by id
  ProfileModel getProfileById(String id) {
    return profiles.firstWhere((element) => id == element.id);
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
      } catch (error, stackTrace) {
        CustomError.log(error: error, stackTrace: stackTrace);
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
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }

  //? fetching and updating profiles from database
  Future<void> fetchAndUpdateProfiles([BuildContext? context]) async {
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(profilesTableName);
      List<ProfileModel> fetchedProfiles = data.map(
        (profile) {
          return ProfileModel.fromJSON(profile);
        },
      ).toList();
      bool isEmpty = true;
      for (var profile in fetchedProfiles) {
        if (!profile.deleted) {
          isEmpty = false;
          break;
        }
      }

      //* if there is no profile yet just create the default one and add it to the _profiles
      if (isEmpty) {
        String id = await addProfile(defaultProfile.name);
        return setActivatedProfile(id);
      }
      //* getting the profiles again after adding the default profile

      // i will need to rearrange the profiles according to the lastActivated date then the createdAt date

      fetchedProfiles.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      _profiles = fetchedProfiles;
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
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
      CustomError.log(
        errorType: ErrorTypes.profileNameExists,
        rethrowError: true,
      );
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
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
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
      return CustomError.log(
          error: 'You must enter one argument at least to edit the profile',
          rethrowError: true);
    }

    //* checking if the profile name already exists if the changing parameter is the name
    bool profileNameExists = false;
    for (var element in profiles) {
      if (name == element.name) {
        profileNameExists = true;
      }
    }
    if (profileNameExists) {
      CustomError.log(
        errorType: ErrorTypes.profileNameExists,
        rethrowError: true,
      );
    }
    ProfileModel editedProfile;
    try {
      //* setting the active profile to the current active profile
      editedProfile = _profiles.firstWhere((element) => element.id == id);
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
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
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
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
    return editProfile(
      id: activatedProfileId,
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
      CustomError.log(
          errorType: ErrorTypes.deleteActiveProfile, rethrowError: true);
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
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }

  //? setting the active profile id
  Future<void> setActivatedProfile(String id, [BuildContext? context]) async {
    try {
      await SharedPrefHelper.setString(kActivatedProfileIdKey, id);

      _activatedProfileId = id;

      notifyListeners();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
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
