import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class MoodIcon extends StatelessWidget {
  const MoodIcon({
    super.key,
    required this.value,
    this.width,
    this.height,
    this.fit,
    this.disableTooltip = false,
  });

  final int value;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool disableTooltip;

  static Color getColorBy(num vitality) {
    return vitality >= 81 ? moodColor80
        : vitality >= 61 ? moodColor60
        : vitality >= 41 ? moodColor40
        : vitality >= 21 ? moodColor20
        : moodColor0;
  }

  static (int, Color) getVitalityThresholdAndColor(num vitality) {
    return vitality >= 81 ? (81, moodColor80)
        : vitality >= 61 ? (61, moodColor60)
        : vitality >= 41 ? (41, moodColor40)
        : vitality >= 21 ? (21, moodColor20)
        : (0, moodColor0);
  }

  @override
  Widget build(BuildContext context) {
    Widget result;

    if (MyEnv.USE_DEBUG_IMAGE) {
      result = Image.asset(
        AssetsPath.mood(value),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container();
        },
      );
    } else {
      result = Container(
        width: width,
        height: height,
        color: null,
      );
    }

    if (!disableTooltip) {
      // result = Tooltip(
      //   message: value.nameI18nKey.xTr,
      //   child: result,
      // );
    }

    return result;
  }
}
