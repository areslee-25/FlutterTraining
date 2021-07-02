import 'package:untitled/data/model/base_model.dart';

import '../../remote.dart';

class MovieResponse {
  final List<Movie> list;

  MovieResponse({
    required this.list,
  });

  factory MovieResponse.fromJson(dynamic results) {
    final dataList = results[KeyPrams.results] as List;
    return MovieResponse(
      list: dataList.map((item) => Movie.fromJson(item)).toList(),
    );
  }
}
