import 'package:untitled/data/model/base_model.dart';

import '../local.dart';
import '../remote.dart';
import 'base_repository.dart';

abstract class UserRepository {
  Future<Token> createToken();

  Future<Token> loginUser(
      String userName, String password, String requestToken);

  Future<User> getInfoUser(String requestToken);

  Future<User?> getUserLocal();

  Future<void> saveUserLocal(User user);
}

class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final ApiService _apiService;
  final UserLocalSource _localSource;

  UserRepositoryImpl(this._apiService, this._localSource);

  @override
  Future<Token> createToken() async {
    final url = createUri(KeyPrams.v3_authentication_token);
    return safeApiCall<Token>(
        call: _apiService.getItem(url),
        mapper: (response) => Token.fromJson(response));
  }

  @override
  Future<Token> loginUser(
      String userName, String password, String requestToken) async {
    final url = createUri(KeyPrams.v3_authentication_login);
    return safeApiCall<Token>(
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
    return safeApiCall<User>(
        call: _apiService.getItem(url),
        mapper: (response) => User.fromJson(response));
  }

  @override
  Future<User?> getUserLocal() => _localSource.getUser();

  @override
  Future<void> saveUserLocal(User user) => _localSource.saveUser(user);
}
