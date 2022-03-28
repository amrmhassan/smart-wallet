import 'package:flutter/cupertino.dart';
import 'package:wallet_app/constants/profiles.dart';

import '../constants/colors.dart';

class ProfileModel {
  String id;
  String name;
  double income;
  double outcome;
  bool activated;

  late MoneyAccountStatus moneyAccountStatus;
  late double totalMoney;
  late double incomeRatio;
  late Color profileStatusColor;

  ProfileModel({
    required this.id,
    required this.name,
    required this.income,
    required this.outcome,
    this.activated = false,
  }) {
    //? for setting the total money
    //* the total money equals to income - outcome
    totalMoney = income - outcome;
    //* the incomeRatio may have 3 outcomes
    //* 1] income higher than the outcome
    //* -- a] the ratio will be greater than 0.6 => good
    //* -- b] the ratio will be between 0.5 and 0.6 => moderate
    //* 2] income is lower than outcome (totalMoney will be negative) => critical
    //? for setting the incomeRatio
    incomeRatio = income / (outcome + income);
    //? for setting the moneyAccountStatus
    if (income == 0 && outcome == 0) {
      moneyAccountStatus = MoneyAccountStatus.empty;
    } else if (incomeRatio >= 0.6) {
      moneyAccountStatus = MoneyAccountStatus.good;
    } else if (incomeRatio > 0.5 && incomeRatio < 0.6) {
      moneyAccountStatus = MoneyAccountStatus.moderate;
    } else {
      moneyAccountStatus = MoneyAccountStatus.critical;
    }

    //? for setting the profileStatusColor
    if (moneyAccountStatus == MoneyAccountStatus.good) {
      profileStatusColor = kGoodProfileStatusColor;
    } else if (moneyAccountStatus == MoneyAccountStatus.moderate) {
      profileStatusColor = kModerateProfileStatusColor;
    } else if (moneyAccountStatus == MoneyAccountStatus.critical) {
      profileStatusColor = kCriticalProfileStatusColor;
    } else if (moneyAccountStatus == MoneyAccountStatus.empty) {
      profileStatusColor = kMainColor.withOpacity(0.4);
    }
  }
}
