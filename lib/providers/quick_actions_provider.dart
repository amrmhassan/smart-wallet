// ignore_for_file: unused_element, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:uuid/uuid.dart';
import '../constants/db_constants.dart';
import '../constants/types.dart';
import '../models/quick_action_model.dart';

import '../helpers/db_helper.dart';

class QuickActionsProvider extends ChangeNotifier {
  //? a) quick actions stuff
  List<QuickActionModel> _quickActions = [];
  List<QuickActionModel> _allQuickActions = [];

  void clearAllQuickActions() async {
    _quickActions.clear();
    _allQuickActions.clear();
  }

  Future<void> setQuickActions(List<QuickActionModel> quickActions) async {
    for (var quickAction in quickActions) {
      try {
        await DBHelper.insert(quickActionsTableName, quickAction.toJSON());
      } catch (error, stackTrace) {
        CustomError.log(error: error, stackTrace: stackTrace);
      }
    }
  }

  List<QuickActionModel> get notSyncedQuickActions {
    return _allQuickActions
        .where((element) => element.syncFlag != SyncFlags.noSyncing)
        .toList();
  }

  List<QuickActionModel> get allQuickActions {
    return _allQuickActions
        .where((element) => element.deleted == false)
        .toList();
  }

  List<QuickActionModel> get quickActions {
    return _quickActions.where((element) => element.deleted == false).toList();
  }

  int get quickActionsLength {
    return quickActions.length;
  }

//? 1- getting quick actions, with multiple possibilities

//* for getting the favorite quick actions only
  List<QuickActionModel> get getFavoriteQuickActions {
    var favQuickActions = [
      ...quickActions.where((element) => element.isFavorite == true),
    ];
    favQuickActions.sort(
        (a, b) => ((a.quickActionIndex ?? 0) - (b.quickActionIndex ?? 0)));
    return favQuickActions;
  }

//* for getting the income quick actions only
  List<QuickActionModel> get _incomeQuickActions {
    return [
      ...quickActions
          .where((element) => element.transactionType == TransactionType.income)
    ];
  }

//* for getting the outcome quick actions only
  List<QuickActionModel> get _outcomeQuickActions {
    return [
      ...quickActions.where(
          (element) => element.transactionType == TransactionType.outcome)
    ];
  }

//* for getting transactions depending on the current chosen quickActions type
  List<QuickActionModel> get displayedQuickActions {
    if (currentActiveQuickActionType == TransactionType.income) {
      return _incomeQuickActions;
    } else if (currentActiveQuickActionType == TransactionType.outcome) {
      return _outcomeQuickActions;
    } else {
      return [...quickActions];
    }
  }

  //* for getting a quick actions by its id
  QuickActionModel getQuickById(String id) {
    return _quickActions.firstWhere((element) => element.id == id);
  }

