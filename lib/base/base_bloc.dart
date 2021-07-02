import 'package:rxdart/rxdart.dart';
import 'package:untitled/utils/disposeBag/dispose_bag.dart';

abstract class BaseBloc {
  late DisposeBag _disposeBag;

  DisposeBag get disposeBag => _disposeBag;

  final _errorSubject = PublishSubject<Object>();

  Stream<Object> get errorStream => _errorSubject.stream;

  final _loadingSubject = PublishSubject<bool>();

  Stream<bool> get loadingStream => _loadingSubject.stream;

  BaseBloc([DisposeBag? disposeBag]) {
    _disposeBag = disposeBag ?? DisposeBag();
  }

  Stream<T> executeStream<T>(Stream<T> stream,
      {bool showLoading = true, bool showError = true}) {
    return stream.doOnListen(() {
      if (showLoading) emitLoading(true);
    }).doOnError((error, _) {
      if (showError) emitError(error);
    }).doOnDone(() {
      if (showLoading) emitLoading(false);
    });
  }

  void dispose() {
    if (!_errorSubject.isClosed) {
      _errorSubject.close();
    }
    if (!_loadingSubject.isClosed) {
      _loadingSubject.close();
    }
    _disposeBag.clear();
  }

  void emitError(Object error) => _errorSubject.add(error);

  void emitLoading(bool isLoading) => _loadingSubject.add(isLoading);
}

abstract class BaseStatus {}

class EmptyState extends BaseStatus {}

class LoadingState extends BaseStatus {}
