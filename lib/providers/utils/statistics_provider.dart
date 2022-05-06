import 'package:flutter/material.dart';
import 'package:smart_wallet/models/profile_model.dart';

class StatisticsProvider extends ChangeNotifier {
  double income = 0;
  double outcome = 0;
  double totalMoney = 0;

  Future<void> updateStatisticsData({
    required List<ProfileModel> profiles,
    required BuildContext context,
  }) async {
    double calcIncome = 0;
    double calcOutcome = 0;

    for (var element in profiles) {
      calcIncome = await element.getIncome(context) + calcIncome;
      calcOutcome = await element.getOutcome(context) + calcOutcome;
    }

    income = calcIncome;
    outcome = calcOutcome;
    totalMoney = income - outcome;
    notifyListeners();
  }
}
