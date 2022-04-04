import 'package:flutter/material.dart';
import 'package:wallet_app/models/transaction_model.dart';

import '../constants/types.dart';
import '../utils/trans_periods_utils.dart';

enum TransPeriod {
  today,
  yesterday,
  week,
  month,
  year,
  all,
  custom,
}

class StatisticsProvider extends ChangeNotifier {
  //* all profile transactions get from the main (the proxy provider)
  List<TransactionModel> allProfileTransactions;
  TransPeriod currentActivePeriod;

  StatisticsProvider({
    required this.allProfileTransactions,
    required this.currentActivePeriod,
  });

  List<TransactionModel> _viewedTransactions = [];

//* the transactions that will be filtered by the periods
  //* this is the current active period

// //* this is the same filtered transactions by period but will be allowed to be accessed outside this class
//   List<TransactionModel> get viewedTransactions {
//     return [..._viewedTransactions];
//   }

//? 1- getting transactions, with multiple possibilities
//* for getting the income transactions only
  List<TransactionModel> get incomeTransactions {
    return [
      ..._viewedTransactions
          .where((element) => element.transactionType == TransactionType.income)
    ];
  }

//* for getting the outcome transactions only
  List<TransactionModel> get outcomeTransactions {
    return [
      ..._viewedTransactions.where(
          (element) => element.transactionType == TransactionType.outcome)
    ];
  }

//? 2- for getting  calculations on the transactions
  //* for getting the total income
  double get totalIncome {
    double totalIncomeAmount = incomeTransactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    return totalIncomeAmount;
  }

  //* for getting the total outcome
  double get totalOutcome {
    double totalIncomeAmount = outcomeTransactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    return totalIncomeAmount;
  }

  //* for getting the current money in the profile
  double get totalMoney {
    double totalAmount = _viewedTransactions.fold<double>(
      0,
      (previousValue, element) =>
          element.transactionType == TransactionType.income
              ? previousValue + element.amount
              : previousValue - element.amount,
    );
    return totalAmount;
  }

//? methods
  //* for initializing the _viewedTransactions when opening the statistics screen
  void fetchAndUpdateViewedTransactions() {
    TransPeriodUtils transPeriodUtils =
        TransPeriodUtils(transactions: allProfileTransactions);
    if (currentActivePeriod == TransPeriod.today) {
      //* for returning only the today's transactions
      transPeriodUtils.setToday();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
    } else if (currentActivePeriod == TransPeriod.yesterday) {
      //* for yesterday's transactions
      transPeriodUtils.setYesterday();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
    } else if (currentActivePeriod == TransPeriod.week) {
      //* for returning that week transactions
      transPeriodUtils.setWeek();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
    } else if (currentActivePeriod == TransPeriod.month) {
      //* for returning that month transactions
      transPeriodUtils.setMonth();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
    } else if (currentActivePeriod == TransPeriod.year) {
      //* for returning that year transactions
      transPeriodUtils.setYear();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
    } else if (currentActivePeriod == TransPeriod.all) {
      //* for returning that all transactions
      _viewedTransactions = allProfileTransactions;
    } else {
      //? here i will set the custom period for showing the transactions
    }
    notifyListeners();
  }

  //* for controlling the periods
  void setPeriod(TransPeriod period) {
    currentActivePeriod = period;
    fetchAndUpdateViewedTransactions();
  }
}
