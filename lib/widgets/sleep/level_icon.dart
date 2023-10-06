import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

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
