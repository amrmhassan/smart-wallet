import 'package:flutter/foundation.dart';
import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_wallet/utils/trans_periods_utils.dart';
import '../constants/db_constants.dart';
import '../constants/types.dart';
import '../helpers/custom_error.dart';
import '../helpers/db_helper.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  //? all profile transactions
  List<TransactionModel> _transactions = [];
  List<TransactionModel> allTransactions = [];

  void clearAllTransactions() async {
    _transactions.clear();
    allTransactions.clear();
  }

  Future<void> setTransactions(List<TransactionModel> transactions) async {
    allTransactions = transactions;

    for (var transaction in transactions) {
      try {
        await DBHelper.insert(transactionsTableName, {
          'id': transaction.id,
          'title': transaction.title,
          'description': transaction.description,
          'amount': transaction.amount.toString(),
          'createdAt': transaction.createdAt.toIso8601String(),
          'transactionType':
              transaction.transactionType == TransactionType.income
                  ? TransactionType.income.name
                  : TransactionType.outcome.name,
          'ratioToTotal': transaction.ratioToTotal.toString(),
          'profileId': transaction.profileId,
          'syncFlag': transaction.syncFlag.name,
          'deleted': transaction.deleted == true ? dbTrue : dbFalse,
        });
      } catch (error) {
        if (kDebugMode) {
          print('Error inserting transactions get from the firestore');
        }
        rethrow;
      }
    }
  }

  List<TransactionModel> get notSyncedTransactions {
    return allTransactions
        .where((element) => element.syncFlag != SyncFlags.none)
        .toList();
  }

  List<TransactionModel> get transactions {
    return _transactions.where((element) => element.deleted == false).toList();
  }
  // List<TransactionModel> getProfileTransactions(String profileId) {
  //   return transactions
  //       .where((element) =>
  //           (element.profileId == profileId && element.deleted == false))
  //       .toList();
  // }

//? getting income transactions
  List<TransactionModel> get _incomeTransactions {
    return [
      ...transactions
          .where((element) => element.transactionType == TransactionType.income)
    ];
  }

//? getting outcome transactions
  List<TransactionModel> get _outcomeTransactions {
    return [
      ...transactions.where(
          (element) => element.transactionType == TransactionType.outcome)
    ];
  }

//? transactions depending on the activeTransactionsType
  List<TransactionModel> get displayedTransactions {
    if (currentActiveTransactionType == TransactionType.income) {
      return _incomeTransactions;
    } else if (currentActiveTransactionType == TransactionType.outcome) {
      return _outcomeTransactions;
    } else {
      return [...transactions];
    }
  }

//? getting total income for a profile
  double get totalIncome {
    return foldTransactions(_incomeTransactions);
  }

//? getting total outcome for a profile
  double get totalOutcome {
    return foldTransactions(_outcomeTransactions);
  }

//? getting today's outcome only
  double get todayOutcome {
    TransPeriodUtils transPeriodUtils = TransPeriodUtils(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      transactions: _outcomeTransactions,
    );
    transPeriodUtils.setToday();
    double todayAmount =
        foldTransactions(transPeriodUtils.getTransactionsWithinPeriod());
    return todayAmount;
  }

//? getting yesterday's outcome only
  double get yesterdayOutcome {
    TransPeriodUtils transPeriodUtils = TransPeriodUtils(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      transactions: _outcomeTransactions,
    );
    transPeriodUtils.setYesterday();
    double yesterdayAmount =
        foldTransactions(transPeriodUtils.getTransactionsWithinPeriod());
    return yesterdayAmount;
  }

//? getting total money for a profile, (savings)
  double get totalMoney {
    return totalIncome - totalOutcome;
  }

//? for folding a list of transactions and sum it's amount
  double foldTransactions(List<TransactionModel> transactions) {
    return transactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

//? getting a transaction by id
  TransactionModel getTransactionById(String id) {
    return _transactions.firstWhere((element) => element.id == id);
  }

//? getting the last transaction in the list
//* this will be used to check if the current added transaction has the same amount and transaction type as the last transaction in the list
  TransactionModel getLastTransaction() {
    return transactions[transactions.length - 1];
  }

//? adding new transaction
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
        'syncFlag': SyncFlags.add.name,
        'deleted': dbFalse,
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
      syncFlag: SyncFlags.add,
      deleted: false,
    );
    _transactions.add(newTransaction);
    notifyListeners();
  }

//? get transactinons by a profile id
  Future<void> fetchAndUpdateProfileTransactions(String profileId) async {
    try {
      List<Map<String, dynamic>> data = await DBHelper.getDataWhere(
          transactionsTableName, 'profileId', profileId);

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
              deleted: transaction['deleted'] == dbTrue ? true : false,
              syncFlag: stringToSyncFlag(transaction['syncFlag']),
            ),
          )
          .toList();

      fetchedTransactions.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      _transactions = fetchedTransactions;

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('An error occurred fetching all transactions form database ');
      }
      rethrow;
    }
  }

//? fetching and updating all transactions
  Future<void> fetchAndUpdateAllTransactions() async {
    List<TransactionModel> fetchedTransactions = [];
    try {
      List<Map<String, dynamic>> data =
          await DBHelper.getData(transactionsTableName);

      fetchedTransactions = data
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
              deleted: transaction['deleted'] == dbTrue ? true : false,
              syncFlag: stringToSyncFlag(transaction['syncFlag']),
            ),
          )
          .toList();
      allTransactions = fetchedTransactions;
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print('An error occurred fetching all transactions form database ');
      }
      rethrow;
    }
  }

//? deleting a transaction by id
  Future<void> deleteTransaction(String id) async {
    //* if that transaction is income and deleting it will make the total by negative then throw an error that you can't delete that transaction , you can only edit it to a lower amount but not lower than the current total amount in that profile
    TransactionModel deletedTransaction = getTransactionById(id);
    deletedTransaction.deleted = true;

    if (deletedTransaction.syncFlag == SyncFlags.add) {
      return editTransaction(id, deletedTransaction);
    } else {
      deletedTransaction.syncFlag = SyncFlags.delete;
      return editTransaction(id, deletedTransaction);
    }
  }

  Future<void> changeSyncFlag(String id, SyncFlags newSyncFlag) async {
    TransactionModel transaction = getTransactionById(id);
    transaction.syncFlag = newSyncFlag;

    return editTransaction(id, transaction, true);
  }

//? editing a transaction
  Future<void> editTransaction(
      String transactionId, TransactionModel newTransaction,
      [bool syncing = false]) async {
    //* checking if the transactin is outcome and the it is greater than the current total money
    //* this is the amount that should be compared to the amount of the newTransaction
    if (!syncing) {
      double newAmount = totalMoney - newTransaction.amount;
      if (newTransaction.amount > newAmount &&
          newTransaction.transactionType == TransactionType.outcome) {
        throw CustomError('This expense is larger than your balance.');
      }
    }
    if (newTransaction.syncFlag == SyncFlags.add) {
      newTransaction.syncFlag = SyncFlags.add;
    } else {
      newTransaction.syncFlag = newTransaction.syncFlag;
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
        'syncFlag': newTransaction.syncFlag.name,
        'deleted': newTransaction.deleted ? dbTrue : dbFalse,
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

  //? current active transaction type
  TransactionType currentActiveTransactionType = TransactionType.all;
  //? setting the current active transaction type
  void setCurrentActiveTransactionType(TransactionType transactionType) {
    currentActiveTransactionType = transactionType;
    notifyListeners();
  }
}
