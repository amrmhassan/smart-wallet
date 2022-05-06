import 'package:smart_wallet/constants/db_shortage_constants.dart';
import 'package:smart_wallet/constants/models_properties_constants.dart';
import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/synced_elements_model.dart';

class DebtModel {
  final String id;
  final String title;
  final double amount;
  final String borrowingProfileId;
  final String? fullfillingProfileId;
  final bool fulFilled;
  final DateTime createdAt;
  SyncFlags syncFlag;
  bool deleted;
  final String? userId;

  DebtModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.amount,
    required this.borrowingProfileId,
    this.fullfillingProfileId,
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
      fullfillingProfileIdString: fullfillingProfileId ?? dbNull,
      borrowingProfileIdString: borrowingProfileId,
      syncFlagString: syncFlag.name,
      deletedString: deleted == true ? dbTrue : dbFalse,
      fulfilledString: fulFilled ? dbTrue : dbFalse,
      userIdString: userId ?? dbNull,
    };
  }

  static DebtModel fromJSON(Map<String, dynamic> debtJSON) {
    String idJ = debtJSON[idString];
    String titleJ = debtJSON[titleString];
    String borrowingProfileIdJ = debtJSON[borrowingProfileIdString];
    DateTime createdAtJ = DateTime.parse(debtJSON[createdAtString]);
    double amountJ = double.parse(debtJSON[amountString].toString());

    bool deletedJ = debtJSON[deletedString] == dbTrue ? true : false;
    bool fulFilledJ = debtJSON[fulfilledString] == dbTrue ? true : false;
    SyncFlags syncFlagsJ =
        stringToSyncFlag(debtJSON[syncFlagString] ?? SyncFlags.noSyncing.name);
    String? userIdJ =
        debtJSON[userIdString] == dbNull ? null : debtJSON[userIdString];
    String? fullfillingProfileIdJ =
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
      fullfillingProfileId: fullfillingProfileIdJ,
      borrowingProfileId: borrowingProfileIdJ,
    );
  }
}
