import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class GameItemImage extends StatelessWidget {
  const GameItemImage({
    super.key,
    required this.gameItem,
    this.width,
    this.disableTooltip = false,
  });

  final GameItem gameItem;
  final double? width;
  final bool disableTooltip;

  @override
  Widget build(BuildContext context) {
    final newSize = width != null? width! * 1.7 : null;

    Widget result = Image.asset(
      AssetsPath.gameItem(gameItem),
      errorBuilder: (_, __, ___) => Container(),
      width: newSize,
    );

    if (newSize != null) {
      result = SizedBox(
        width: width,
        height: width,
        child: Center(
          child: OverflowBox(
            maxHeight: newSize,
            maxWidth: newSize,
            child: result,
          ),
        ),
      );
    }

    if (disableTooltip) {
      return result;
    }

    return Tooltip(
      message: gameItem.nameI18nKey.xTr,
      child: result,
    );
  }
}
