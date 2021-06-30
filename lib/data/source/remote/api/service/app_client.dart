import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../remote.dart';

abstract class AppClient extends BaseClient {
  Future<dynamic> getItem(Uri url) {
    return this.get(url).then(_processData);
  }

  Future<dynamic> postItem({required Uri url, Map<String, dynamic>? body}) {
    final jsonBody = jsonEncode(body);
    print('Post Body: $jsonBody');
    return this.post(url, body: jsonBody).then(_processData);
  }

  Future<dynamic> putItem({required Uri url, Map<String, dynamic>? body}) {
    return this
        .put(url, body: body != null ? jsonEncode(body) : null)
        .then(_processData);
  }

  Future<dynamic> deleteItem(Uri url) {
    return this.delete(url).then(_processData);
  }

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
