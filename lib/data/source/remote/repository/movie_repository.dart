import 'package:untitled/data/model/base_model.dart';
import 'package:untitled/data/source/remote/response/movie_response.dart';
import 'package:untitled/data/source/remote/response/video_response.dart';

import '../remote.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovieList(MovieTypeStatus status, [int page = 1]);

  Future<List<Movie>> searchMovie(String keyword, int page);

  Future<Movie> getMovieDetail(MovieTypeStatus status, int movieID);

  Future<Video> getVideo(int movieID);
}

class MovieRepositoryImpl extends BaseRepository implements MovieRepository {
  final ApiService _apiService;

  MovieRepositoryImpl(this._apiService);

  @override
  Future<List<Movie>> getMovieList(MovieTypeStatus status,
      [int page = 1]) async {
    Uri url = createUri(status.toValue(), {
      KeyPrams.page: '$page',
    });

    return safeApiCall<dynamic, List<Movie>>(
        call: _apiService.getItem(url),
        mapper: (response) => MovieResponse.fromJson(response).list);
  }

  @override
  Future<List<Movie>> searchMovie(String keyword, int page) async {
    Uri url = createUri(KeyPrams.v3_search_movie, {
      KeyPrams.query: keyword,
      KeyPrams.page: '$page',
    });

    return safeApiCall<dynamic, List<Movie>>(
        call: _apiService.getItem(url),
        mapper: (response) => MovieResponse.fromJson(response).list);
  }

  Future<Movie> getMovieDetail(MovieTypeStatus status, int movieID) async {
    Uri url = createUri(status.toValue() + '$movieID');

    return safeApiCall<dynamic, Movie>(
        call: _apiService.getItem(url),
        mapper: (response) => Movie.fromJson(response));
  }

  Future<Video> getVideo(int movieID) async {
    Uri url = createUri(KeyPrams.v3_movie + '$movieID/videos');

    return safeApiCall<dynamic, Video>(
        call: _apiService.getItem(url),
        mapper: (response) => VideoResponse.fromJson(response).video);
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
