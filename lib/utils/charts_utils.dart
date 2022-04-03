// ignore_for_file: prefer_const_constructors

import 'package:intl/intl.dart';
import 'package:wallet_app/constants/transactions_constants.dart';

import '../models/transaction_model.dart';
import 'types.dart';

class CustomChartData {
  final DateTime dateTime;
  final double amount;
  late String date;

  CustomChartData({
    required this.amount,
    required this.dateTime,
  }) {
    var format = DateFormat.Md();
    date = format.format(dateTime);
  }
}

class TransactionsDatesUtils {
  final List<TransactionModel> transactions;

  const TransactionsDatesUtils({required this.transactions});

  List<TransactionModel> getIncomeTransactions(
      List<TransactionModel> allTransactions) {
    return allTransactions
        .where((element) => element.transactionType == TransactionType.income)
        .toList();
  }

  List<TransactionModel> getOutcomeTransactions(
      List<TransactionModel> allTransactions) {
    return allTransactions
        .where((element) => element.transactionType == TransactionType.outcome)
        .toList();
  }

  List<TransactionModel> getTransactionsForADay(
      List<TransactionModel> transactions, DateTime date) {
    return transactions
        .where((element) =>
            element.createdAt.day == date.day &&
            element.createdAt.year == date.year)
        .toList();
  }

  List<DateTime> getTransactionsDates(List<TransactionModel> transactions) {
    List<DateTime> dates = [];
    //* looping over the transactions to get the dates only by days

    for (var element in transactions) {
      //* converting the whole date with hours and minutes to only the date
      DateTime transactionDate =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(element.createdAt));
      //* checking if the dates contains that date to add it if not there
      if (!dates.contains(transactionDate)) {
        dates.add(transactionDate);
      }
    }

    return dates;
  }

  double getTotalMoneyForADay(DateTime day) {
    List<TransactionModel> incomeTransactions =
        getIncomeTransactions(transactions);
    List<TransactionModel> outcomeTransactions =
        getOutcomeTransactions(transactions);

    List<TransactionModel> daysIncomeTransactions =
        getTransactionsForADay(incomeTransactions, day);
    List<TransactionModel> daysOutcomeTransactions =
        getTransactionsForADay(outcomeTransactions, day);
    double totalIncome = daysIncomeTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
    double totalOutcome = daysOutcomeTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);

    double totalMoney = totalIncome - totalOutcome;
    return totalMoney;
  }

//* this will retrun the total money for each day in a days list
//* you can use this with the getTransactionsDates to make chart with the (getTotalMoneyForDaysList on y axis, getTransactionsDates on x axis)
  List<double> getTotalMoneyForDaysList(List<DateTime> days) {
    List<double> totalMoneyList = [];
    for (var day in days) {
      double totalMoneyForADay = getTotalMoneyForADay(day);
      totalMoneyList.add(totalMoneyForADay);
    }
    return totalMoneyList;
  }

  List<CustomChartData> getChartDate() {
    List<DateTime> days = getTransactionsDates(transactions);
    //* for converting the days and totalMoney to a customChartData list
    return days
        .map((day) {
          double totalMoneyForADay = getTotalMoneyForADay(day);
          return CustomChartData(amount: totalMoneyForADay, dateTime: day);
        })
        .toList()
        .reversed
        .toList();
  }
}
