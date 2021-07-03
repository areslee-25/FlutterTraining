import 'package:untitled/data/model/base_model.dart';
import 'package:untitled/data/source/local.dart';
import 'package:untitled/data/source/local/sharedPrefs/shared_prefs_api.dart';
import 'package:untitled/data/source/local/sharedPrefs/shared_prefs_key.dart';

abstract class UserLocalSource {
  Future<Token?> getToken();

  Future<void> saveToken(Token token);

  Future<User?> getUser();

  Future<void> saveUser(User user);
}

class UserLocalSourceImpl implements UserLocalSource {
  final SharedPrefsApi _sharedPrefs;

  UserLocalSourceImpl(this._sharedPrefs);

  @override
  Future<void> saveToken(Token token) async {
    _sharedPrefs.set<String>(SharedPrefsKey.key_token, token.toStringJson());
  }

  @override
  Future<Token?> getToken() async {
    try {
      final stringJson =
      await _sharedPrefs.get<String>(SharedPrefsKey.key_token);
      if (stringJson == null) {
        return null;
      }
      return Token.fromStringJson(stringJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    _sharedPrefs.set<String>(SharedPrefsKey.key_user, user.toStringJson());
  }

  @override
  Future<User?> getUser() async {
    try {
      final stringJson = await _sharedPrefs.get<String>(
          SharedPrefsKey.key_user);
      if (stringJson == null) {
        return null;
      }
      return User.fromStringJson(stringJson);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
