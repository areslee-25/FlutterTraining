import 'package:untitled/data/source/remote/response/error_response.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

abstract class BaseBloc {
  late DisposeBag _disposeBag;

  BaseBloc([DisposeBag? disposeBag]) {
    _disposeBag = disposeBag ?? DisposeBag();
  }

  void onClear() {
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

abstract class BaseState {}

class EmptyState extends BaseState {}

class LoadingState extends BaseState {}
