import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';
import 'package:smart_wallet/providers/user_prefs_provider.dart';

HomeSummaryCollection defaultHomeSummaryCollection = HomeSummaryCollection(
  first: HomeSummaryModel(
    homeSummary: HomeSummary.todayIncome,
  ),
  second: HomeSummaryModel(
    homeSummary: HomeSummary.yesterdayOutcome,
  ),
  third: HomeSummaryModel(
    homeSummary: HomeSummary.totalSavings,
  ),
);

class HomeSummaryCollection {
  final HomeSummaryModel first;
  final HomeSummaryModel second;
  final HomeSummaryModel third;

  const HomeSummaryCollection({
    required this.first,
    required this.second,
    required this.third,
  });
}

class HomeSummaryModel {
  final HomeSummary homeSummary;
  late String name;
  late TransactionType transactionType;

  HomeSummaryModel({
    required this.homeSummary,
  }) {
    //? for getting the transaction type
    if (homeSummary.name.toLowerCase().contains('outcome')) {
      transactionType = TransactionType.outcome;
    } else if (homeSummary.name.toLowerCase().contains('income')) {
      transactionType = TransactionType.income;
    } else {
      transactionType = TransactionType.all;
    }
    //? for getting the name
    String n = homeSummary.name;
    if (n.toLowerCase().contains('today')) {
      name = 'Today';
    } else if (n.toLowerCase().contains('yesterday')) {
      name = 'Yesterday';
    } else {
      name = 'Savings';
    }
  }
}

enum HomeSummary {
  todayOutcome,
  todayIncome,
  yesterdayOutcome,
  yesterdayIncome,
  totalSavings,
}

double getAmountForHomeSummary(HomeSummary homeSummary, BuildContext context) {
  var transactionProvider =
      Provider.of<TransactionProvider>(context, listen: false);
  var userPrefsProvider =
      Provider.of<UserPrefsProvider>(context, listen: false);
  if (homeSummary == HomeSummary.todayOutcome) {
    return transactionProvider.todayOutcome(userPrefsProvider.dayStart);
  } else if (homeSummary == HomeSummary.todayIncome) {
    return transactionProvider.todayIncome(userPrefsProvider.dayStart);
  } else if (homeSummary == HomeSummary.yesterdayOutcome) {
    return transactionProvider.yesterdayOutcome(userPrefsProvider.dayStart);
  } else if (homeSummary == HomeSummary.yesterdayIncome) {
    return transactionProvider.yesterdayIncome(userPrefsProvider.dayStart);
  } else {
    return transactionProvider.totalMoney;
  }
}
