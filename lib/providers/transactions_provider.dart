import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:wallet_app/constants/transactions_constants.dart';
import '../constants/db_constants.dart';
import '../constants/types.dart';
import '../helpers/custom_error.dart';
import '../helpers/db_helper.dart';
import '../models/transaction_model.dart';

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

  //* for loading the dummy transactions
  void loadDummyTransactions() {
    _transactions = _transactions + dummyTransactionsFixedDate;
    notifyListeners();
  }

  //* for getting a transaction by its id
  TransactionModel getTransactionById(String id) {
    return _transactions.firstWhere((element) => element.id == id);
  }

  //* for getting the last added transaction

  TransactionModel getLastTransaction() {
    return _transactions[_transactions.length - 1];
  }

//* for adding new transaction
  Future<void> addTransaction(String title, String description, double amount,
      TransactionType transactionType, String profileId) async {
    //* checking if the transaction added will make the current balance negative
    //* i removed this cause i will ask the user to add this even it is greater than his current money
    if (amount > totalMoney && transactionType == TransactionType.outcome) {
      throw CustomError(
          'This expense is larger than your balance. You can add a debt instead.');
    }

    //* initializing the transaction data like (createdAt, id, ratioToTotal...)
    String id = const Uuid().v4();
    DateTime createdAt = DateTime.now();
    double newTotalMoney = totalMoney;
    //* this line is to ensure that ......
    newTotalMoney = transactionType == TransactionType.income
        ? totalMoney + amount
        : totalMoney - amount;
    double ratioToTotal = (amount / newTotalMoney).abs();
    //* this line is to ensure that .......
    ratioToTotal = ratioToTotal == double.infinity ? 1 : ratioToTotal;

    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(transactionsTableName, {
        'id': id,
        'title': title,
        'description': description,
        'amount': amount.toString(),
        'createdAt': createdAt.toIso8601String(),
        'transactionType':
            transactionType == TransactionType.income ? 'income' : 'outcome',
        'ratioToTotal': ratioToTotal.toString(),
        'profileId': profileId,
      });
    } catch (error) {
      if (kDebugMode) {
        print(
            'Error inserting new transaction , check the transaction provider');
      }
      rethrow;
    }

    TransactionModel newTransaction = TransactionModel(
      id: id,
      title: title,
      description: description,
      amount: amount,
      createdAt: createdAt,
      transactionType: transactionType,
      ratioToTotal: ratioToTotal,
      profileId: profileId,
    );
    _transactions.add(newTransaction);
    notifyListeners();
  }

//* for getting the transactions from the database
  Future<void> fetchAndUpdateTransactions(String activatedProfileId) async {
    try {
      List<Map<String, dynamic>> data = await DBHelper.getDataWhere(
          transactionsTableName, 'profileId', activatedProfileId);

      List<TransactionModel> fetchedTransactions = data
          .map(
            (transaction) => TransactionModel(
              id: transaction['id'],
              title: transaction['title'],
              description: transaction['description'],
              amount: double.parse(transaction['amount']),
              createdAt: DateTime.parse(transaction['createdAt']),
              transactionType: transaction['transactionType'] == 'income'
                  ? TransactionType.income
                  : TransactionType.outcome,
              ratioToTotal: double.parse(
                transaction['ratioToTotal'],
              ),
              profileId: transaction['profileId'],
            ),
          )
          .toList();
      _transactions = fetchedTransactions;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('An error occurred fetching transactions form database');
      }
      //! in the final version activate that line
      // rethrow;
    }
  }

//* for deleting a transaction
  Future<void> deleteTransaction(String id) async {
    //* if that transaction is income and deleting it will make the total by negative then throw an error that you can't delete that transaction , you can only edit it to a lower amount but not lower than the current total amount in that profile
    _transactions.removeWhere((element) {
      if (element.transactionType == TransactionType.income &&
          element.amount > totalMoney &&
          element.id == id) {
        throw CustomError(
            'Your total balance will be negative, you can\'t delete it.');
      }
      return element.id == id;
    });

    //* delete from the database second
    try {
      await DBHelper.deleteById(id, transactionsTableName);
    } catch (error) {
      if (kDebugMode) {
        print(error);
        print('An error occurred during deleting a transaction');
      }
    }
    notifyListeners();
  }

//* for editing a transaction
  Future<void> editTransaction(
      String transactionId, TransactionModel newTransaction) async {
    //? i commented this cause it has no value
    // //* first checking if the transaction exist in the _transactions

    // TransactionModel? oldTransaction;
    // try {
    //   oldTransaction =
    //       _transactions.firstWhere((element) => element.id == transactionId);
    // } catch (error) {
    //   //* this transaction doesn't exist in the transactions
    //   rethrow;
    // }
    // //* return if the transaction doesn't exist
    // if (oldTransaction == null) {
    //   throw CustomError('This transaction doesn\'t exit to be deleted');
    // }

    //* checking if the transactin is outcome and the it is greater than the current total money
    //* this is the amount that should be compared to the amount of the newTransaction
    double newAmount = totalMoney - newTransaction.amount;
    if (newTransaction.amount > newAmount &&
        newTransaction.transactionType == TransactionType.outcome) {
      throw CustomError('This expense is larger than your balance.');
    }

    //* editing transaction on database first
    try {
      await DBHelper.insert(transactionsTableName, {
        'id': newTransaction.id,
        'title': newTransaction.title,
        'description': newTransaction.description,
        'amount': newTransaction.amount.toString(),
        'createdAt': newTransaction.createdAt.toIso8601String(),
        'transactionType':
            newTransaction.transactionType == TransactionType.income
                ? 'income'
                : 'outcome',
        'ratioToTotal': newTransaction.ratioToTotal.toString(),
        'profileId': newTransaction.profileId,
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error Editing transaction , check the transaction provider');
      }
      rethrow;
    }
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
