import 'package:collection/collection.dart';

/// 會有問題 <T extends num>
extension IterableIntX on Iterable<int> {
  int xSum() {
    return reduce((v, e) => v + e);
  }
}

/// 會有問題 <T extends num>
extension IterableDoubleX on Iterable<double> {
  double xSum() {
    return reduce((v, e) => v + e);
  }
}

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

  T firstWhereByCompare(bool Function(T a, T b) test) {
    T? result;
    for (final e in this) {
      if (result == null) {
        result = e;
      } else {
        if (test(e, result)) {
          result = e;
        }
      }
    }
    return result!;
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

  List<E> xRemoveWhere(bool Function(E element) test) {
    final removedList = <E>[];

    removeWhere((element) {
      final tested = test(element);
      if (tested) {
        removedList.add(element);
      }
      return tested;
    });

    return removedList;
  }
}

extension MapX<K, V> on Map<K, V> {
  Map<NewK, NewV> toMap<NewK, NewV>(NewK Function(K key, V value) v, NewV Function(K key, V value) k) {
    return {
      for (final e in this.entries)
        v(e.key, e.value): k(e.key, e.value),
    };
  }
}

extension SetX<T> on Set<T> {
  void toggle(T value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value);
    }
  }
}