  //? 3- methods to control the quickActions
//* for adding new quick Actions
  Future<void> addQuickAction(String title, String description, double amount,
      TransactionType transactionType, String profileId) async {
    String id = Uuid().v4();
    DateTime createdAt = DateTime.now();

//* here checking if the added quick action is the first
//* to make it favorite and make it's quickActionIndex prop to be zero
    int? quickActionIndex;
    if (quickActions.isEmpty) {
      quickActionIndex = 0;
    } else {
      quickActionIndex = null;
    }

    QuickActionModel quickActionModel = QuickActionModel(
      id: id,
      title: title,
      description: description,
      amount: amount,
      createdAt: createdAt,
      transactionType: transactionType,
      isFavorite: quickActions.isEmpty ? true : false,
      profileId: profileId,
      quickActionIndex: quickActionIndex,
      syncFlag: SyncFlags.add,
      deleted: false,
    );
    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(quickActionsTableName, quickActionModel.toJSON());
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
    _quickActions.add(quickActionModel);
    notifyListeners();
  }

//* for getting the quickActions from the database
  Future<void> fetchAndUpdateProfileQuickActions(String profileId) async {
    try {
      List<Map<String, dynamic>> data = await DBHelper.getDataWhere(
          quickActionsTableName, 'profileId', profileId);

      List<QuickActionModel> fetchedQuickActions = data.map(
        (quickAction) {
          return QuickActionModel.fromJSON(quickAction);
        },
      ).toList();

      fetchedQuickActions.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      _quickActions = fetchedQuickActions;

      notifyListeners();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }

//* for getting the all quick Actions from the database
  Future<List<QuickActionModel>> fetchAndUpdateAllQuickActions() async {
    List<QuickActionModel> fetchedQuickActions = [];
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(quickActionsTableName);

      fetchedQuickActions = data.map(
        (quickAction) {
          return QuickActionModel.fromJSON(quickAction);
        },
      ).toList();
      _allQuickActions = fetchedQuickActions;
      notifyListeners();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
    return fetchedQuickActions;
  }

// deleting a quickAction by id
  Future<void> deleteQuickActions(String id) async {
    //* if that transaction is income and deleting it will make the total by negative then throw an error that you can't delete that transaction , you can only edit it to a lower amount but not lower than the current total amount in that profile
    QuickActionModel deletedQuickAction = getQuickById(id);
    deletedQuickAction.deleted = true;

    if (deletedQuickAction.syncFlag == SyncFlags.add) {
      return editQuickAction(deletedQuickAction);
    } else {
      deletedQuickAction.syncFlag = SyncFlags.delete;
      return editQuickAction(deletedQuickAction);
    }
  }

//! use this only with the syncing provider
  Future<void> changeSyncFlag(String id, SyncFlags newSyncFlag) async {
    QuickActionModel quickAction = getQuickById(id);
    quickAction.syncFlag = newSyncFlag;

    return editQuickAction(quickAction, true);
  }

  Future<void> editQuickActionOnDataBaseOnly(
      QuickActionModel newQuickAction) async {
    try {
      await DBHelper.insert(quickActionsTableName, newQuickAction.toJSON());
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }

//* for editing a quick action
  Future<void> editQuickAction(QuickActionModel newQuickAction,
      [bool syncing = false]) async {
    if (syncing) {
      newQuickAction.syncFlag = SyncFlags.noSyncing;
    } else if (newQuickAction.syncFlag != SyncFlags.add) {
      newQuickAction.syncFlag = SyncFlags.edit;
    }
    //* editing quick action on database first
    await editQuickActionOnDataBaseOnly(newQuickAction);
    int quickActionIndex =
        _quickActions.indexWhere((element) => element.id == newQuickAction.id);
    _quickActions.removeWhere((element) => element.id == newQuickAction.id);
    _quickActions.insert(quickActionIndex, newQuickAction);
    notifyListeners();
  }

//* for making a quick action favorite
  Future<void> toggleFavouriteQuickAction(String quickActionId) async {
    QuickActionModel newQuickAction = getQuickById(quickActionId);
    newQuickAction.isFavorite = !newQuickAction.isFavorite;
    if (newQuickAction.isFavorite) {
      //* i subtracted one to make the index 0, 1, 2...
      //* when adding new quickaction i made the quickActionIndex to be _quickActions.length cause there will be no quickactions at first
      //* but here there will be quick action but i just need to a
      newQuickAction.quickActionIndex = getFavoriteQuickActions.length - 1;
    } else {
      newQuickAction.quickActionIndex == null;
    }
    // if (newQuickAction.syncFlag == SyncFlags.add) {
    //   newQuickAction.syncFlag = SyncFlags.add;
    // } else {
    //   newQuickAction.syncFlag = SyncFlags.edit;
    // }
    return editQuickAction(newQuickAction);
  }

//* for changing the order of the favorite quick actions
  Future<void> updateFavoriteQuickActionsIndex(
      List<QuickActionModel> newFavoriteQuickActions) async {
    //? here i will edit a mass favorite quick actions
    for (var quickAction in newFavoriteQuickActions) {
      int index = newFavoriteQuickActions.indexOf(quickAction);
      quickAction.quickActionIndex = index;

      await editQuickActionOnDataBaseOnly(quickAction);
    }
  }
  //? quick transactions type stuff

  TransactionType currentActiveQuickActionType = TransactionType.all;
  void setcurrentActiveQuickActionType(TransactionType transactionType) {
    currentActiveQuickActionType = transactionType;
    notifyListeners();
  }
}
