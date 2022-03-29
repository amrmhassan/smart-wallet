import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);

    return Future.delayed(Duration.zero).then((_) => value);
  }
}
