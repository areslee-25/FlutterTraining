import 'package:untitled/data/model/base_model.dart';
import 'package:untitled/data/source/local/local.dart';
import 'package:untitled/data/source/remote/api/core/key_params.dart';

import '../remote.dart';

abstract class UserRepository {
  Future<Token> createToken();

  Future<Token> loginUser(
      String userName, String password, String requestToken);

  Future<User> getInfoUser(String requestToken);
}

class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final ApiService _apiService;
  final UserLocalSource _userLocalSource;

  UserRepositoryImpl(this._apiService, this._userLocalSource);

  @override
  Future<Token> createToken() async {
    final url = createUri(KeyPrams.v3_authentication_token);
    return safeApiCall<dynamic, Token>(
        call: _apiService.getItem(url),
        mapper: (response) => Token.fromJson(response));
  }

  @override
  Future<Token> loginUser(
      String userName, String password, String requestToken) async {
    final url = createUri(KeyPrams.v3_authentication_login);
    return safeApiCall<dynamic, Token>(
        call: _apiService.postItem(url: url, body: {
          KeyPrams.user_name: '$userName',
          KeyPrams.password: '$password',
          KeyPrams.request_token: '$requestToken',
        }),
        mapper: (response) => Token.fromJson(response));
  }

  @override
  Future<User> getInfoUser(String requestToken) async {
    final sessionUrl = createUri(KeyPrams.v3_authentication_session);
    final dataSession = await _apiService.postItem(url: sessionUrl, body: {
      KeyPrams.request_token: '$requestToken',
    });

    final session = dataSession["session_id"];

    final url =
        createUri(KeyPrams.v3_account, {KeyPrams.session_id: '$session'});
    return safeApiCall<dynamic, User>(
        call: _apiService.getItem(url),
        mapper: (response) => User.fromJson(response));
  }
}
