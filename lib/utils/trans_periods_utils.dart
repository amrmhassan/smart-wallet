import 'package:smart_wallet/constants/globals.dart';
import 'package:smart_wallet/models/period_model.dart';

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

  PeriodModel setToday() {
    DateTime now = DateTime.now();
    startDate = DateTime(
      now.year,
      now.month,
      now.day,
      defaultDayStart.hours,
      defaultDayStart.minutes,
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
      defaultDayStart.hours,
      defaultDayStart.minutes,
    );
    endDate = DateTime(
      now.year,
      now.month,
      now.day,
      defaultDayStart.hours,
      defaultDayStart.minutes,
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
      defaultDayStart.hours,
      defaultDayStart.minutes,
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
      defaultDayStart.hours,
      defaultDayStart.minutes,
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
      defaultDayStart.hours,
      defaultDayStart.minutes,
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
      defaultDayStart.hours,
      defaultDayStart.minutes,
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
    print('===========================');
    print(startDate);
    print(endDate);
    return t;
  }
}
