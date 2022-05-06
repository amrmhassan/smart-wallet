import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/constants/models_properties_constants.dart';
import 'package:smart_wallet/constants/profiles_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/debt_model.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

const double _goodLimit = .70; // when it is from 70% to 100% it will be good
const double _moderateLimit =
    .55; // when it is from 55% to 70% it will be moderate

class ProfileModel {
  String id;
  String name;
  double income;
  double outcome;
  DateTime createdAt;
  DateTime? lastActivatedDate;
  String? userId;
  SyncFlags syncFlag;
  bool deleted;

  late MoneyAccountStatus moneyAccountStatus;
  late double totalMoney;
  late double incomeRatio;

  ProfileModel({
    required this.id,
    required this.name,
    required this.income,
    required this.outcome,
    required this.createdAt,
    this.lastActivatedDate,
    this.userId,
    this.syncFlag = SyncFlags.noSyncing,
    this.deleted = false,
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
    } else if (incomeRatio >= _goodLimit) {
      moneyAccountStatus = MoneyAccountStatus.good;
    } else if (incomeRatio > _moderateLimit && incomeRatio < _goodLimit) {
      moneyAccountStatus = MoneyAccountStatus.moderate;
    } else {
      moneyAccountStatus = MoneyAccountStatus.critical;
    }
  }
  Future<List<TransactionModel>> getTransactions(BuildContext context) async {
    List<TransactionModel> transactions =
        await Provider.of<TransactionProvider>(context, listen: false)
            .getProfileTransations(id);
    return transactions;
  }

  List<DebtModel> getDebts(BuildContext context) {
    return Provider.of<DebtsProvider>(context, listen: false).debts;
  }

  double getBorrowedDebts(BuildContext context) {
    List<DebtModel> borrowedDebts = getDebts(context)
        .where((element) => element.borrowingProfileId == id)
        .toList();
    return borrowedDebts.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  double getFulfilledDebts(BuildContext context) {
    List<DebtModel> borrowedDebts = getDebts(context)
        .where((element) => element.fullfillingProfileId == id)
        .toList();
    return borrowedDebts.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  Future<double> getIncome(BuildContext context) async {
    List<TransactionModel> transactions = await getTransactions(context);
    List<TransactionModel> incomeTransactions = transactions
        .where((element) => element.transactionType == TransactionType.income)
        .toList();
    var calcIncome = Provider.of<ProfilesProvider>(context, listen: false)
        .getProfileIncome(incomeTransactions);
    return calcIncome;
  }

  Future<double> getOutcome(BuildContext context) async {
    List<TransactionModel> transactions = await getTransactions(context);
    List<TransactionModel> outcomeTransactions = transactions
        .where((element) => element.transactionType == TransactionType.outcome)
        .toList();
    var calcIncome = Provider.of<ProfilesProvider>(context, listen: false)
        .getProfileIncome(outcomeTransactions);
    return calcIncome;
  }

  Future<double> getTotalMoney(BuildContext context) async {
    double calcIncome = await getIncome(context);
    double calcOutcome = await getOutcome(context);
    return (calcIncome - calcOutcome);
  }

  Map<String, dynamic> toJSON() {
    return {
      idString: id,
      nameString: name,
      incomeString: income,
      outcomeString: outcome,
      createdAtString: createdAt.toIso8601String(),
      lastActivatedDateString: lastActivatedDate == null
          ? dbNull
          : lastActivatedDate!.toIso8601String(),
      userIdString: userId ?? dbNull,
      deletedString: deleted ? dbTrue : dbFalse,
      syncFlagString: syncFlag.name,
    };
  }

  static ProfileModel fromJSON(Map<String, dynamic> profileJSON) {
    String idJ = profileJSON[idString];
    String nameJ = profileJSON[nameString];
    double incomeJ = double.parse(profileJSON[incomeString].toString());
    double outcomeJ = double.parse(profileJSON[outcomeString].toString());
    DateTime createdAtJ = DateTime.parse(profileJSON[createdAtString]);
    DateTime? lastActivatedDateJ =
        profileJSON[lastActivatedDateString] == null ||
                profileJSON[lastActivatedDateString] == dbNull
            ? null
            : DateTime.parse(profileJSON[lastActivatedDateString]);
    bool deletedJ = profileJSON[deletedString] == dbTrue ? true : false;
    SyncFlags syncFlagsJ = stringToSyncFlag(
        profileJSON[syncFlagString] ?? SyncFlags.noSyncing.name);
    String? userIdJ =
        profileJSON[userIdString] == dbNull ? null : profileJSON[userIdString];
    return ProfileModel(
      id: idJ,
      name: nameJ,
      income: incomeJ,
      outcome: outcomeJ,
      createdAt: createdAtJ,
      deleted: deletedJ,
      lastActivatedDate: lastActivatedDateJ,
      syncFlag: syncFlagsJ,
      userId: userIdJ,
    );
  }
}
