import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:smart_wallet/utils/trans_periods_utils.dart';
import '../constants/db_constants.dart';
import '../constants/types.dart';
import '../helpers/custom_error.dart';
import '../helpers/db_helper.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  //? profile transactions
  List<TransactionModel> _transactions = [];
  //? all transactions
  List<TransactionModel> allTransactions = [];

//? not synced transactions from the all transactions
  List<TransactionModel> get notSyncedTransactions {
    return allTransactions
        .where((element) => element.syncFlag != SyncFlags.none)
        .toList();
  }

//? not deleted transactions
  List<TransactionModel> get transactions {
    return _transactions.where((element) => element.deleted == false).toList();
  }

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

//? clear transactions arrays
  void clearAllTransactions() async {
    _transactions.clear();
    allTransactions.clear();
  }

//? add an array of transactions to the local database
  Future<void> setTransactions(List<TransactionModel> transactions) async {
    for (var transaction in transactions) {
      try {
        await DBHelper.insert(transactionsTableName, transaction.toJSON());
      } catch (error) {
        if (kDebugMode) {
          print('Error inserting transactions get from the firestore');
        }
        rethrow;
      }
    }
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
    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(transactionsTableName, newTransaction.toJSON());
    } catch (error) {
      if (kDebugMode) {
        print(
            'Error inserting new transaction , check the transaction provider');
      }
      rethrow;
    }

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
            (transaction) => TransactionModel.fromJSON(transaction),
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
            (transaction) => TransactionModel.fromJSON(transaction),
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
    if (syncing) {
      newTransaction.syncFlag = SyncFlags.none;
    } else if (newTransaction.syncFlag != SyncFlags.add) {
      newTransaction.syncFlag = SyncFlags.edit;
    }

    //* editing transaction on database first
    try {
      await DBHelper.insert(transactionsTableName, newTransaction.toJSON());
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
