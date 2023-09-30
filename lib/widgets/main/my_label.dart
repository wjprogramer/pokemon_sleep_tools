import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class MyLabel extends StatelessWidget {
  const MyLabel({
    super.key,
    required this.text,
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: bgColor.fgColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
