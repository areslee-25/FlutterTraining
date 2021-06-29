import 'package:rxdart/rxdart.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/data/model/video.dart';
import 'package:untitled/data/source/remote/repository/movie_repository.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

class MovieDetailBloc extends BaseBloc {
  Stream<Movie> movieStream;
  Stream<Video> videoStream;

  MovieDetailBloc._({
    required DisposeBag disposeBag,
    required this.movieStream,
    required this.videoStream,
  }) : super(disposeBag);

  factory MovieDetailBloc(MovieRepository movieRepository, Movie movie) {
    final loadController = BehaviorSubject<void>.seeded(0);

    final loadMovieStream = loadController.flatMap(
      (value) => Rx.fromCallable(() =>
          movieRepository.getMovieDetail(MovieTypeStatus.movie, movie.id)),
    );

    final loadVideoStream = loadController.flatMap(
      (value) => Rx.fromCallable(() => movieRepository.getVideo(movie.id)),
    );

    final controllers = [loadController];
    final streams = [loadMovieStream, loadVideoStream];

    return MovieDetailBloc._(
        disposeBag: DisposeBag([...controllers, ...streams]),
        movieStream: loadMovieStream,
        videoStream: loadVideoStream);
  }
}
