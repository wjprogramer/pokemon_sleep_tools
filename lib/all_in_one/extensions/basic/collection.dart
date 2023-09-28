extension IterableX<T> on Iterable<T> {
  Map<K, V> toMap<K, V>(K Function(T) v, V Function(T) k) {
    return {
      for (final e in this)
        v(e): k(e),
    };
  }
}

extension ListX<E> on List<E> {
  int? indexOrNullWhere(bool Function(E element) test, [int start = 0]) {
    final i = indexWhere(test);
    return i == -1 ? null : i;
  }
}
