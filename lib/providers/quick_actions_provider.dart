import 'package:flutter/cupertino.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/models/transaction_model.dart';

class QuickActionsProvider extends ChangeNotifier {
  //? a) quick actions stuff
  List<TransactionModel> _quickActions = [];

//? 1- getting quick actions, with multiple possibilities
//* for getting the income quick actions only
  List<TransactionModel> get _incomeQuickActions {
    return [
      ..._quickActions
          .where((element) => element.transactionType == TransactionType.income)
    ];
  }

//* for getting the outcome quick actions only
  List<TransactionModel> get _outcomeQuickActions {
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
  List<TransactionModel> get getAllQuickActions {
    return [..._quickActions];
  }

  //? 3- methods to control the quickActions
//* for adding new quick Actions
  void addQuickAction(TransactionModel quickActionsModel) {
    _quickActions.add(quickActionsModel);
    notifyListeners();
  }

//* for getting the quickActions from the database
  void fetchAndUpdateQuickActions() {}

//* for deleting a quickActions
  void deleteQuickActions(String id) {
    _quickActions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

//* for editing a quick action
  void editQuickAction(String quickActionId, TransactionModel newQuickActions) {
    int quickActionIndex =
        _quickActions.indexWhere((element) => element.id == quickActionId);
    _quickActions.removeWhere((element) => element.id == quickActionId);
    _quickActions.insert(quickActionIndex, newQuickActions);
    notifyListeners();
  }
}
