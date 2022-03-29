// ignore_for_file: unused_element, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../constants/db_constants.dart';
import '../constants/types.dart';
import '../models/quick_action_model.dart';

import '../helpers/db_helper.dart';

class QuickActionsProvider extends ChangeNotifier {
  //? a) quick actions stuff
  List<QuickActionModel> _quickActions = [];

//? 1- getting quick actions, with multiple possibilities

//* for getting the favorite quick actions only
  List<QuickActionModel> get getFavoriteQuickActions {
    return [
      ..._quickActions.where((element) => element.isFavorite == true),
    ];
  }

//* for getting the income quick actions only
  List<QuickActionModel> get _incomeQuickActions {
    return [
      ..._quickActions
          .where((element) => element.transactionType == TransactionType.income)
    ];
  }

//* for getting the outcome quick actions only
  List<QuickActionModel> get _outcomeQuickActions {
    return [
      ..._quickActions.where(
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
      return [..._quickActions];
    }
  }

  //* for getting a quick actions by its id
  QuickActionModel getQuickById(String id) {
    return _quickActions.firstWhere((element) => element.id == id);
  }

//* for getting all quick actions no matter it's type
  List<QuickActionModel> get getAllQuickActions {
    return [..._quickActions];
  }

  //? 3- methods to control the quickActions
//* for adding new quick Actions
  Future<void> addQuickAction(String title, String description, double amount,
      TransactionType transactionType, String profileId) async {
    String id = Uuid().v4();
    DateTime createdAt = DateTime.now();

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
        'isFavorite': 'false',
        'profileId': profileId,
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
      isFavorite: false,
      profileId: profileId,
    );
    _quickActions.add(quickActionModel);
    notifyListeners();
  }

//* for getting the quickActions from the database
  Future<void> fetchAndUpdateQuickActions(String activatedProfileId) async {
    try {
      List<Map<String, dynamic>> data = await DBHelper.getDataWhere(
          quickActionsTableName, 'profileId', activatedProfileId);

      List<QuickActionModel> fetchedQuickActions = data
          .map((quickAction) => QuickActionModel(
                id: quickAction['id'],
                title: quickAction['title'],
                description: quickAction['description'],
                amount: double.parse(quickAction['amount']),
                createdAt: DateTime.parse(quickAction['createdAt']),
                transactionType: quickAction['transactionType'] == 'income'
                    ? TransactionType.income
                    : TransactionType.outcome,

                //? sqlite doesn't support bool datatype so i will store it as string then fetch it and decide
                isFavorite: quickAction['isFavorite'] == null
                    ? false
                    : quickAction['isFavorite'] == 'true'
                        ? true
                        : false,
                profileId: quickAction['profileId'],
              ))
          .toList();
      _quickActions = fetchedQuickActions;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching quick actions from the database');
      }
      // rethrow;
    }
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

    _quickActions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

//* for editing a quick action
  Future<void> editQuickAction(
      String quickActionId, QuickActionModel newQuickAction) async {
    //* editing quick action on database first
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
        'isFavorite': newQuickAction.isFavorite.toString(),
        'profileId': newQuickAction.profileId,
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error Editing quick Action , check the quickAction provider');
      }
      rethrow;
    }
    int transactionIndex =
        _quickActions.indexWhere((element) => element.id == quickActionId);
    _quickActions.removeWhere((element) => element.id == quickActionId);
    _quickActions.insert(transactionIndex, newQuickAction);
    notifyListeners();
  }

//* for making a quick action favorite
  Future<void> toggleFavouriteQuickAction(String quickActionId) async {
    QuickActionModel newQuickAction = getQuickById(quickActionId);
    newQuickAction.isFavorite = !newQuickAction.isFavorite;

    return editQuickAction(quickActionId, newQuickAction);
  }

  //? quick transactions type stuff

  TransactionType currentActiveQuickActionType = TransactionType.all;
  void setcurrentActiveQuickActionType(TransactionType transactionType) {
    currentActiveQuickActionType = transactionType;
    notifyListeners();
  }
}
