import 'package:untitled/data/source/remote/remote.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

abstract class BaseBloc {
  late DisposeBag _disposeBag;

  DisposeBag get disposeBag => _disposeBag;

  BaseBloc([DisposeBag? disposeBag]) {
    _disposeBag = disposeBag ?? DisposeBag();
  }

  void dispose() {
    _disposeBag.clear();
  }

  void onError(Object error, StackTrace stackTrace) {
    if (error is AppError) {
      print('doOnError: ' + error.message);
    }
    print(stackTrace);
  }

  void addDispose(Object disposable) {
    _disposeBag.add(disposable).whenComplete(() => print("addDispose Success"));
  }
}

abstract class BaseStatus {}

class EmptyState extends BaseStatus {}

class LoadingState extends BaseStatus {}
