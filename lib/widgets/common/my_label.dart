import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class MyLabel extends StatelessWidget {
  const MyLabel({
    super.key,
    this.text,
    this.child,
    this.color,
  });

  final String? text;
  final Widget? child;
  final Color? color;

  static const verticalPaddingValue = 2.0;

  static const defaultColor = primaryColor;

  static Color get defaultFgColor => defaultColor.fgColor;

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? defaultColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: verticalPaddingValue,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: bgColor.fgColor,
          fontWeight: FontWeight.bold,
        ),
        child: child ?? Text(
          text ?? '',
        ),
      ),
    );
  }
}
