import 'dart:async';

import 'package:untitled/environment.dart';

import '../remote.dart';

typedef ResponseToModelMapper<Response, T> = T Function(Response response);

abstract class BaseRepository {
  Uri createUri(String path, [Map<String, String>? queryParameters]) {
    String baseUrl = Environment.instance.endpoint;
    String apiKey = Environment.instance.apiKey;

    Map<String, String> query = {KeyPrams.apiKey: apiKey};

    if (queryParameters != null) {
      query.addAll(queryParameters);
    }

    return Uri.https(baseUrl, path, query);
  }

  Future<T> safeApiCall<T>({
    required Future<dynamic> call,
    required ResponseToModelMapper<dynamic, T> mapper,
  }) async {
    try {
      final response = await call;
      if (response != null) {
        return mapper.call(response);
      } else {
        throw AppError.toResponseNull();
      }
    } catch (exception) {
      if (exception is AppError) {
        throw exception;
      }
      throw AppError.toUnknown(0, exception);
    }
  }
}
