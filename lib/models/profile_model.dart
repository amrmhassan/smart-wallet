import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/constants/models_properties_constants.dart';
import 'package:smart_wallet/constants/profiles_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';
import 'package:smart_wallet/providers/debts_provider.dart';
import 'package:smart_wallet/providers/profiles_provider.dart';
import 'package:smart_wallet/providers/transactions_provider.dart';

class ProfileModel {
  String id;
  String name;
  DateTime createdAt;
  DateTime? lastActivatedDate;
  String? userId;
  SyncFlags syncFlag;
  bool deleted;

  ProfileModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.lastActivatedDate,
    this.userId,
    this.syncFlag = SyncFlags.noSyncing,
    this.deleted = false,
  }) {
    //? for setting the total money
    //* the total money equals to income - outcome
    // totalMoney = income - outcome;
    //* the incomeRatio may have 3 outcomes
    //* 1] income higher than the outcome
    //* -- a] the ratio will be greater than 0.6 => good
    //* -- b] the ratio will be between 0.5 and 0.6 => moderate
    //* 2] income is lower than outcome (totalMoney will be negative) => critical
    //? for setting the incomeRatio
    // incomeRatio = income / (outcome + income);
    //? for setting the moneyAccountStatus
  }

//? giving the total income( transactions & debts)
  Future<double> getIncome(BuildContext context) async {
    var transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    var debtsProvider = Provider.of<DebtsProvider>(context, listen: false);
    double calcIncome =
        await Provider.of<ProfilesProvider>(context, listen: false)
            .getProfileIncome(transactionProvider, debtsProvider, id);
    return calcIncome;
  }

//? giving the total outcome( transactions & debts)
  Future<double> getOutcome(BuildContext context) async {
    var transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    var debtsProvider = Provider.of<DebtsProvider>(context, listen: false);
    double calcOutcome =
        await Provider.of<ProfilesProvider>(context, listen: false)
            .getProfileOutcome(transactionProvider, debtsProvider, id);
    return calcOutcome;
  }

//? giving the total money in the profile
  Future<double> getTotalMoney(BuildContext context) async {
    double calcIncome = await getIncome(context);
    double calcOutcome = await getOutcome(context);
    return (calcIncome - calcOutcome);
  }

  Map<String, dynamic> toJSON() {
    return {
      idString: id,
      nameString: name,
      // incomeString: income,
      // outcomeString: outcome,
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
    // double incomeJ = double.parse(profileJSON[incomeString].toString());
    // double outcomeJ = double.parse(profileJSON[outcomeString].toString());
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
      // income: incomeJ,
      // outcome: outcomeJ,
      createdAt: createdAtJ,
      deleted: deletedJ,
      lastActivatedDate: lastActivatedDateJ,
      syncFlag: syncFlagsJ,
      userId: userIdJ,
    );
  }
}
