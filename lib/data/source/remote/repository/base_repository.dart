import 'package:untitled/utils/env.dart';

class KeyPrams {
  static const String imgPath = 'https://image.tmdb.org/t/p/w500/';
  static const String apiKey = 'api_key';

  static const String results = 'results';
  static const String page = 'page';
  static const String query = 'query';

  static const String v4_list = '/4/list/';

  static const String v3_movie_upcoming = '/3/movie/upcoming';
  static const String v3_movie_now = '/3/movie/now_playing';
  static const String v3_movie_popular = '/3/movie/popular';
  static const String v3_movie = '/3/movie/';
  static const String v3_search_movie = '/3/search/movie';

  static const String v3_tv_now = '/3/tv/airing_today';
  static const String v3_tv_popular = '/3/tv/popular';
  static const String v3_tv = '/3/tv/';
}

Uri createUri(String path, [Map<String, String>? queryParameters]) {
  String baseUrl = Environment.instance.endpoint;
  String apiKey = Environment.instance.apiKey;

  Map<String, String> query = {KeyPrams.apiKey: apiKey};

  if (queryParameters != null) {
    query.addAll(queryParameters);
  }

  return Uri.https(baseUrl, path, query);
}

dynamic jsonDecode(Map<String, dynamic> json, String key,
    {String? alternativeKey}) {
  try {
    dynamic data = json[key];
    if (data == null) {
      if (alternativeKey != null) {
        return jsonDecode(json, alternativeKey);
      }
      print('Parse Json NULL key = $key');
      return '';
    }
    return data;
  } catch (e) {
    print('Parse Error: $e, Key = $key');
  }
}
