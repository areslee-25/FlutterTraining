import 'package:untitled/data/source/remote/core/key_params.dart';
import 'package:untitled/data/source/remote/response/error_response.dart';
import 'package:untitled/utils/env.dart';

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
      rethrow;
    }
  }
}
