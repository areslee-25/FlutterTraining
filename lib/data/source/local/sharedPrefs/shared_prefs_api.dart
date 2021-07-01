import 'dart:core';

abstract class SharedPrefsApi {
  Future<T?> get<T>(String key);

  Future<bool> set<T>(String key, dynamic value);

  Future<bool> remove(String key);

  Future<bool> clearAll();
}
