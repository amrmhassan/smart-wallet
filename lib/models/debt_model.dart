import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/constants/models_properties_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';

class DebtModel {
  final String id;
  final String title;
  final double amount;
  final String? profileId;
  final bool fulFilled;
  final DateTime createdAt;
  final SyncFlags syncFlag;
  final bool deleted;
  final String? userId;

  const DebtModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.amount,
    this.profileId,
    this.fulFilled = false,
    this.deleted = false,
    this.userId,
    this.syncFlag = SyncFlags.noSyncing,
  });

  Map<String, dynamic> toJSON() {
    return {
      idString: id,
      titleString: title,
      amountString: amount.toString(),
      createdAtString: createdAt.toIso8601String(),
      profileIdString: profileId ?? dbNull,
      syncFlagString: syncFlag.name,
      deletedString: deleted == true ? dbTrue : dbFalse,
      fulfilledString: fulFilled ? dbTrue : dbFalse,
      userIdString: userId ?? dbNull,
    };
  }

  static DebtModel fromJSON(Map<String, dynamic> debtJSON) {
    String idJ = debtJSON[idString];
    String titleJ = debtJSON[titleString];
    DateTime createdAtJ = DateTime.parse(debtJSON[createdAtString]);
    double amountJ = double.parse(debtJSON[amountString].toString());

    bool deletedJ = debtJSON[deletedString] == dbTrue ? true : false;
    bool fulFilledJ = debtJSON[fulfilledString] == dbTrue ? true : false;
    SyncFlags syncFlagsJ =
        stringToSyncFlag(debtJSON[syncFlagString] ?? SyncFlags.noSyncing.name);
    String? userIdJ =
        debtJSON[userIdString] == dbNull ? null : debtJSON[userIdString];
    String? profileIdJ =
        debtJSON[profileIdString] == dbNull ? null : debtJSON[profileIdString];

    return DebtModel(
      id: idJ,
      title: titleJ,
      createdAt: createdAtJ,
      deleted: deletedJ,
      amount: amountJ,
      syncFlag: syncFlagsJ,
      userId: userIdJ,
      fulFilled: fulFilledJ,
      profileId: profileIdJ,
    );
  }
}