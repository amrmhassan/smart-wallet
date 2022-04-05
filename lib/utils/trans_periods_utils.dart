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
    DateTime now = DateTime.now();
    startDate = now.subtract(const Duration(days: 1));
    endDate = now;
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setYesterday() {
    DateTime now = DateTime.now();
    startDate = now.subtract(const Duration(days: 2));
    endDate = now.subtract(const Duration(days: 1));
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setWeek() {
    DateTime nowDate = DateTime.now();
    startDate = nowDate.subtract(const Duration(days: 7));
    endDate = nowDate;
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setMonth() {
    DateTime nowDate = DateTime.now();
    startDate = nowDate.subtract(const Duration(days: 30));
    endDate = nowDate;
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  Map<String, DateTime> setYear() {
    DateTime nowDate = DateTime.now();
    startDate = nowDate.subtract(const Duration(days: 365));
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
    DateTime now = DateTime.now();
    DateTime newStartDate = DateTime(now.year, now.month, now.day - days);
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
          (transaction) => (transaction.createdAt.isBefore(endDate) &&
              transaction.createdAt.isAfter(startDate)),
        )
        .toList();
  }
}
