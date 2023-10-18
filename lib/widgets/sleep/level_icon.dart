import 'package:flutter/material.dart';

class LevelIcon extends StatelessWidget {
  const LevelIcon({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'LV',
      style: TextStyle(
        fontSize: (size ?? 16) * 0.7,
        letterSpacing: -1,
      ),
    );
  }
}
