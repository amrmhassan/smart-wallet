import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_wallet/constants/db_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/quick_actions_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

class SyncedDataProvider extends ChangeNotifier {
  List<String> profilesIDsToSync = [];
  List<String> transactionsIDsToSync = [];
  List<String> quickActionsIDsToSync = [];

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
        print(quickAction.toJSON());
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

  Future<List<ProfileModel>> fetchSyncedProfiles() async {
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
          ),
        )
        .toList();
    return fetchedProfiles;
  }
}
