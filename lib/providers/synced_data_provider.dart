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
        if (profile.syncFlag == SyncFlags.add) {
          await addProfile(profile);
        } else if (profile.syncFlag == SyncFlags.edit) {
          await updateProfile(profile);
        } else if (profile.syncFlag == SyncFlags.delete) {
          await updateProfile(profile);
        }
        await profilesProvider.changeSyncFlag(profile.id, SyncFlags.none);
      }
      for (var transaction in transactionProvider.notSyncedTransactions) {
        if (transaction.syncFlag == SyncFlags.add) {
          await addTransaction(transaction);
        } else if (transaction.syncFlag == SyncFlags.edit) {
          await editTransaction(transaction);
        } else if (transaction.syncFlag == SyncFlags.delete) {
          await editTransaction(transaction);
        }

        await transactionProvider.changeSyncFlag(
            transaction.id, SyncFlags.none);
      }

      for (var quickAction in quickActionsProvider.notSyncedQuickActions) {
        if (quickAction.syncFlag == SyncFlags.add) {
          await addQuickAction(quickAction);
        } else if (quickAction.syncFlag == SyncFlags.edit) {
          await editQuickAction(quickAction);
        } else if (quickAction.syncFlag == SyncFlags.delete) {
          await editQuickAction(quickAction);
        }
        await quickActionsProvider.changeSyncFlag(
            quickAction.id, SyncFlags.none);
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
    QuickActionsProvider quickActionsProvider,
  ) async {
    List<ProfileModel> profiles = await getProfiles();
    List<TransactionModel> transactions = await getTransactions();
    List<QuickActionModel> quickActions = await getQuickActions();

//! there is an error in fetching the quick actions and it is about getting isFavorite and quickActionIndex
    profilesProvider.clearAllProfiles();
    transactionProvider.clearAllTransactions();
    quickActionsProvider.clearAllQuickActions();
    await DBHelper.deleteDatabase(dbName);
    await profilesProvider.clearActiveProfileId();

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
        .map(
          (profile) => ProfileModel(
            id: profile['id'],
            name: profile['name'],
            income: profile['income'],
            outcome: profile['outcome'],
            createdAt: DateTime.parse(profile['createdAt']),
            lastActivatedDate: profile['lastActivatedDate'] == 'null'
                ? null
                : DateTime.parse(profile['lastActivatedDate']),
            userId: profile['userId'],
            syncFlag: SyncFlags.none,
            deleted: profile['deleted'],
          ),
        )
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
        .map(
          (transaction) => TransactionModel(
            id: transaction['id'],
            title: transaction['title'],
            description: transaction['description'],
            amount: transaction['amount'],
            createdAt: (transaction['createdAt'] as Timestamp).toDate(),
            profileId: transaction['profileId'],
            ratioToTotal: transaction['ratioToTotal'],
            transactionType:
                transaction['transactionType'] == TransactionType.income.name
                    ? TransactionType.income
                    : TransactionType.outcome,
            deleted: transaction['deleted'],
            syncFlag: SyncFlags.none,
            userId: transaction['userId'],
          ),
        )
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
        return QuickActionModel(
          id: quickAction['id'],
          title: quickAction['title'],
          description: quickAction['description'],
          amount: quickAction['amount'],
          createdAt: (quickAction['createdAt'] as Timestamp).toDate(),
          profileId: quickAction['profileId'],
          transactionType:
              quickAction['transactionType'] == TransactionType.income.name
                  ? TransactionType.income
                  : TransactionType.outcome,
          deleted: quickAction['deleted'],
          syncFlag: SyncFlags.none,
          userId: quickAction['userId'],
          isFavorite: quickAction['isFavorite'],
          quickActionIndex: quickAction['quickActionIndex'],
        );
      },
    ).toList();
    return fetchedQuickActions;
  }
}
