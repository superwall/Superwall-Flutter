import 'dart:async';

class LatestValueStreamController<T> {
  final StreamController<T> _controller;
  T _latestValue;

  Stream<T> get stream => _controller.stream;
  StreamSink<T> get sink => _controller.sink;

  LatestValueStreamController(T defaultValue)
      : _latestValue = defaultValue,
        _controller = StreamController<T>.broadcast();

  void update(T event) {
    _latestValue = event;
    _controller.add(event);
  }

  T get value => _latestValue;

  void close() {
    _controller.close();
  }
}
