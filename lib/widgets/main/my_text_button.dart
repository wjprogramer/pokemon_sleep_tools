import 'package:flutter/material.dart';

class MyTextButton extends TextButton {
  const MyTextButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.onLongPress,
  });
}
