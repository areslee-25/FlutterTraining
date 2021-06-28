import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/data/source/remote/repository/movie_repository.dart';
import 'package:untitled/data/source/remote/response/error_response.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

class MovieBloc extends BaseBloc {
  final Stream<Tuple3<List<Movie>, List<Movie>, List<Movie>>> dataList;

  MovieBloc._({
    required DisposeBag disposeBag,
    required this.dataList,
  }) : super(disposeBag);

  factory MovieBloc(MovieRepository movieRepository) {
    // ignore: close_sinks
    final loadMovieDisposable = BehaviorSubject<void>.seeded(0);

    final sliderMoveListStream = Rx.fromCallable(
        () => movieRepository.getMovieList(MovieTypeStatus.moviePopular));

    final nowMoveListStream = Rx.fromCallable(
        () => movieRepository.getMovieList(MovieTypeStatus.movieNow));

    final popularMoveListStream = Rx.fromCallable(
            () => movieRepository.getMovieList(MovieTypeStatus.tvPopular))
        .onErrorReturn([]);

    final loadDataStream = loadMovieDisposable.flatMap(
      (value) => Rx.zip3(
        sliderMoveListStream,
        nowMoveListStream,
        popularMoveListStream,
        (List<Movie> a, List<Movie> b, List<Movie> c) => Tuple3(a, b, c),
      ).doOnError(
        (error, stacktrace) {
          if (error is AppError) {
            print('doOnError: ' + error.message);
          }
          print(stacktrace);
        },
      ),
    );

    final controllers = [loadMovieDisposable];
    final streams = [loadDataStream];

    return MovieBloc._(
      disposeBag: DisposeBag([...controllers, ...streams]),
      dataList: loadDataStream,
    );
  }
}
