import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/theme_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';

class SyncedDataProvider extends ChangeNotifier {
  //# ********* Syncing data to firestore **********#//
//? for syncing all data( profiles, transactions, quick Actions)
  Future<void> syncAllData(
    ProfilesProvider profilesProvider,
    TransactionProvider transactionProvider,
    QuickActionsProvider quickActionsProvider,
    String userPrefsString,
    BuildContext context,
  ) async {
    await syncProfiles(profilesProvider);
    await syncTransactions(transactionProvider, profilesProvider);
    await syncQuickActions(quickActionsProvider, profilesProvider);
    await syncUserData(userPrefsString, context);
  }

  //# 1] sync profiles
  Future<void> syncProfiles(ProfilesProvider profilesProvider) async {
    try {
      CustomError.log(
        error: 'Start syncing profile',
        logType: LogTypes.info,
      );
      for (var profile in profilesProvider.notSyncedProfiles) {
        //* i made this just to prevent syncing the profile with the sync flag add or anything else
        //* and to ensure that it would by synced with the none flag to the firestore
        SyncFlags currentSyncFlag = profile.syncFlag;
        profile.syncFlag = SyncFlags.noSyncing;
        await profilesProvider.changeSyncFlag(profile.id, SyncFlags.noSyncing);

        if (currentSyncFlag == SyncFlags.add) {
          await addProfile(profile);
        } else if (currentSyncFlag == SyncFlags.edit) {
          await updateProfile(profile);
        } else if (currentSyncFlag == SyncFlags.delete) {
          await updateProfile(profile);
        }
      }
      CustomError.log(
        error: 'finished syncing profile',
        logType: LogTypes.info,
      );
    } catch (error, stackTrace) {
      CustomError.log(
          error: 'Error syncing profiles $error',
          rethrowError: true,
          stackTrace: stackTrace);
    }
  }

  //# 2] sync transactions
  Future<void> syncTransactions(TransactionProvider transactionProvider,
      ProfilesProvider profilesProvider) async {
    try {
      CustomError.log(
        error: 'start syncing transactions',
        logType: LogTypes.info,
      );
      for (var transaction in transactionProvider.notSyncedTransactions) {
        SyncFlags currentSyncFlag = transaction.syncFlag;
        transaction.syncFlag = SyncFlags.noSyncing;
        await transactionProvider.changeSyncFlag(transaction.id,
            SyncFlags.noSyncing, profilesProvider.activatedProfileId);

        if (currentSyncFlag == SyncFlags.add) {
          await addTransaction(transaction);
        } else if (currentSyncFlag == SyncFlags.edit) {
          await editTransaction(transaction);
        } else if (currentSyncFlag == SyncFlags.delete) {
          await editTransaction(transaction);
        }
      }
      CustomError.log(
        error: 'finished syncing transactions',
        logType: LogTypes.info,
      );
    } catch (error, stackTrace) {
      CustomError.log(
          error: 'Error syncing transactions $error',
          rethrowError: true,
          stackTrace: stackTrace);
    }
  }

  //# 3] sync quick Actions
  Future<void> syncQuickActions(QuickActionsProvider quickActionsProvider,
      ProfilesProvider profilesProvider) async {
    try {
      CustomError.log(
        error: 'start syncing quick Actions',
        logType: LogTypes.info,
      );
      for (var quickAction in quickActionsProvider.notSyncedQuickActions) {
        SyncFlags currentSyncFlag = quickAction.syncFlag;
        await quickActionsProvider.changeSyncFlag(quickAction.id,
            SyncFlags.noSyncing, profilesProvider.activatedProfileId);
        quickAction.syncFlag = SyncFlags.noSyncing;

        if (currentSyncFlag == SyncFlags.add) {
          await addQuickAction(quickAction);
        } else if (currentSyncFlag == SyncFlags.edit) {
          await editQuickAction(quickAction);
        } else if (currentSyncFlag == SyncFlags.delete) {
          await editQuickAction(quickAction);
        }
      }
      CustomError.log(
        error: 'finished syncing quick Actions',
        logType: LogTypes.info,
      );
    } catch (error, stackTrace) {
      CustomError.log(
          error: 'Error syncing quick Actions $error',
          rethrowError: true,
          stackTrace: stackTrace);
    }
  }

  //# 4] sync user data
  Future<void> syncUserData(
      String userPrefsString, BuildContext context) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;
    try {
      await dbRef
          .collection(usersCollectionName)
          .doc(userId)
          .set({userPrefsCollectionName: userPrefsString});
      //? make user data need syncing to be false
      // await Provider.of<UserPrefsProvider>(context, listen: false)
      //     .setUserPrefsNeedSyncing(false);
    } catch (error) {
      CustomError.log(error: error);
    }
  }

//# 1] profiles
//? for adding a profile to the firestore for the first time
  Future<void> addProfile(
    ProfileModel profile,
  ) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    try {
      await dbRef
          .collection(usersCollectionName)
          .doc(userId)
          .collection(profilesCollectionName)
          .doc(profile.id)
          .set(profile.toJSON());
    } catch (error) {
      CustomError.log(
          error: 'Error syncing adding profile ${profile.id}, $error');
    }
  }

//? for updating an existing profile in the firestore
  Future<void> updateProfile(ProfileModel profile) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;
    try {
      await dbRef
          .collection(usersCollectionName)
          .doc(userId)
          .collection(profilesCollectionName)
          .doc(profile.id)
          .update(profile.toJSON());
    } catch (error) {
      CustomError.log(
          error: 'Error syncing updating profile ${profile.id}, $error');
    }
  }

