// ignore_for_file: unused_element, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../constants/db_constants.dart';
import '../constants/types.dart';
import '../models/quick_action_model.dart';

import '../helpers/db_helper.dart';

//! make the quickActionIndex property nullable
//! it will only exist in the favorite quick actions

class QuickActionsProvider extends ChangeNotifier {
  //? a) quick actions stuff
  List<QuickActionModel> quickActions = [];
  List<QuickActionModel> allQuickActions = [];

  List<QuickActionModel> get notSyncedQuickActions {
    return allQuickActions
        .where((element) => element.needSync == true)
        .toList();
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
    return quickActions.firstWhere((element) => element.id == id);
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

    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(quickActionsTableName, {
        'id': id,
        'title': title,
        'description': description,
        'amount': amount.toString(),
        'createdAt': createdAt.toIso8601String(),
        'transactionType':
            transactionType == TransactionType.income ? 'income' : 'outcome',
        'isFavorite': quickActions.isEmpty ? 'YES' : 'NO',
        'profileId': profileId,
        'quickActionIndex': quickActionIndex.toString(),
        'needSync': 'YES',
      });
    } catch (error) {
      if (kDebugMode) {
        print(
            'Error inserting new transaction , check the transaction provider');
      }
      rethrow;
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
    );
    quickActions.add(quickActionModel);
    notifyListeners();
  }

//* for getting the quickActions from the database
  Future<void> fetchAndUpdateProfileQuickActions(String profileId) async {
    try {
      List<Map<String, dynamic>> data = await DBHelper.getDataWhere(
          quickActionsTableName, 'profileId', profileId);

      List<QuickActionModel> fetchedQuickActions = data.map(
        (quickAction) {
          var test = quickAction['isFavorite'];
          print(quickAction['isFavorite']);
          return QuickActionModel(
            id: quickAction['id'],
            title: quickAction['title'],
            description: quickAction['description'],
            amount: double.parse(quickAction['amount']),
            createdAt: DateTime.parse(quickAction['createdAt']),
            transactionType: quickAction['transactionType'] == 'income'
                ? TransactionType.income
                : TransactionType.outcome,

            //? sqlite doesn't support bool datatype so i will store it as string then fetch it and decide
            isFavorite: quickAction['isFavorite'] == 'YES' ? true : false,
            profileId: quickAction['profileId'],
            quickActionIndex: quickAction['quickActionIndex'] == 'null'
                ? null
                : int.parse(quickAction['quickActionIndex']),
            needSync: quickAction['needSync'] == 'YES' ? true : false,
          );
        },
      ).toList();

      fetchedQuickActions.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      quickActions = fetchedQuickActions;

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
        print('Error fetching quick actions from the database');
      }
      // rethrow;
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
          return QuickActionModel(
            id: quickAction['id'],
            title: quickAction['title'],
            description: quickAction['description'],
            amount: double.parse(quickAction['amount']),
            createdAt: DateTime.parse(quickAction['createdAt']),
            transactionType: quickAction['transactionType'] == 'income'
                ? TransactionType.income
                : TransactionType.outcome,

            //? sqlite doesn't support bool datatype so i will store it as string then fetch it and decide
            isFavorite: quickAction['isFavorite'] == 'YES' ? true : false,
            profileId: quickAction['profileId'],
            quickActionIndex: quickAction['quickActionIndex'] == 'null'
                ? null
                : int.parse(quickAction['quickActionIndex']),
            needSync: quickAction['needSync'] == 'YES' ? true : false,
          );
        },
      ).toList();
      allQuickActions = fetchedQuickActions;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
        print('Error fetching quick actions from the database');
      }
      // rethrow;
    }
    return fetchedQuickActions;
  }

//* for deleting a quickActions
  Future<void> deleteQuickActions(String id) async {
    //* delete from the database first
    try {
      await DBHelper.deleteById(id, quickActionsTableName);
    } catch (error) {
      if (kDebugMode) {
        print(error);
        print('An error occurred during deleting a quick action');
      }
    }

    quickActions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> toggleQuickActionNeedSync(String id) async {
    QuickActionModel quickAction = getQuickById(id);
    quickAction.needSync = !quickAction.needSync;
    await editQuickAction(quickAction);
  }

  Future<void> editQuickActionOnDataBaseOnly(
      QuickActionModel newQuickAction) async {
    try {
      await DBHelper.insert(quickActionsTableName, {
        'id': newQuickAction.id,
        'title': newQuickAction.title,
        'description': newQuickAction.description,
        'amount': newQuickAction.amount.toString(),
        'createdAt': newQuickAction.createdAt.toIso8601String(),
        'transactionType':
            newQuickAction.transactionType == TransactionType.income
                ? 'income'
                : 'outcome',
        'isFavorite': newQuickAction.isFavorite ? 'YES' : 'NO',
        'profileId': newQuickAction.profileId,
        'quickActionIndex': newQuickAction.quickActionIndex.toString(),
        'needSync': newQuickAction.needSync ? 'YES' : 'NO',
      });
    } catch (error) {
      if (kDebugMode) {
        print(
            'Error Editing quick Action in database only , check the quickAction provider');
      }
      rethrow;
    }
  }

//* for editing a quick action
  Future<void> editQuickAction(QuickActionModel newQuickAction) async {
    //* editing quick action on database first
    await editQuickActionOnDataBaseOnly(newQuickAction);
    int quickActionIndex =
        quickActions.indexWhere((element) => element.id == newQuickAction.id);
    quickActions.removeWhere((element) => element.id == newQuickAction.id);
    quickActions.insert(quickActionIndex, newQuickAction);
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
