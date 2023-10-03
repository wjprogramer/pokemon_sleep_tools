import 'package:collection/collection.dart';

extension IterableX<T> on Iterable<T> {
  Map<K, V> toMap<K, V>(K Function(T) v, V Function(T) k) {
    return {
      for (final e in this)
        v(e): k(e),
    };
  }

  // Iterable<R> mapIndexed
  Iterable<R> xMapIndexed<R>(R Function(int index, T element, Iterable<T>) convert) {
    return mapIndexed((index, element) => convert(index, element, this));
  }
}

extension ListX<E> on List<E> {
  int? indexOrNullWhere(bool Function(E element) test, [int start = 0]) {
    final i = indexWhere(test);
    return i == -1 ? null : i;
  }

  int? get lastIndex {
    return isEmpty ? null : length - 1;
  }

  void removeFirstWhere(bool Function(E element) test) {
    int? index;
    for (var i = 0; i < length; i++) {
      if (test(this[i])) {
        index = i;
        break;
      }
    }
    if (index != null) {
      removeAt(index);
    }
  }
}

extension MapX<K, V> on Map<K, V> {
}


