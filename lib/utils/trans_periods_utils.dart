import 'package:smart_wallet/models/day_start_model.dart';
import 'package:smart_wallet/models/period_model.dart';

import '../models/transaction_model.dart';

class TransPeriodUtils {
  DateTime startDate;
  DateTime endDate;
  List<TransactionModel> transactions;
  DayStartModel defaultDayStart;

  TransPeriodUtils({
    required this.startDate,
    required this.endDate,
    required this.transactions,
    required this.defaultDayStart,
  });

  PeriodModel setToday() {
    DateTime now = DateTime.now();
    startDate = DateTime(
      now.year,
      now.month,
      now.day,
      defaultDayStart.hour,
      defaultDayStart.minute,
    );

    endDate = now;

    return PeriodModel(
      startDate: startDate,
      endDate: endDate,
    );
  }

  PeriodModel setYesterday() {
    DateTime now = DateTime.now();
    startDate = DateTime(
      now.year,
      now.month,
      now.day - 1,
      defaultDayStart.hour,
      defaultDayStart.minute,
    );
    endDate = DateTime(
      now.year,
      now.month,
      now.day,
      defaultDayStart.hour,
      defaultDayStart.minute,
    );
    return PeriodModel(
      startDate: startDate,
      endDate: endDate,
    );
  }

  PeriodModel setWeek() {
    DateTime now = DateTime.now();
    startDate = DateTime(
      now.year,
      now.month,
      now.day - 7,
      defaultDayStart.hour,
      defaultDayStart.minute,
    );
    endDate = now;
    return PeriodModel(
      startDate: startDate,
      endDate: endDate,
    );
  }

  PeriodModel setMonth() {
    DateTime now = DateTime.now();
    startDate = DateTime(
      now.year,
      now.month - 1,
      now.day,
      defaultDayStart.hour,
      defaultDayStart.minute,
    );
    endDate = now;
    return PeriodModel(
      startDate: startDate,
      endDate: endDate,
    );
  }

  PeriodModel setYear() {
    DateTime now = DateTime.now();
    startDate = DateTime(
      now.year - 1,
      now.month,
      now.day,
      defaultDayStart.hour,
      defaultDayStart.minute,
    );
    endDate = now;
    return PeriodModel(
      startDate: startDate,
      endDate: endDate,
    );
  }

  PeriodModel setCustomPeriod({
    required DateTime newStartDate,
    required DateTime newEndDate,
  }) {
    startDate = newStartDate;
    endDate = newEndDate;
    return PeriodModel(
      startDate: startDate,
      endDate: endDate,
    );
  }

  PeriodModel setWithinLastDays(int days) {
    DateTime now = DateTime.now();
    DateTime newStartDate = DateTime(
      now.year,
      now.month,
      now.day - days,
      defaultDayStart.hour,
      defaultDayStart.minute,
    );

    startDate = newStartDate;
    endDate = now;

    return PeriodModel(
      startDate: startDate,
      endDate: endDate,
    );
  }

  List<TransactionModel> getTransactionsWithinPeriod() {
    List<TransactionModel> t = transactions
        .where(
          (transaction) => (transaction.createdAt.isBefore(endDate) &&
              transaction.createdAt.isAfter(startDate)),
        )
        .toList();

    return t;
  }
}