//# 2] transactions
//? for adding a transaction to the firestore for the first time
  Future<void> addTransaction(TransactionModel transactionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    try {
      await dbRef
          .collection(usersCollectionName)
          .doc(userId)
          .collection(transactionsCollectionName)
          .doc(transactionModel.id)
          .set(transactionModel.toJSON());
    } catch (error) {
      CustomError.log(
          error:
              'Error syncing adding transaction ${transactionModel.id}, $error');
    }
  }

//? for editing a transaction
  Future<void> editTransaction(TransactionModel transactionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    try {
      await dbRef
          .collection(usersCollectionName)
          .doc(userId)
          .collection(transactionsCollectionName)
          .doc(transactionModel.id)
          .update(transactionModel.toJSON());
    } catch (error) {
      CustomError.log(
          error:
              'Error syncing updating transaction ${transactionModel.id}, $error');
    }
  }

//# 3] quick actions
//? adding a quick Action
  Future<void> addQuickAction(QuickActionModel quickActionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    try {
      await dbRef
          .collection(usersCollectionName)
          .doc(userId)
          .collection(quickActionsCollectionName)
          .doc(quickActionModel.id)
          .set(quickActionModel.toJSON());
    } catch (error) {
      CustomError.log(
          error:
              'Error syncing adding quick Action ${quickActionModel.id}, $error');
    }
  }

//? editing a quick Action
  Future<void> editQuickAction(QuickActionModel quickActionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    try {
      await dbRef
          .collection(usersCollectionName)
          .doc(userId)
          .collection(quickActionsCollectionName)
          .doc(quickActionModel.id)
          .update(quickActionModel.toJSON());
    } catch (error) {
      CustomError.log(
          error:
              'Error syncing updating quick action ${quickActionModel.id}, $error');
    }
  }

  //# ********* Fetching data from firestore **********#//

  Future<void> getAllData(
    ProfilesProvider profilesProvider,
    TransactionProvider transactionProvider,
    QuickActionsProvider quickActionsProvider,
    BuildContext context, [
    bool delete = false,
  ]) async {
    List<ProfileModel> profiles = await getProfiles();
    List<TransactionModel> transactions = await getTransactions();
    List<QuickActionModel> quickActions = await getQuickActions();
    String? userPrefs = await getUserPrefs();
    var debtsProvider = Provider.of<DebtsProvider>(context, listen: false);
    if (userPrefs != null) {
      var setUserPrefsFromString =
          Provider.of<UserPrefsProvider>(context, listen: false)
              .setUserPrefsFromString;
      var setActivatedProfile =
          Provider.of<ProfilesProvider>(context, listen: false)
              .setActivatedProfile;
      var setTheme =
          Provider.of<ThemeProvider>(context, listen: false).setTheme;

      await setUserPrefsFromString(userPrefs, setActivatedProfile, setTheme);
    }

//? i will only delete the data if the user chose to when logging in and there is no logged in user already
    if (delete) {
      profilesProvider.clearAllProfiles();
      transactionProvider.clearAllTransactions();
      quickActionsProvider.clearAllQuickActions();
      await DBHelper.deleteDatabase(dbName);
      await profilesProvider.clearActiveProfileId();
    }

    await profilesProvider.setProfiles(profiles);
    await transactionProvider.setTransactions(transactions);
    await quickActionsProvider.setQuickActions(quickActions);

    await profilesProvider.fetchAndUpdateProfiles();
    await profilesProvider.fetchAndUpdateActivatedProfileId();
    String activeProfileId = profilesProvider.activatedProfileId;
    await transactionProvider
        .fetchAndUpdateProfileTransactions(activeProfileId);
    await quickActionsProvider
        .fetchAndUpdateProfileQuickActions(activeProfileId);
    await transactionProvider.fetchAndUpdateAllTransactions();
    await quickActionsProvider.fetchAndUpdateAllQuickActions();

    await profilesProvider.calcProfilesData(transactionProvider, debtsProvider);
  }

  Future<List<ProfileModel>> getProfiles() async {
    var dbRef = FirebaseFirestore.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var data = await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(profilesCollectionName)
        .get();
    List<ProfileModel> fetchedProfiles = data.docs
        .map((profile) => ProfileModel.fromJSON(profile.data()))
        .toList();
    return fetchedProfiles;
  }

  Future<List<TransactionModel>> getTransactions() async {
    var dbRef = FirebaseFirestore.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var data = await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(transactionsCollectionName)
        .get();
    List<TransactionModel> fetchedTransactions = data.docs
        .map((transaction) => TransactionModel.fromJSON(transaction.data()))
        .toList();
    return fetchedTransactions;
  }

  Future<List<QuickActionModel>> getQuickActions() async {
    var dbRef = FirebaseFirestore.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var data = await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(quickActionsCollectionName)
        .get();
    List<QuickActionModel> fetchedQuickActions = data.docs.map(
      (quickAction) {
        return QuickActionModel.fromJSON(quickAction.data());
      },
    ).toList();
    return fetchedQuickActions;
  }

  // Future<void> syncUserData(String userPrefsString) async {
  //   String userId = FirebaseAuth.instance.currentUser!.uid;
  //   var dbRef = FirebaseFirestore.instance;
  //   try {
  //     await dbRef
  //         .collection(usersCollectionName)
  //         .doc(userId)
  //         .set({userPrefsCollectionName: userPrefsString});
  //   } catch (error) {
  //     CustomError.log(error: error);
  //   }
  // }
  Future<String?> getUserPrefs() async {
    var dbRef = FirebaseFirestore.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var data = await dbRef.collection(usersCollectionName).doc(userId).get();
    String userData;
    try {
      userData = data.get(userPrefsCollectionName);
      return userData;
    } catch (error) {
      CustomError.log(error: error);
    }
    return null;
  }
}
