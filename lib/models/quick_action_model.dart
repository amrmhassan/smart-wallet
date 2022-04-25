import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/constants/models_properties_constants.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';

import '../constants/types.dart';

class QuickActionModel {
  String id;
  String title;
  String description;
  double amount;
  DateTime createdAt;
  TransactionType transactionType;
  bool isFavorite;
  int? quickActionIndex;
  String? userId;
  String profileId;
  bool deleted;
  SyncFlags syncFlag;

  QuickActionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.transactionType,
    this.isFavorite = false,
    required this.profileId,
    this.quickActionIndex,
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
      isFavoriteString: isFavorite ? dbTrue : dbFalse,
      profileIdString: profileId,
      quickActionIndexString: quickActionIndex.toString(),
      userIdString: userId,
      deletedString: deleted ? dbTrue : dbFalse,
      syncFlagString: syncFlag.name,
    };
  }

  static QuickActionModel fromJSON(Map<String, dynamic> quickActionJSON) {
    String idJ = quickActionJSON[idString];
    String titleJ = quickActionJSON[titleString];
    String descriptionJ = quickActionJSON[descriptionString];
    double amountJ = double.parse(quickActionJSON[amountString]);
    TransactionType transactionTypeJ =
        quickActionJSON[transactionTypeString] == TransactionType.income.name
            ? TransactionType.income
            : TransactionType.outcome;
    DateTime createdAtJ = DateTime.parse(quickActionJSON[createdAtString]);
    String profileIdJ = quickActionJSON[profileIdString];
    bool deletedJ = quickActionJSON[deletedString] == dbTrue ? true : false;
    SyncFlags syncFlagJ = stringToSyncFlag(quickActionJSON[syncFlagString]);
    bool isFavoriteJ =
        quickActionJSON[isFavoriteString] == dbTrue ? true : false;
    int? quickActionIndexJ = quickActionJSON['quickActionIndex'] == 'null'
        ? null
        : int.parse(quickActionJSON['quickActionIndex']);
    String userIdJ = quickActionJSON[userIdString] == 'null'
        ? null
        : quickActionJSON[userIdString];

    return QuickActionModel(
      id: idJ,
      title: titleJ,
      description: descriptionJ,
      amount: amountJ,
      createdAt: createdAtJ,
      isFavorite: isFavoriteJ,
      quickActionIndex: quickActionIndexJ,
      transactionType: transactionTypeJ,
      profileId: profileIdJ,
      deleted: deletedJ,
      syncFlag: syncFlagJ,
      userId: userIdJ,
    );
  }
}
