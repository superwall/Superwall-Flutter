extension CompactMap<T> on List<T?> {
  List<T> compact() {
    return where((element) => element != null).cast<T>().toList();
  }

  List<R> compactMap<R>(R? Function(T?) transform) {
    return map(transform).where((element) => element != null).cast<R>().toList();
  }
}