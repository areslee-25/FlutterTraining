import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:untitled/data/source/remote/response/error_response.dart';

abstract class AppClient extends BaseClient {
  Future<dynamic> getItem(Uri uri) => this
      .get(
        uri,
      )
      .then(_processData);

  Future<dynamic> postItem(
    Uri url, {
    Map<String, dynamic>? body,
  }) =>
      this
          .post(
            url,
            body: jsonEncode(body),
          )
          .then(_processData);

  Future<dynamic> putItem(
    Uri url, {
    Map<String, dynamic>? body,
  }) =>
      this
          .put(
            url,
            body: body != null ? jsonEncode(body) : null,
          )
          .then(_processData);

  Future<dynamic> deleteItem(dynamic url) => this
      .delete(
        url,
      )
      .then(_processData);

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

class ApiService extends AppClient {
  final Client _client = Client();
  final Duration _timeout = const Duration(seconds: 60);

  late DateTime _dateTime;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // TODO await _getToken
    final token = null;

    if (token != null) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    request.headers[HttpHeaders.acceptHeader] = 'application/json';
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';

    _dateTime = DateTime.now();
    print('-----------------------------------------------------------');
    print('Request: $request');
    return _client.send(request).timeout(_timeout).then(_processResponse);
  }

  Future<StreamedResponse> _processResponse(StreamedResponse response) async {
    final timeRequest = DateTime.now().millisecond - _dateTime.millisecond;
    print('-----------------------------------------------------------');
    print('Time Request: $timeRequest ms');
    print('Status Code ${response.statusCode}, ${response.request}');

    if (response.statusCode == HttpStatus.unauthorized) {
      // TODO Refresh Token
      print('Unauthorized');
    }

    return response;
  }
}
