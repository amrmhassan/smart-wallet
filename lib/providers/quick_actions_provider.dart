// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/constants/db_constants.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/models/quick_action_model.dart';

import '../helpers/db_helper.dart';

class QuickActionsProvider extends ChangeNotifier {
  //? a) quick actions stuff
  List<QuickActionModel> _quickActions = [];

//? 1- getting quick actions, with multiple possibilities
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

//? i won't use this now (cause i may not need it and it will need info from another provider so i will need to use proxy provider)
// //* for getting transactions depending on the current chosen quickActions type
//   List<TransactionModel> get displayedQuickActions {
//     if (currentActiveTransactionType == TransactionType.income) {
//       return _incomeQuickActions;
//     } else if (currentActiveTransactionType == TransactionType.outcome) {
//       return _outcomeQuickActions;
//     } else {
//       return [..._quickActions];
//     }
//   }

//* for getting all quick actions no matter it's type
  List<QuickActionModel> get getAllQuickActions {
    return [..._quickActions];
  }

  //? 3- methods to control the quickActions
//* for adding new quick Actions
  Future<void> addQuickAction(String title, String description, double amount,
      TransactionType transactionType) async {
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
    );
    _quickActions.add(quickActionModel);
    notifyListeners();
  }

//* for getting the quickActions from the database
  Future<void> fetchAndUpdateQuickActions() async {
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(quickActionsTableName);

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
  void deleteQuickActions(String id) {
    _quickActions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

//* for editing a quick action
  void editQuickAction(String quickActionId, QuickActionModel newQuickActions) {
    int quickActionIndex =
        _quickActions.indexWhere((element) => element.id == quickActionId);
    _quickActions.removeWhere((element) => element.id == quickActionId);
    _quickActions.insert(quickActionIndex, newQuickActions);
    notifyListeners();
  }
}
