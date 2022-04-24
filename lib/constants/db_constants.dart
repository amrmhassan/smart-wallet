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
const String profilesTableName = 'profilesTable';
const String usersCollectionName = 'users';
const String profilesCollectionName = 'profiles';
const String transactionsCollectionName = 'transactions';
const String quickActionsCollectionName = 'quickActions';

//////////////////
const String userPreferencesCollectionName = 'userPreferences';
const String activeProfileFireStoreKeyName = 'activeProfile';
const String activeThemeFireStoreKeyName = 'activeProfile';
