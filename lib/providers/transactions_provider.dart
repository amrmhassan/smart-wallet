// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/models/add_transaction_message_model.dart';
import 'package:smart_wallet/models/day_start_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/utils/general_utils.dart';
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
  List<TransactionModel> _allTransactions = [];

//? not synced transactions from the all transactions
  List<TransactionModel> get notSyncedTransactions {
    return _allTransactions
        .where((element) => element.syncFlag != SyncFlags.noSyncing)
        .toList();
  }

  List<TransactionModel> get allTransactions {
    return _allTransactions
        .where((element) => element.deleted == false)
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

//? 1] getting today's outcome only
  double todayOutcome(DayStartModel defaultDayStart) {
    TransPeriodUtils transPeriodUtils = TransPeriodUtils(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        transactions: _outcomeTransactions,
        defaultDayStart: defaultDayStart);
    transPeriodUtils.setToday();
    double todayAmount =
        foldTransactions(transPeriodUtils.getTransactionsWithinPeriod());
    return todayAmount;
  }

  //? 2] getting yesterday's outcome only
  double yesterdayOutcome(DayStartModel defaultDayStart) {
    TransPeriodUtils transPeriodUtils = TransPeriodUtils(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        transactions: _outcomeTransactions,
        defaultDayStart: defaultDayStart);
    transPeriodUtils.setYesterday();
    double yesterdayAmount =
        foldTransactions(transPeriodUtils.getTransactionsWithinPeriod());
    return yesterdayAmount;
  }

  //? 3] getting yesterday's outcome only
  double todayIncome(DayStartModel defaultDayStart) {
    TransPeriodUtils transPeriodUtils = TransPeriodUtils(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        transactions: _incomeTransactions,
        defaultDayStart: defaultDayStart);
    transPeriodUtils.setToday();
    double todayAmount =
        foldTransactions(transPeriodUtils.getTransactionsWithinPeriod());
    return todayAmount;
  }

  //? 4] getting yesterday's outcome only
  double yesterdayIncome(DayStartModel defaultDayStart) {
    TransPeriodUtils transPeriodUtils = TransPeriodUtils(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        transactions: _incomeTransactions,
        defaultDayStart: defaultDayStart);
    transPeriodUtils.setYesterday();
    double yesterdayAmount =
        foldTransactions(transPeriodUtils.getTransactionsWithinPeriod());
    return yesterdayAmount;
  }

  //? 5] getting total money for a profile, (savings)
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
    _allTransactions.clear();
  }

  //? add an array of transactions to the local database
  Future<void> setTransactions(List<TransactionModel> transactions) async {
    for (var transaction in transactions) {
      try {
        await DBHelper.insert(transactionsTableName, transaction.toJSON());
      } catch (error, stackTrace) {
        CustomError.log(error: error, stackTrace: stackTrace);
      }
    }
  }

  //? getting a transaction by id
  TransactionModel getTransactionById(String id) {
    return _allTransactions.firstWhere((element) => element.id == id);
  }

  //? getting a transaction by id
  TransactionModel getActiveProfileTransactionById(String id) {
    return transactions.firstWhere((element) => element.id == id);
  }

  //? getting the last transaction in the list
  //* this will be used to check if the current added transaction has the same amount and transaction type as the last transaction in the list
  TransactionModel getLastTransaction() {
    return transactions[transactions.length - 1];
  }

  double getProfileDebtsAddedAmount(
      DebtsProvider debtsProvider, String profileId) {
    return debtsProvider.debts.fold(
        0,
        (previousValue, element) => element.borrowingProfileId == profileId
            ? previousValue + element.amount
            : previousValue);
  }

  //? advice for adding new transaction
  Future<TransactionMsg> getAdvice({
    required double ratioToTotal,
    required TransactionType transactionType,
    required BuildContext context,
    required double amount,
    required DebtsProvider debtsProvider,
    required ProfilesProvider profilesProvider,
    required String profileId,
  }) async {
    String? msg;
    bool continueAdding = true;
    //* income advices
    if (transactionType == TransactionType.income) {
      //* if it is greater than 100000 verify it is a real one
      msg = 'Add this big amount?';
      if (amount > 100000) {
        await showDialog(
            context: context,
            msg: 'Add this big amount?',
            onOk: () {},
            onCancel: () {
              continueAdding = false;
            });
      }
    }
    //* outcome advices
    else {
      double profileTotalMoney =
          await Provider.of<ProfilesProvider>(context, listen: false)
              .getProfileTotalMoney(this, debtsProvider, profileId);

      if (amount > profileTotalMoney) {
        //* if it is greater than the total money
        msg = 'This is larger than your balance! Add a debt instead.';
        await showDialog(
            context: context,
            msg: 'This is larger than your balance! Add a debt instead.',
            onOk: () {},
            btnCancel: SizedBox(),
            onCancel: () {
              continueAdding = false;
            });
        continueAdding = false;
      } else if (ratioToTotal > .3) {
        //* if it is very big one
        msg = 'This is very big expense!';
        await showDialog(
            context: context,
            msg: 'This is very big expense!',
            onOk: () {},
            onCancel: () {
              continueAdding = false;
            });
      }
    }

    return TransactionMsg(
      continueAdding: continueAdding,
      msg: msg,
    );
  }

  //? adding new transaction
  Future<bool> addTransaction({
    required String description,
    required String title,
    required double amount,
    required TransactionType transactionType,
    required String profileId,
    required BuildContext context,
    required DebtsProvider debtsProvider,
    required ProfilesProvider profilesProvider,
  }) async {
    //* initializing the transaction data like (createdAt, id, ratioToTotal...)
    String id = const Uuid().v4();
    DateTime createdAt = DateTime.now();
    double profileTotalMoney =
        await Provider.of<ProfilesProvider>(context, listen: false)
            .getProfileTotalMoney(this, debtsProvider, profileId);

    //* this line is to ensure that ......

    double ratioToTotal = (amount / profileTotalMoney).abs();

    //* this line is to ensure that .......
    ratioToTotal = (ratioToTotal == double.infinity) ? 1 : ratioToTotal;

    //* getting the advice
    TransactionMsg transactionMsg = await getAdvice(
      ratioToTotal: ratioToTotal,
      transactionType: transactionType,
      context: context,
      amount: amount,
      debtsProvider: debtsProvider,
      profilesProvider: profilesProvider,
      profileId: profileId,
    );

    if (!transactionMsg.continueAdding) {
      return transactionMsg.continueAdding;
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
    //* here i will add the new transaction to the database
    try {
      await DBHelper.insert(transactionsTableName, newTransaction.toJSON());
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }

    _transactions.add(newTransaction);
    notifyListeners();
    return transactionMsg.continueAdding;
  }

  //? get  a profile transactions by its id
  Future<List<TransactionModel>> getProfileTransations(String profileId,
      [getDeleted = false]) async {
    List<Map<String, dynamic>> data = await DBHelper.getDataWhere(
        transactionsTableName, 'profileId', profileId);

    List<TransactionModel> fetchedTransactions = data
        .map(
          (transaction) => TransactionModel.fromJSON(transaction),
        )
        .toList();

    if (getDeleted) {
      return fetchedTransactions;
    } else {
      return fetchedTransactions
          .where((element) => (element.deleted == false))
          .toList();
    }
  }

  //? get transactinons by a profile id
  Future<void> fetchAndUpdateProfileTransactions(String profileId) async {
    try {
      List<TransactionModel> profileTransactions =
          await getProfileTransations(profileId);
      profileTransactions.sort((a, b) {
        return a.createdAt.difference(b.createdAt).inSeconds;
      });
      _transactions = profileTransactions;

      notifyListeners();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
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
      _allTransactions = fetchedTransactions;
      notifyListeners();
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
  }

  //? deleting a transaction by id
  Future<void> deleteTransaction(String id) async {
    //* if that transaction is income and deleting it will make the total by negative then throw an error that you can't delete that transaction , you can only edit it to a lower amount but not lower than the current total amount in that profile
    TransactionModel deletedTransaction = getActiveProfileTransactionById(id);
    deletedTransaction.deleted = true;
    // bool deletingOutcome =
    //     deletedTransaction.transactionType == TransactionType.outcome;

    if (deletedTransaction.syncFlag == SyncFlags.add) {
      return editTransaction(
        newTransaction: deletedTransaction,
        // deletingOutcome: deletingOutcome,
      );
    } else {
      deletedTransaction.syncFlag = SyncFlags.delete;
      return editTransaction(
        newTransaction: deletedTransaction,
        // deletingOutcome: deletingOutcome,
      );
    }
  }

  Future<void> changeSyncFlag(
      String id, SyncFlags newSyncFlag, String activeProfileId) async {
    TransactionModel transaction = getTransactionById(id);
    transaction.syncFlag = newSyncFlag;

    return editTransaction(
      newTransaction: transaction,
      syncing: true,
      activeProfileId: activeProfileId,
    );
  }

  //? editing a transaction
  Future<void> editTransaction({
    required TransactionModel newTransaction,
    bool syncing = false,
    String? activeProfileId,
    bool checkAmount = false,
  }) async {
    //* checking if the transactin is outcome and the it is greater than the current total money
    //* this is the amount that should be compared to the amount of the newTransaction
    if (checkAmount) {
      double newAmount = totalMoney - newTransaction.amount;
      if (newTransaction.amount > newAmount &&
          newTransaction.transactionType == TransactionType.outcome) {
        return CustomError.log(
          errorType: ErrorTypes.expenseLargeNoDebt,
          rethrowError: true,
        );
      }
    }
    if (syncing) {
      newTransaction.syncFlag = SyncFlags.noSyncing;
    } else if (newTransaction.syncFlag != SyncFlags.add) {
      newTransaction.syncFlag = SyncFlags.edit;
    }

    //* editing transaction on database first
    try {
      await DBHelper.insert(transactionsTableName, newTransaction.toJSON());
    } catch (error, stackTrace) {
      CustomError.log(error: error, stackTrace: stackTrace);
    }
    //? checking if the current transactions in the active profile or not to update the screen
    if (activeProfileId != null &&
        newTransaction.profileId != activeProfileId) {
      return;
    }

    int transactionIndex =
        _transactions.indexWhere((element) => element.id == newTransaction.id);
    if (transactionIndex == -1) {
      return;
    }
    _transactions.removeWhere((element) => element.id == newTransaction.id);
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
