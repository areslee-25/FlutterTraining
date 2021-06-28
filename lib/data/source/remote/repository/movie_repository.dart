import 'package:untitled/data/model/movie.dart';
import 'package:untitled/data/source/remote/AppClient.dart';
import 'package:untitled/data/source/remote/repository/base_repository.dart';
import 'package:untitled/data/source/remote/response/movie_response.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovieList(MovieTypeStatus status, [int page = 1]);

  Future<List<Movie>> searchMovie(String keyword, int page);

  Future<Movie> getMovieDetail(MovieTypeStatus status, int movieID);
}

class MovieRepositoryImpl extends BaseRepository implements MovieRepository {
  final ApiService _apiService;

  MovieRepositoryImpl(this._apiService);

  @override
  Future<List<Movie>> getMovieList(MovieTypeStatus status,
      [int page = 1]) async {
    Uri uri = createUri(status.toValue(), {
      KeyPrams.page: '$page',
    });

    final results = await _apiService.getItem(uri);
    return MovieResponse.fromJson(results).list;
  }

  @override
  Future<List<Movie>> searchMovie(String keyword, int page) async {
    Uri uri = createUri(KeyPrams.v3_search_movie, {
      KeyPrams.query: keyword,
      KeyPrams.page: '$page',
    });

    final results = await _apiService.getItem(uri);
    return safeApiCall(
      call: _apiService.getItem(uri),
      mapper: (response) {
        final data = (response as dynamic)[KeyPrams.results] as List;
        return data.map((item) => Movie.fromJson(item)).toList();
      },
    );

    final data = results[KeyPrams.results] as List;
    return data.map((item) => Movie.fromJson(item)).toList();
  }

  Future<Movie> getMovieDetail(MovieTypeStatus status, int movieID) async {
    Uri uri = createUri(status.toValue() + '$movieID');

    return safeApiCall(
        call: _apiService.getItem(uri),
        mapper: (response) => Movie.fromJson(response as dynamic));
    final results = await _apiService.getItem(uri);
    return Movie.fromJson(results);
  }
}

enum MovieTypeStatus {
  upcoming,
  movieNow,
  moviePopular,
  tvNow,
  tvPopular,
  movie,
  tv
}

extension MovieTypeStatusValue on MovieTypeStatus {
  String toValue() {
    switch (this) {
      case MovieTypeStatus.movieNow:
        return KeyPrams.v3_movie_now;
      case MovieTypeStatus.moviePopular:
        return KeyPrams.v3_movie_popular;
      case MovieTypeStatus.tvNow:
        return KeyPrams.v3_tv_now;
      case MovieTypeStatus.tvPopular:
        return KeyPrams.v3_tv_popular;
      case MovieTypeStatus.upcoming:
        return KeyPrams.v3_movie_upcoming;
      case MovieTypeStatus.movie:
        return KeyPrams.v3_movie;
      case MovieTypeStatus.tv:
        return KeyPrams.v3_tv;
    }
  }
}
