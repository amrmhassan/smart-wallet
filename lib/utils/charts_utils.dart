import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../constants/types.dart';

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
  final DateTime firstDate;

  const TransactionsDatesUtils({
    required this.transactions,
    required this.firstDate,
  });

//* this will return the income transactions only
  List<TransactionModel> getIncomeTransactions(
      List<TransactionModel> allTransactions) {
    return allTransactions
        .where((element) => element.transactionType == TransactionType.income)
        .toList();
  }

//* this will return the outcome transactions only
  List<TransactionModel> getOutcomeTransactions(
      List<TransactionModel> allTransactions) {
    return allTransactions
        .where((element) => element.transactionType == TransactionType.outcome)
        .toList();
  }

//* this will get all transactions within a day from a list of transactions
  List<TransactionModel> getTransactionsForADay(
      List<TransactionModel> transactions, DateTime date) {
    return transactions
        .where((element) =>
            element.createdAt.day == date.day &&
            element.createdAt.year == date.year)
        .toList();
  }

//* this will return a list of dates that there are transactions
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

//* this will get all transactions for a day and before it
//* to use them to calculate the total transactions amount before that day to get the savings
  List<TransactionModel> getTransactionsBeforeADay(
    List<TransactionModel> transactions,
    DateTime day,
  ) {
    return transactions
        .where((transaction) =>
            //* checking if the day is before the specified day or it is the same day
            transaction.createdAt.isBefore(day) ||
            (transaction.createdAt.day == day.day &&
                transaction.createdAt.year == day.year))
        .toList();
  }

//* this will return the savings before and in that day
  double getSavingsForADay(DateTime day) {
    List<TransactionModel> incomeTransactions =
        getIncomeTransactions(transactions);
    List<TransactionModel> outcomeTransactions =
        getOutcomeTransactions(transactions);
    List<TransactionModel> daysIncomeTransactions =
        getTransactionsBeforeADay(incomeTransactions, day);
    List<TransactionModel> daysOutcomeTransactions =
        getTransactionsBeforeADay(outcomeTransactions, day);

    double totalIncome = daysIncomeTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
    double totalOutcome = daysOutcomeTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);

    double totalMoney = totalIncome - totalOutcome;
    return totalMoney;
  }

//* this will get the saved money in that day only (income - outcome) [i will rarely use this method]
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

//* this will get  total income for a day
  double getTotalIncomeForAday(DateTime day) {
    List<TransactionModel> incomeTransactions =
        getIncomeTransactions(transactions);

    List<TransactionModel> daysIncomeTransactions =
        getTransactionsForADay(incomeTransactions, day);

    double totalIncome = daysIncomeTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
    return totalIncome;
  }

//* this will get  total outcome for a day
  double getTotalOutcomeForAday(DateTime day) {
    List<TransactionModel> outcomeTransactions =
        getOutcomeTransactions(transactions);

    List<TransactionModel> daysOutcomeTransactions =
        getTransactionsForADay(outcomeTransactions, day);
    double totalOutcome = daysOutcomeTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);

    return totalOutcome;
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

//* 1] this will return the savings for each day and before it
  List<CustomChartData> getTotalSavingsData() {
    List<DateTime> days = getTransactionsDates(transactions);
    return days
        .map((day) {
          double savingsForAday = getSavingsForADay(day);
          return CustomChartData(amount: savingsForAday, dateTime: day);
        })
        .toList()
        .reversed
        .toList();
  }

//* 2] this will return the data of the income of a transactions
  List<CustomChartData> getEachDayIncomeData() {
    List<DateTime> days = getTransactionsDates(transactions);
    return days
        .map((day) {
          double savingsForAday = getTotalIncomeForAday(day);
          return CustomChartData(amount: savingsForAday, dateTime: day);
        })
        .toList()
        .reversed
        .toList();
  }

//* 3] this will return the data of the outcome of a transactions
  List<CustomChartData> getEachDayOutcomeData() {
    List<DateTime> days = getTransactionsDates(transactions);
    return days
        .map((day) {
          double savingsForAday = getTotalOutcomeForAday(day);
          return CustomChartData(amount: savingsForAday, dateTime: day);
        })
        .toList()
        .reversed
        .toList();
  }
}
