import 'package:untitled/data/model/movie.dart';
import 'package:untitled/data/source/remote/repository/base_repository.dart';

class MovieResponse {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String voteAverage;
  final String overview;
  final String releaseDate;
  final int voteCount;
  final double popularity;

  MovieResponse({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
    required this.voteCount,
    required this.popularity,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        id: jsonDecode<int>(json, "id"),
        title: jsonDecode(json, 'title', alternativeKey: 'original_name'),
        posterUrl: KeyPrams.imgPath + jsonDecode(json, "poster_path"),
        backdropUrl: KeyPrams.imgPath + jsonDecode(json, 'backdrop_path'),
        voteAverage: jsonDecode<double>(json, 'vote_average').toString(),
        overview: jsonDecode(json, "overview"),
        releaseDate:
            jsonDecode(json, 'release_date', alternativeKey: 'first_air_date'),
        voteCount: jsonDecode<int>(json, "vote_count"),
        popularity: jsonDecode<double>(json, "popularity"),
      );

  Movie toMovie() {
    return Movie(
        this.id,
        this.title,
        this.posterUrl,
        this.backdropUrl,
        this.voteAverage,
        this.overview,
        this.releaseDate,
        this.voteCount,
        this.popularity);
  }
}
