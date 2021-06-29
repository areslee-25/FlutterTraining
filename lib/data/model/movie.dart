import 'package:untitled/data/model/base_model.dart';
import 'package:untitled/data/source/remote/remote.dart';

class Movie extends BaseModel {
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
        id: json.decode<int>("id"),
        title: json.decode('title', alternativeKey: 'original_name'),
        posterUrl: KeyPrams.imgPath + json.decode("poster_path"),
        backdropUrl: KeyPrams.imgPath + json.decode('backdrop_path'),
        voteAverage: json.decode<double>('vote_average').toString(),
        overview: json.decode("overview"),
        releaseDate:
            json.decode('release_date', alternativeKey: 'first_air_date'),
        voteCount: json.decode<int>("vote_count"),
        popularity: json.decode<double>("popularity"),
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
        id: json.decode<int>("id"),
        imageUrl: KeyPrams.imgPath + json.decode("logo_path"),
        name: json.decode("name"),
      );
}
