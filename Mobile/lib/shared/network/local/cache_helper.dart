import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<bool> putBool({
    required String key,
    required bool value,
  }) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setBool(key, value);
  }

  static Future<bool?> getBool({
    required String key,
  }) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    final SharedPreferences prefs = await _prefs;
    if (value is String) {
      return await prefs.setString(key, value);
    }
    if (value is int) {
      return await prefs.setInt(key, value);
    }
    if (value is bool) {
      return await prefs.setBool(key, value);
    }
    return await prefs.setDouble(key, value);
  }

  static Future<dynamic> getData({required String key}) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove(key);
  }

}
