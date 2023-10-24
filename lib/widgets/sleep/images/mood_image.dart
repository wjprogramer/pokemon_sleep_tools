import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

class MoodImage extends StatelessWidget {
  const MoodImage({
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

  @override
  Widget build(BuildContext context) {
    Widget result = Image.asset(
      AssetsPath.mood(value),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );

    if (!disableTooltip) {
      // result = Tooltip(
      //   message: value.nameI18nKey.xTr,
      //   child: result,
      // );
    }

    return result;
  }
}
