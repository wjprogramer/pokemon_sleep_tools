import 'package:flutter/material.dart';

class MyOutlinedButton2 extends OutlinedButton {
  const MyOutlinedButton2({
    super.key,
    required super.onPressed,
    required super.child,
    super.style,
  });

  static Widget compact({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return MyOutlinedButton2(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        minimumSize: const Size(36, 36), // 36 is default height of OutlinedButton
      ),
      child: child,
    );
  }

}
