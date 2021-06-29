import 'dart:async';

import 'package:untitled/utils/env.dart';

import '../remote.dart';

typedef ResponseToModelMapper<Response, Model> = Model Function(
    Response response);

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

  Future<Model> safeApiCall<Response, Model>(
      {required Future<Response> call,
      required ResponseToModelMapper<Response, Model> mapper}) async {
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
