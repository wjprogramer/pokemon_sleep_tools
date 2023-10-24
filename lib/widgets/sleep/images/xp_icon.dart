import 'package:flutter/material.dart';

class XpIcon extends StatelessWidget {
  const XpIcon({
    Key? key,
    this.size,
  }) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'XP',
      style: TextStyle(
        fontSize: (size ?? 16) * 0.7,
        letterSpacing: -1,
      ),
    );
  }
}
