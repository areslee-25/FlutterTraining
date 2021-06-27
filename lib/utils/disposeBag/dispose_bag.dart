import 'dart:async';

import 'dispose_bag_base.dart';

class DisposeBag implements DisposeBagBase {
  Set<Object>? _resources;

  DisposeBag([Iterable<Object> disposables = const <Object>[]]) {
    _resources = Set.of(disposables.convertNotNull());
  }

  @override
  Future<bool> add(Object disposable) => _addImpl(disposable);

  Future<bool> _addImpl(Object disposable) async {
    _guardType(disposable);

    final resources = _resources;
    if (resources == null) {
      await _disposeOne(disposable);
      return false;
    }
    return resources.add(disposable);
  }

  @override
  Future<void> addAll(Iterable<Object> disposables) => _addAllImpl(disposables);

  Future<void> _addAllImpl(Iterable<Object> disposables) async {
    _guardTypeMany(disposables);

    final resources = _resources;
    if (resources == null) {
      await _disposeByType<StreamSubscription>(disposables);
      return _disposeByType<Sink>(disposables);
    }
    resources.addAll(disposables);
  }

  @override
  Future<void> clear() => _clearImpl();

  Future<void> _clearImpl() async {
    final resources = _resources!;
    try {
      if (resources.isNotEmpty) {
        await _disposeByType<StreamSubscription>(resources);
        await _disposeByType<Sink>(resources);
      }
      resources.clear();
      print('Disposed Succeeded');
    } catch (error) {
      print('Disposed Failure: $error');
      rethrow;
    } finally {
      print('Disposed Completed');
    }
  }

  Future<void>? _disposeByType<T extends Object>(Iterable<Object> resources) {
    return _wait(resources
        .whereType<T>()
        .map(_disposeOne)
        .whereNotNull()
        .toList(growable: false));
  }

  Future<void>? _wait(List<Future<void>> futures) {
    if (futures.isEmpty) {
      return null;
    }
    if (futures.length == 1) {
      return futures[0];
    }
    return Future.wait(futures, eagerError: true);
  }

  /// Cancel [StreamSubscription] or close [Sink]
  Future<void>? _disposeOne(Object disposable) {
    if (disposable is StreamSubscription) {
      return disposable.cancel();
    }
    if (disposable is StreamSink) {
      return disposable.close();
    }
    if (disposable is Sink) {
      disposable.close();
    }
    return null;
  }

  void _guardType(Object disposable) {
    ArgumentError.checkNotNull(disposable, 'disposable');

    bool isValidate = disposable is StreamSubscription || disposable is Sink;
    if (!isValidate) {
      throw ArgumentError.value(
          disposable, 'disposable', 'must be a StreamSubscription or a Sink');
    }
  }

  void _guardTypeMany(Iterable<Object> disposable) =>
      disposable.forEach(_guardType);
}

extension IterableNullableExtension<T extends Object> on Iterable<T?> {
  Iterable<T> whereNotNull() sync* {
    for (var element in this) {
      if (element != null) yield element;
    }
  }
}

extension IterableConvert<T> on Iterable<T> {
  Iterable<T> convertNotNull<E>() {
    Iterable<T> iterable = this;
    if (iterable is! List && iterable is! Set) {
      iterable = iterable.toList(growable: false);
    }
    return iterable;
  }
}
