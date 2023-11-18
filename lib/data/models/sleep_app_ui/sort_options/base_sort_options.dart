import 'package:flutter/foundation.dart';

/// [T] is sort type
abstract class BaseSortOptions<T> {

  /// Only one ascending apply to every sort option
  bool get isAscending;

  List<T> get sortOptions;

  bool get isEmpty => sortOptions.isEmpty;

  void appendOption(T sortOption);

  void remove(T option);

  BaseSortOptions clone();

  void toggleAscending();

  void setAscending(bool isAscending);

  void clear();

  void dispose() {}
}