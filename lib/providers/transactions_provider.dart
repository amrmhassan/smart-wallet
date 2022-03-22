import 'package:flutter/cupertino.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/models/transaction_model.dart';

import '../constants/transactions_constant.dart';

class TransactionProvider extends ChangeNotifier {
  //? transactions stuff
  List<TransactionModel> _transactions = [];

//* transactions getter
  List<TransactionModel> get displayedTransactions {
    if (currentActiveTransactionType == TransactionType.income) {
      return [
        ..._transactions.where(
            (element) => element.transactionType == TransactionType.income)
      ];
    } else if (currentActiveTransactionType == TransactionType.outcome) {
      return [
        ..._transactions.where(
            (element) => element.transactionType == TransactionType.outcome)
      ];
    } else {
      return [..._transactions];
    }
  }

//* for adding new transaction
  void addTransaction(TransactionModel transaction) {
    print('Now we have ${_transactions.length} transactions');
    _transactions.add(transaction);

    notifyListeners();
  }

  //* for getting the current money in the profile
  double get totalMoney {
    double totalAmount = _transactions.fold<double>(
      0,
      (previousValue, element) =>
          element.transactionType == TransactionType.income
              ? previousValue + element.amount
              : previousValue - element.amount,
    );
    return totalAmount;
  }

//* for getting the transactions from the database
  void fetchAndUpdateTransactions() {
    _transactions = transactionsConstant;
    notifyListeners();
  }

//* for deleting a transaction
  void deleteTransaction(String id) {
    _transactions.removeWhere((element) => element.id == id);
    notifyListeners();
  }

//* for editing a transaction
  void editTransaction(String transactionId, TransactionModel newTransaction) {
    int transactionIndex =
        _transactions.indexWhere((element) => element.id == transactionId);
    _transactions.removeWhere((element) => element.id == transactionId);
    _transactions.insert(transactionIndex, newTransaction);
    notifyListeners();
  }

  //? transaction type stuff

  TransactionType currentActiveTransactionType = TransactionType.all;
  void setCurrentActiveTransactionType(TransactionType transactionType) {
    currentActiveTransactionType = transactionType;
    notifyListeners();
  }
}
