import 'package:shared_preferences/shared_preferences.dart';

import '../constants/shared_pref_constants.dart';

class SharedPrefHelper {
  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);

    return Future.delayed(Duration.zero).then((_) => value);
  }

  static Future<bool> firstTimeRunApp() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(kFirstTimeRunKey) == null) {
      await prefs.setString(kFirstTimeRunKey, 'not first time run the app');
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> needSyncDown() async {
    //* by default it won't need sync down
    //* if the value doesn't exist then it won't need sync down
    //* the sync down only exist if i set it to be true, else it will be false, so the default one is false
    final prefs = await SharedPreferences.getInstance();
    bool need = prefs.getBool(kNeedSyncDownKey) ?? false;
    return need;
  }

  static Future<void> toggleNeedSyncDown() async {
    //* at first time run the app it will be null so i will toggle it to be 'need sync down'
    //* and when loading the app the needSyncDown won't be null, so it will be false
    final prefs = await SharedPreferences.getInstance();
    bool need = await needSyncDown();
    await prefs.setBool(kNeedSyncDownKey, !need);
  }

  static Future<void> removeAllSavedKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
