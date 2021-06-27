
abstract class DisposeBagBase {
  /// [disposable] must be a [StreamSubscription] or a [Sink].
  Future<bool> add(Object disposable);

  /// [disposables] must be an [Iterable] of [StreamSubscription]s or a [Sink]s.
  Future<void> addAll(Iterable<Object> disposables);

  Future<bool> remove(Object disposable);

  Future<void> clear();
}