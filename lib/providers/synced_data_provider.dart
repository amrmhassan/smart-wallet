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
  final ProfilesProvider? profilesProvider;
  final TransactionProvider? transactionProvider;
  final QuickActionsProvider? quickActionsProvider;

  SyncedDataProvider({
    required this.profilesProvider,
    required this.transactionProvider,
    required this.quickActionsProvider,
  });

  List<String> profilesIDsToSync = [];
  List<String> transactionsIDsToSync = [];
  List<String> quickActionsIDsToSync = [];

  Future<void> syncAllData() async {
    if (profilesProvider == null ||
        transactionProvider == null ||
        quickActionsProvider == null) return;
    try {
      for (var profile in profilesProvider!.profiles) {
        if (kDebugMode) {
          print(' profile ${profile.needSync}');
        }
        if (profile.needSync) {
          await addProfile(profile);
          await profilesProvider!.toggleProfileNeedSync(profile.id);
        }
      }
      for (var transaction in transactionProvider!.transactions) {
        if (kDebugMode) {
          print(' transaction ${transaction.needSync}');
        }

        if (transaction.needSync) {
          await addTransaction(transaction);
          await transactionProvider!.toggleTransactionNeedSync(transaction.id);
        }
      }

      for (var quickAction in quickActionsProvider!.allQuickActions) {
        if (kDebugMode) {
          print(' quickAction ${quickAction.needSync}');
        }

        if (quickAction.needSync) {
          await addQuickAction(quickAction);
          await quickActionsProvider!.toggleQuickActionNeedSync(quickAction.id);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
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
        .add({
      'activated': profile.activated,
      'createdAt': profile.createdAt.toIso8601String(),
      'id': profile.id,
      'income': profile.income,
      'lastActivatedDate': profile.lastActivatedDate == null
          ? 'null'
          : profile.lastActivatedDate!.toIso8601String(),
      'name': profile.name,
      'outcome': profile.outcome,
      'userId': userId,
    });
  }

  Future<void> addTransaction(TransactionModel transactionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(transactionsCollectionName)
        .add({
      'id': transactionModel.id,
      'title': transactionModel.title,
      'description': transactionModel.description,
      'amount': transactionModel.amount,
      'createdAt': transactionModel.createdAt,
      'transactionType':
          transactionModel.transactionType == TransactionType.income
              ? 'income'
              : 'outcome',
      'ratioToTotal': transactionModel.ratioToTotal,
      'profileId': transactionModel.profileId,
      'userId': userId,
    });
  }

  Future<void> addQuickAction(QuickActionModel quickActionModel) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var dbRef = FirebaseFirestore.instance;

    await dbRef
        .collection(usersCollectionName)
        .doc(userId)
        .collection(quickActionsCollectionName)
        .add({
      'id': quickActionModel.id,
      'title': quickActionModel.title,
      'description': quickActionModel.description,
      'amount': quickActionModel.amount,
      'createdAt': quickActionModel.createdAt,
      'transactionType':
          quickActionModel.transactionType == TransactionType.income
              ? 'income'
              : 'outcome',
      'isFavorite': quickActionModel.isFavorite,
      'profileId': quickActionModel.profileId,
      'quickActionIndex': quickActionModel.quickActionIndex,
      'userId': userId,
    });
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
            activated: profile['activated'],
            lastActivatedDate: profile['lastActivatedDate'] == 'null'
                ? null
                : DateTime.parse(profile['lastActivatedDate']),
            needSync: false,
            userId: profile['userId'],
          ),
        )
        .toList();
    print(fetchedProfiles.length);
    return fetchedProfiles;
  }
}
