extension IterableX<T> on Iterable<T> {
  Map<K, V> toMap<K, V>(K Function(T) v, V Function(T) k) {
    return {
      for (final e in this)
        v(e): k(e),
    };
  }
}