import 'package:flutter/material.dart';
import 'package:wallet_app/helpers/custom_error.dart';
import 'package:wallet_app/models/profile_model.dart';
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
  ProfileModel? activeProfile;

  StatisticsProvider({
    required this.allProfileTransactions,
    required this.currentActivePeriod,
    this.activeProfile,
  });

  List<TransactionModel> _viewedTransactions = [];
  late TransPeriodUtils transPeriodUtils;
  DateTime startingDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime endDate = DateTime.now();

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

//! here calculate the total saving by a method that will calculate the savings for each day
//! and it will be the (total income from the the first transaction ever to the current date transactions)-
//! (total outcome from the the first transaction ever to the current date transactions)
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
  void fetchAndUpdateViewedTransactions({bool notifyListers = true}) {
    transPeriodUtils = TransPeriodUtils(
      transactions: allProfileTransactions,
      startDate: startingDate,
      endDate: endDate,
    );

    if (currentActivePeriod == TransPeriod.today) {
      //* for returning only the today's transactions
      var date = transPeriodUtils.setToday();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
      setDatesPeriod(
        newStartingDate: date['startDate'],
        newEndDate: date['endDate'],
      );
    } else if (currentActivePeriod == TransPeriod.yesterday) {
      //* for yesterday's transactions
      var date = transPeriodUtils.setYesterday();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
      setDatesPeriod(
        newStartingDate: date['startDate'],
        newEndDate: date['endDate'],
      );
    } else if (currentActivePeriod == TransPeriod.week) {
      //* for returning that week transactions
      var date = transPeriodUtils.setWeek();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
      setDatesPeriod(
        newStartingDate: date['startDate'],
        newEndDate: date['endDate'],
      );
    } else if (currentActivePeriod == TransPeriod.month) {
      //* for returning that month transactions
      var date = transPeriodUtils.setMonth();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
      setDatesPeriod(
        newStartingDate: date['startDate'],
        newEndDate: date['endDate'],
      );
    } else if (currentActivePeriod == TransPeriod.year) {
      //* for returning that year transactions
      var date = transPeriodUtils.setYear();
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
      setDatesPeriod(
        newStartingDate: date['startDate'],
        newEndDate: date['endDate'],
      );
    } else if (currentActivePeriod == TransPeriod.all) {
      //* for returning that all transactions
      _viewedTransactions = allProfileTransactions;
      setDatesPeriod(
        newStartingDate: activeProfile!.createdAt,
        newEndDate: DateTime.now(),
      );
    } else {
      //* i set the period to custom to disable the period buttons if there is another period is set by the user
      //? set the currentActivePeriod to custom when picking a new date

      //* for returning that year transactions
      transPeriodUtils.setCustomPeriod(
          newStartDate: startingDate, newEndDate: endDate);
      _viewedTransactions = transPeriodUtils.getTransactionsWithinPeriod();
      //* here i won't set call the setDatesPeriod like the above  cause the setDatesPeriod will call this method after updating the dates first

    }
    if (notifyListers) {
      notifyListeners();
    }
  }

  //* for controlling the periods
  void setPeriod(TransPeriod period) {
    currentActivePeriod = period;
    fetchAndUpdateViewedTransactions();
  }

  //* for setting the periods(startingDate, endDate)
  void setDatesPeriod({
    DateTime? newStartingDate,
    DateTime? newEndDate,
    bool update = false,
  }) {
    if (newStartingDate == null && newEndDate == null) {
      throw CustomError('You must specify one date at least');
    }
    if (newStartingDate != null) {
      startingDate = newStartingDate;
    }
    if (newEndDate != null) {
      endDate = newEndDate;
    }
    if (update) fetchAndUpdateViewedTransactions(notifyListers: false);
    notifyListeners();
  }
}
