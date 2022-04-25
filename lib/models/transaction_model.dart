import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/constants/models_properties_constants.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';

import '../constants/types.dart';

class TransactionModel {
  String id;
  String title;
  String description;
  DateTime createdAt;
  double amount;
  TransactionType transactionType;
  //* this property i will need to provide the ratio of this transaction to the total amount of money i have right now in this profile
  double ratioToTotal;
  String profileId;
  String? userId;
  bool deleted;
  SyncFlags syncFlag;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
    required this.ratioToTotal,
    required this.profileId,
    this.userId,
    this.deleted = false,
    this.syncFlag = SyncFlags.none,
  });

  Map<String, dynamic> toJSON() {
    return {
      idString: id,
      titleString: title,
      descriptionString: description,
      amountString: amount.toString(),
      createdAtString: createdAt.toIso8601String(),
      transactionTypeString: transactionType.name,
      ratioToTotalString: ratioToTotal.toString(),
      profileIdString: profileId,
      userIdString: userId ?? dbNull,
      syncFlagString: syncFlag.name,
      deletedString: deleted == true ? dbTrue : dbFalse,
    };
  }

  static TransactionModel fromJSON(Map<String, dynamic> transactionJSON) {
    //! in the dates just make sure if it is a timestamp or just a date
    //! cause this will convert the data from the firestore and the local database as well
    String idJ = transactionJSON[idString];
    String titleJ = transactionJSON[titleString];
    String descriptionJ = transactionJSON[descriptionString];
    double amountJ = double.parse(transactionJSON[amountString]);
    TransactionType transactionTypeJ =
        transactionJSON[transactionTypeString] == TransactionType.income.name
            ? TransactionType.income
            : TransactionType.outcome;
    DateTime createdAtJ = DateTime.parse(transactionJSON[createdAtString]);
    double ratioToTotalJ = double.parse(transactionJSON[ratioToTotalString]);
    String profileIdJ = transactionJSON[profileIdString];
    bool deletedJ = transactionJSON[deletedString] == dbTrue ? true : false;
    SyncFlags syncFlagJ = stringToSyncFlag(transactionJSON[syncFlagString]);
    String userIdJ = transactionJSON[userIdString] == dbNull
        ? null
        : transactionJSON[userIdString];
    return TransactionModel(
      id: idJ,
      title: titleJ,
      description: descriptionJ,
      amount: amountJ,
      createdAt: createdAtJ,
      transactionType: transactionTypeJ,
      ratioToTotal: ratioToTotalJ,
      profileId: profileIdJ,
      deleted: deletedJ,
      syncFlag: syncFlagJ,
      userId: userIdJ,
    );
  }
}
