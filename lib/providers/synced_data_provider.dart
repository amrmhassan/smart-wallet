import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/helpers/db_helper.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

class SyncedDataProvider extends ChangeNotifier {
  //# ********* Syncing data to firestore **********#//
//? for syncing all data( profiles, transactions, quick Actions)
  Future<void> syncAllData(
      ProfilesProvider profilesProvider,
      TransactionProvider transactionProvider,
      QuickActionsProvider quickActionsProvider) async {
    try {
      for (var profile in profilesProvider.notSyncedProfiles) {
        //* i made this just to prevent syncing the profile with the sync flag add or anything else
        //* and to ensure that it would by synced with the none flag to the firestore
        SyncFlags currentSyncFlag = profile.syncFlag;
        profile.syncFlag = SyncFlags.none;
        await profilesProvider.changeSyncFlag(profile.id, SyncFlags.none);

        if (currentSyncFlag == SyncFlags.add) {
          await addProfile(profile);
        } else if (currentSyncFlag == SyncFlags.edit) {
          await updateProfile(profile);
        } else if (currentSyncFlag == SyncFlags.delete) {
          await updateProfile(profile);
        }
      }
      for (var transaction in transactionProvider.notSyncedTransactions) {
        SyncFlags currentSyncFlag = transaction.syncFlag;
        transaction.syncFlag = SyncFlags.none;
        await transactionProvider.changeSyncFlag(
            transaction.id, SyncFlags.none);

        if (currentSyncFlag == SyncFlags.add) {
          await addTransaction(transaction);
        } else if (currentSyncFlag == SyncFlags.edit) {
          await editTransaction(transaction);
        } else if (currentSyncFlag == SyncFlags.delete) {
          await editTransaction(transaction);
        }
      }

      for (var quickAction in quickActionsProvider.notSyncedQuickActions) {
        SyncFlags currentSyncFlag = quickAction.syncFlag;
        await quickActionsProvider.changeSyncFlag(
            quickAction.id, SyncFlags.none);
        quickAction.syncFlag = SyncFlags.none;

        if (currentSyncFlag == SyncFlags.add) {
          await addQuickAction(quickAction);
        } else if (currentSyncFlag == SyncFlags.edit) {
          await editQuickAction(quickAction);
        } else if (currentSyncFlag == SyncFlags.delete) {
          await editQuickAction(quickAction);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      rethrow;
    }
  }

//# 1] profiles
//? for adding a profile to the firestore for the first time
  Future<void> addProfile(
    ProfileModel profile,
  ) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(profilesCollectionName)
        .doc(profile.id)
        .set(profile.toJSON());
  }

//? for updating an existing profile in the firestore
  Future<void> updateProfile(ProfileModel profile) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;
    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(profilesCollectionName)
        .doc(profile.id)
        .update(profile.toJSON());
  }

//# 2] transactions
//? for adding a transaction to the firestore for the first time
  Future<void> addTransaction(TransactionModel transactionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(transactionsCollectionName)
        .doc(transactionModel.id)
        .set(transactionModel.toJSON());
  }

//? for editing a transaction
  Future<void> editTransaction(TransactionModel transactionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(transactionsCollectionName)
        .doc(transactionModel.id)
        .update(transactionModel.toJSON());
  }

//# 3] quick actions
//? adding a quick Action
  Future<void> addQuickAction(QuickActionModel quickActionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(quickActionsCollectionName)
        .doc(quickActionModel.id)
        .set(quickActionModel.toJSON());
  }

//? editing a quick Action
  Future<void> editQuickAction(QuickActionModel quickActionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(quickActionsCollectionName)
        .doc(quickActionModel.id)
        .update(quickActionModel.toJSON());
  }

  //# ********* Fetching data from firestore **********#//

  Future<void> getAllData(
    ProfilesProvider profilesProvider,
    TransactionProvider transactionProvider,
    QuickActionsProvider quickActionsProvider, [
    bool delete = false,
  ]) async {
    List<ProfileModel> profiles = await getProfiles();
    List<TransactionModel> transactions = await getTransactions();
    List<QuickActionModel> quickActions = await getQuickActions();
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
}
