import '../models/transaction_model.dart';

class TransPeriodUtils {
  DateTime? startDate;
  DateTime? endDate;
  List<TransactionModel> transactions;

  TransPeriodUtils({
    this.startDate,
    this.endDate,
    required this.transactions,
  });

  void setToday() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 1);
    endDate = DateTime.now();
  }

  void setYesterday() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 2);
    endDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 1);
  }

  void setWeek() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month, nowDate.day - 7);
    endDate = DateTime.now();
  }

  void setMonth() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year, nowDate.month - 1, nowDate.day);
    endDate = DateTime.now();
  }

  void setYear() {
    DateTime nowDate = DateTime.now();
    startDate = DateTime(nowDate.year - 1, nowDate.month, nowDate.day);
    endDate = DateTime.now();
  }

  void setCustomPeriod({
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) {
    startDate = newStartDate;
    endDate = newEndDate;
  }

  void setWithinLastDays(int days) {
    setCustomPeriod(
      newStartDate: DateTime.now().subtract(Duration(days: days)),
      newEndDate: DateTime.now(),
    );
  }

  List<TransactionModel> getTransactionsWithinPeriod() {
    if (startDate == null || endDate == null) {
      setToday();
    }
    return transactions
        .where(
          (transaction) =>
              transaction.createdAt.isBefore(endDate!) &&
              transaction.createdAt.isAfter(startDate!),
        )
        .toList();
  }
}
