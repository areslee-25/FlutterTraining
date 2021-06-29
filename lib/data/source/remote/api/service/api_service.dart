
import 'dart:io';

import 'package:http/http.dart';

import 'app_client.dart';

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
