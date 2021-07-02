import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';
import 'package:untitled/base/base_bloc.dart';
import 'package:untitled/data/model/movie.dart';
import 'package:untitled/data/source/remote.dart';
import 'package:untitled/data/source/repository.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

class TvBloc extends BaseBloc {
  final Stream<Tuple2<List<Movie>, List<Movie>>> dataList;

  TvBloc._({
    required DisposeBag disposeBag,
    required this.dataList,
  }) : super(disposeBag);

  factory TvBloc(MovieRepository movieRepository) {
    // ignore: close_sinks
    final loadMovieControllers = BehaviorSubject<void>.seeded(0);

    final nowMoveListStream = Rx.fromCallable(
            () => movieRepository.getMovieList(MovieTypeStatus.tvNow))
        .onErrorReturn([]);

    final popularMoveListStream = Rx.fromCallable(
            () => movieRepository.getMovieList(MovieTypeStatus.tvPopular))
        .onErrorReturn([]);

    final loadDataStream = loadMovieControllers.flatMap(
      (value) => Rx.zip2(
        nowMoveListStream,
        popularMoveListStream,
        (List<Movie> a, List<Movie> b) => Tuple2(a, b),
      ).doOnError(
        (error, stacktrace) {
          if (error is AppError) {
            print('doOnError: ' + error.message);
          }
          print(stacktrace);
        },
      ),
    );

    final controllers = [loadMovieControllers];
    final streams = [loadDataStream];

    return TvBloc._(
      disposeBag: DisposeBag([...controllers, ...streams]),
      dataList: loadDataStream,
    );
  }
}
