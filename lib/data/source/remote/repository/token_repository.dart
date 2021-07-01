import 'package:untitled/data/model/base_model.dart';
import 'package:untitled/data/source/local/local.dart';

abstract class TokenRepository {
  Future<Token?> getToken();

  Future<void> saveToken(Token token);
}

class TokenRepositoryImpl implements TokenRepository {
  final UserLocalSource _localSource;

  TokenRepositoryImpl(this._localSource);

  @override
  Future<Token?> getToken() => _localSource.getToken();

  @override
  Future<void> saveToken(Token token) => _localSource.saveToken(token);
}
