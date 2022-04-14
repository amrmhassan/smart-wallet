import 'package:smart_wallet/constants/types.dart';
import 'package:smart_wallet/models/profile_model.dart';
import 'package:smart_wallet/models/quick_action_model.dart';
import 'package:smart_wallet/models/transaction_model.dart';

SyncFlags stringToSyncFlag(String string) {
  if (string == SyncFlags.add.name) {
    return SyncFlags.add;
  } else if (string == SyncFlags.edit.name) {
    return SyncFlags.edit;
  } else if (string == SyncFlags.none.name) {
    return SyncFlags.none;
  } else {
    return SyncFlags.delete;
  }
}

//? for synced profile element
class SyncProfile {
  final ProfileModel profileModel;
  final SyncFlags syncFlags;

  SyncProfile({
    required this.profileModel,
    required this.syncFlags,
  });
}

//? for synced transaction element
class SyncTransaction {
  final TransactionModel transactionModel;
  final SyncFlags syncFlags;

  SyncTransaction({
    required this.transactionModel,
    required this.syncFlags,
  });
}

//? for synced quick action element
class SyncQuickAction {
  final QuickActionModel quickActionModel;
  final SyncFlags syncFlags;

  SyncQuickAction({
    required this.quickActionModel,
    required this.syncFlags,
  });
}
