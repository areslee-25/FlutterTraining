import 'package:untitled/data/source/remote/repository/base_repository.dart';

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String voteAverage;
  final String overview;
  final String releaseDate;
  final int voteCount;
  final double popularity;
  final List<Company> companies;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
    required this.voteCount,
    required this.popularity,
    required this.companies,
  });

  String firstAverage() => voteAverage.substring(0, 1);

  String lastAverage() =>
      voteAverage.substring(voteAverage.length - 1, voteAverage.length);

  String get imageUrl => backdropUrl.isNotEmpty ? posterUrl : backdropUrl;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
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
        companies: json['production_companies'] == null
            ? []
            : (json['production_companies'] as List)
                .map((item) => Company.fromJson(item))
                .toList(),
      );
}

class Company {
  final int id;
  final String imageUrl;
  final String name;

  Company({
    required this.id,
    required this.imageUrl,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: jsonDecode<int>(json, "id"),
        imageUrl: KeyPrams.imgPath + jsonDecode(json, "logo_path"),
        name: jsonDecode(json, "name"),
      );
}
