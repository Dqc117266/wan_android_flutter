import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setValue(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported value type');
    }
  }

  static dynamic getValue(String key) {
    return _prefs.get(key);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
