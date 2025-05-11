import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService();
      await _instance!._init();
    }
    return _instance!;
  }

  // to clear a preference
  Future<void> clearPreferences() async {
    await _preferences?.clear();
  }

  // to read a bool preference
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // to read a double preference
  double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  // to read a int preference
  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // to read a string preference
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // to remove a particular preference key
  Future<void> removePreference(String key) async {
    await _preferences?.remove(key);
  }

  // to write a bool preference
  Future<void> setBool(String key, bool value) async {
    await _preferences!.setBool(key, value);
  }

  // to write a double preference
  Future<void> setDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  // to write a int preference
  Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // to write a string preference
  Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  Future<void> _init() async {
    _preferences = await SharedPreferences.getInstance();
  }


}
