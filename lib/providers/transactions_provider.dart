import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wallet_app/constants/types.dart';
import 'package:wallet_app/models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  //? a) transactions stuff
  List<TransactionModel> _transactions = [];

//? 1- getting transactions, with multiple possibilities
//* for getting the income transactions only
  List<TransactionModel> get _incomeTransactions {
    return [
      ..._transactions
          .where((element) => element.transactionType == TransactionType.income)
    ];
  }

//* for getting the outcome transactions only
  List<TransactionModel> get _outcomeTransactions {
    return [
      ..._transactions.where(
          (element) => element.transactionType == TransactionType.outcome)
    ];
  }

//* for getting transactions depending on the current chosen transaction type
  List<TransactionModel> get displayedTransactions {
    if (currentActiveTransactionType == TransactionType.income) {
      return _incomeTransactions;
    } else if (currentActiveTransactionType == TransactionType.outcome) {
      return _outcomeTransactions;
    } else {
      return [..._transactions];
    }
  }

//* for getting all transactions no matter it's type
  List<TransactionModel> get getAllTransactions {
    return [..._transactions];
  }

//? 2- for getting  calculations on the transactions
  //* for getting the total income
  double get totalIncome {
    double totalIncomeAmount = _incomeTransactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    return totalIncomeAmount;
  }

  //* for getting the total outcome
  double get totalOutcome {
    double totalIncomeAmount = _outcomeTransactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    return totalIncomeAmount;
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

  //? 3- methods to control the transactions
//* for adding new transaction
  void addTransaction(TransactionModel transaction) {
    if (transaction.amount > totalMoney &&
        transaction.transactionType == TransactionType.outcome) {
      throw Exception(
          'Outcome Transaction is larger than the total amount of the money');
    }
    _transactions.add(transaction);
    notifyListeners();
  }

//* for getting the transactions from the database
  void fetchAndUpdateTransactions() {}

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

  //? b) transaction type stuff

  TransactionType currentActiveTransactionType = TransactionType.all;
  void setCurrentActiveTransactionType(TransactionType transactionType) {
    currentActiveTransactionType = transactionType;
    notifyListeners();
  }
}
