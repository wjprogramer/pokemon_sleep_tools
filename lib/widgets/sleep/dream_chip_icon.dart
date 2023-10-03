import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 攻略網站是稱作 「shard」
class DreamChipIcon extends StatelessWidget {
  const DreamChipIcon({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.diamond,
      color: dreamChipColor,
      size: size,
    );
  }
}
