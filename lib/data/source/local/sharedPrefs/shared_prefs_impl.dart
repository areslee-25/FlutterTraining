import 'package:shared_preferences/shared_preferences.dart';

import 'shared_prefs_api.dart';

class SharedPrefsImpl implements SharedPrefsApi {
  SharedPreferences? _prefs;

  SharedPrefsImpl._() {
    _wrapPrefs();
  }

  factory SharedPrefsImpl() => SharedPrefsImpl._();

  Future _wrapPrefs() async => _prefs ??= await SharedPreferences.getInstance();

  @override
  Future<T?> get<T>(String key) async {
    await _wrapPrefs();
    final prefs = _prefs!;
    final value = prefs.get(key);
    return value == null ? null : (value as T);
  }

  @override
  Future<bool> set<T>(String key, dynamic value) async {
    await _wrapPrefs();
    final prefs = _prefs!;
    switch (T) {
      case int:
        return prefs.setInt(key, value);
      case double:
        return prefs.setDouble(key, value);
      case String:
        return prefs.setString(key, value);
      case bool:
        return prefs.setBool(key, value);
      case List:
        return prefs.setStringList(key, value);
      default:
        ArgumentError("SharedPrefsImpl set key: $key, value: $value Failure");
        return false;
    }
  }

  @override
  Future<bool> remove(String key) async {
    await _wrapPrefs();
    final prefs = _prefs!;
    return prefs.remove(key);
  }

  @override
  Future<bool> clearAll() async {
    await _wrapPrefs();
    final prefs = _prefs!;
    return prefs.clear();
  }
}
