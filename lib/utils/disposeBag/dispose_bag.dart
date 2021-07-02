import 'dart:async';

import 'dispose_bag_base.dart';

class DisposeBag implements DisposeBagBase {
  Set<Object>? _resources;

  DisposeBag([Iterable<Object> disposables = const <Object>[]]) {
    disposables = disposables.convertToSet();
    _guardTypeMany(disposables);
    _resources = Set.of(disposables);
  }

  @override
  Future<bool> add(Object disposable) async {
    _guardType(disposable);

    final resources = _resources;
    if (resources == null) {
      await _disposeOne(disposable);
      return false;
    }
    return resources.add(disposable);
  }

  @override
  Future<void> addAll(Iterable<Object> disposables) async {
    disposables = disposables.convertToSet();
    _guardTypeMany(disposables);

    final resources = _resources;
    if (resources == null) {
      await _disposeByType<StreamSubscription>(disposables);
      return _disposeByType<Sink>(disposables);
    }
    resources.addAll(disposables);
  }

  @override
  Future<bool> remove(Object disposable) async {
    _guardType(disposable);
    final resources = _resources!;
    final removed = resources.remove(disposable);
    if (removed) {
      await _disposeOne(disposable);
    }
    return removed;
  }

  @override
  Future<void> clear() async {
    final resources = _resources;

    bool isDisposed = resources == null;
    if (isDisposed) {
      print('Disposed: isDisposed');
      return;
    }

    try {
      if (resources.isNotEmpty) {
        await _disposeByType<StreamSubscription>(resources);
        await _disposeByType<Sink>(resources);
      }
      resources.clear();
      _resources = null;
      print('Disposed Succeeded');
    } catch (error) {
      print('Disposed Failure: $error');
      rethrow;
    } finally {
      print('Disposed Completed');
    }
  }

  Future<dynamic>? _disposeByType<T extends Object>(
      Iterable<Object> resources) {
    return _wait(
      resources
          .whereType<T>()
          .map(_disposeOne)
          .whereNotNull()
          .toList(growable: false),
    );
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
    final type = disposable.runtimeType;

    if (disposable is StreamSubscription) {
      print('$type, dispose -> StreamSubscription');
      return disposable.cancel();
    }
    if (disposable is StreamSink) {
      print('$type, dispose -> StreamSink');
      return disposable.close();
    }
    if (disposable is Sink) {
      print('$type, dispose -> Sink');
      disposable.close();
    }
    return null;
  }

  void _guardType(Object disposable) {
    ArgumentError.checkNotNull(disposable, 'disposable');

    bool isValidate = disposable is StreamSubscription || disposable is Sink;
    if (!isValidate) {
      throw ArgumentError.value(
          disposable, 'disposable', 'must be a StreamSubscription, or a Sink');
    }
  }

  void _guardTypeMany(Iterable<Object> disposable) =>
      disposable.forEach(_guardType);
}

extension DisposableStreamSubscription on StreamSubscription {
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.add(this);
  }
}

extension DisposableStreamController on StreamController {
  void disposeBy(DisposeBag disposeBag) {
    disposeBag.add(this);
  }
}

extension IterableNullableExtension<T extends Object> on Iterable<T?> {
  Iterable<T> whereNotNull() sync* {
    for (var element in this) {
      if (element != null) yield element;
    }
  }
}

extension IterableConvert<T> on Iterable<T> {
  Iterable<T> convertToSet<E>() {
    Iterable<T> iterable = this;
    if (iterable is! List && iterable is! Set) {
      iterable = iterable.toList(growable: false);
    }
    return iterable;
  }
}
