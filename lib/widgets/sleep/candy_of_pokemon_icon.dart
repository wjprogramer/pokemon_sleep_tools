import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/candy_icon.dart';

class CandyOfPokemonIcon extends StatelessWidget {
  const CandyOfPokemonIcon({
    Key? key,
    required this.boxNo,
    this.color = pinkColor,
    this.size,
    this.disableTooltip = false,
  }) : super(key: key);

  final int boxNo;
  final Color? color;
  final double? size;
  final bool disableTooltip;

  @override
  Widget build(BuildContext context) {
    Widget result;

    Widget basicIcon() {
      return CandyIcon(
        color: color,
        size: size,
      );
    }

    if (MyEnv.USE_DEBUG_IMAGE) {
      final newSize = size != null? size! * 1.8 : null;

      result = Image.asset(
        AssetsPath.candy(boxNo),
        width: newSize,
        errorBuilder: (context, error, stackTrace) {
            // 回傳一般糖果
            return basicIcon();
          },
      );

      if (newSize != null) {
        result = SizedBox(
          width: size,
          height: size,
          child: Center(
            child: OverflowBox(
              maxHeight: newSize,
              maxWidth: newSize,
              child: result,
            ),
          ),
        );
      }
    } else {
      result = basicIcon();
    }

    return result;
  }
}
