import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 攻略網站是稱作 「shard」
class DreamChipIcon extends StatelessWidget {
  const DreamChipIcon({
    super.key,
    this.size = 14.0,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (MyEnv.USE_DEBUG_IMAGE) {
      result = Image.asset(
        AssetsPath.generic('shard'),
        width: size,
      );
    } else {
      result = Icon(
        Icons.diamond,
        color: dreamChipColor,
        size: size,
      );
    }

    return Tooltip(
      message: '夢之碎片',
      child: result,
    );
  }
}
