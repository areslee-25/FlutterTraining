import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../remote.dart';

abstract class AppClient extends BaseClient {
  Future<dynamic> getItem(Uri uri) => this.get(uri).then(_processData);

  Future<dynamic> postItem(Uri url, {Map<String, dynamic>? body}) {
    return this.post(url, body: jsonEncode(body)).then(_processData);
  }

  Future<dynamic> putItem(Uri url, {Map<String, dynamic>? body}) {
    return this
        .put(url, body: body != null ? jsonEncode(body) : null)
        .then(_processData);
  }

  Future<dynamic> deleteItem(dynamic url) => this.delete(url).then(_processData);

  static dynamic _processData(Response response) {
    final statusCode = response.statusCode;

    final body = jsonDecode(response.body);
    print('Body Json: $body');

    if (HttpStatus.ok <= statusCode && statusCode < 300) {
      return body;
    }

    AppError appError = AppError.toError(body, statusCode);
    print('-----------------------------------------------------------');
    print('ErrorResponse: ' + appError.message);

    throw appError;
  }
}
