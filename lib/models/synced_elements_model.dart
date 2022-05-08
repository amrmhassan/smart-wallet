import 'package:smart_wallet/constants/theme_constants.dart';
import 'package:smart_wallet/constants/types.dart';

SyncFlags stringToSyncFlag(String string) {
  if (string == SyncFlags.add.name) {
    return SyncFlags.add;
  } else if (string == SyncFlags.edit.name) {
    return SyncFlags.edit;
  } else if (string == SyncFlags.noSyncing.name) {
    return SyncFlags.noSyncing;
  } else {
    return SyncFlags.delete;
  }
}

Themes stringToThemes(String string) {
  return Themes.values.firstWhere((element) => element.name == string);
}
