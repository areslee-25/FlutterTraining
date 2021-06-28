import 'package:rxdart/rxdart.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/data/source/remote/repository/movie_repository.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

class MovieDetailBloc extends BaseBloc {
  Stream<Movie> movieStream;

  MovieDetailBloc._({
    required DisposeBag disposeBag,
    required this.movieStream,
  }) : super(disposeBag);

  factory MovieDetailBloc(MovieRepository movieRepository, Movie movie) {
    final loadMovieControllers = BehaviorSubject<void>.seeded(0);

    final movieStream = loadMovieControllers.flatMap(
      (value) => Rx.fromCallable(
        () => movieRepository.getMovieDetail(MovieTypeStatus.movie, movie.id),
      ),
    );

    final controllers = [loadMovieControllers];

    return MovieDetailBloc._(
      disposeBag: DisposeBag([...controllers]),
      movieStream: movieStream,
    );
  }
}
