import 'package:flutter/material.dart';
import 'package:smart_wallet/helpers/custom_error.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';

import '../constants/types.dart';
import '../utils/trans_periods_utils.dart';

//? these are available periods for details
enum TransPeriod {
  today,
  yesterday,
  week,
  month,
  year,
  all,
  custom,
}

class ProfileDetailsProvider extends ChangeNotifier {
  //? in action profile
  ProfileModel? profile;
//? all transactions of a profile
  List<TransactionModel> allTransactions;
  //? getting a profile by id form the proxy provider from main
  Function(String id) getProfileById;

  ProfileDetailsProvider({
    required this.allTransactions,
    required this.getProfileById,
  });
  //? one profile transactions
  List<TransactionModel> profileTransactions = [];

  //? transactions after filtering them by periods
  List<TransactionModel> _viewedTransactions = [];
  //? time period to filter transactions according to
  TransPeriod currentActivePeriod = TransPeriod.today;

  DateTime startingDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime endDate = DateTime.now();

//? fetching transaction by a profile id
  Future<void> fetchTransactions(String profileId) async {
    ProfileModel profile = await getProfileById(profileId);
    _setProfile(profile);
    profileTransactions = allTransactions
        .where(
          (element) => element.profileId == profile.id,
        )
        .toList();

    fetchAndUpdateViewedTransactions(notifyListers: false);
    notifyListeners();
  }

//? setting the current profile model after fetching it from the profiles provider
  void _setProfile(ProfileModel profileModel) {
    profile = profileModel;
  }

//? getting the income transactions
  List<TransactionModel> get incomeTransactions {
    return [
      ..._viewedTransactions
          .where((element) => element.transactionType == TransactionType.income)
    ];
  }

//? getting the outcome transactions only
  List<TransactionModel> get outcomeTransactions {
    return [
      ..._viewedTransactions.where(
          (element) => element.transactionType == TransactionType.outcome)
    ];
  }

//? getting the total income
  double get totalIncome {
    double totalIncomeAmount = incomeTransactions.fold<double>(
      0,
      (previousValue, element) => previousValue + element.amount,
    );
    return totalIncomeAmount;
  }

//? getting the total outcome
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

//? filtering transactions according to the period selected(the current active period)
  void fetchAndUpdateViewedTransactions({
    bool notifyListers = true,
  }) {
    TransPeriodUtils transPeriodUtils = TransPeriodUtils(
      transactions: profileTransactions,
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
      _viewedTransactions = profileTransactions;
      setDatesPeriod(
        newStartingDate: profile!.createdAt,
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

//? setting the current active period then fetching the transactions according to that period
  void setPeriod(TransPeriod period) {
    currentActivePeriod = period;
    fetchAndUpdateViewedTransactions();
  }

//? setting the period(custom period by the dates selectors)
  void setDatesPeriod({
    DateTime? newStartingDate,
    DateTime? newEndDate,
    bool update = false,
  }) {
    if (newStartingDate == null && newEndDate == null) {
      CustomError.log(
        error: 'You must specify one date at least',
        rethrowError: true,
      );
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
