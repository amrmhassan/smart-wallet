import 'package:flutter/foundation.dart';

String get dbName {
  if (kDebugMode) {
    return 'my_wallet_app_db_development.db';
  } else {
    return 'my_wallet_app_production.db';
  }
}

const String transactionsTableName = 'transactions';
const String quickActionsTableName = 'quickActions';
