import '../models/transaction_model.dart';

class TransPeriodUtils {
  DateTime startDate;
  DateTime endDate;
  List<TransactionModel> transactions;

  TransPeriodUtils({
    required this.startDate,
    required this.endDate,
    required this.transactions,
  });

  Map<String, DateTime> setToday() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 1);
    endDate = DateTime.now();
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setYesterday() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 2);
    endDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 1);
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setWeek() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 7);
    endDate = DateTime.now();
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setMonth() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month - 1, nowDate.day);
    endDate = DateTime.now();
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setYear() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year - 1, nowDate.month, nowDate.day);
    endDate = DateTime.now();
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setCustomPeriod({
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) {
    startDate = newStartDate;
    endDate = newEndDate;
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setWithinLastDays(int days) {
    DateTime newStartDate = DateTime.now().subtract(Duration(days: days));
    DateTime newEndDate = DateTime.now();

    startDate = newStartDate;
    endDate = newEndDate;

    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  List<TransactionModel> getTransactionsWithinPeriod() {
    return transactions
        .where(
          (transaction) =>
              transaction.createdAt.isBefore(endDate) &&
              transaction.createdAt.isAfter(startDate),
        )
        .toList();
  }
}
