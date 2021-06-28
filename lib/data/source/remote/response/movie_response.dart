import 'package:untitled/data/model/movie.dart';
import 'package:untitled/data/source/remote/repository/base_repository.dart';

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
