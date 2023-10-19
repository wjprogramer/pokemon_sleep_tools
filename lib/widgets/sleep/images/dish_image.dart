import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class DishImage extends StatelessWidget {
  const DishImage({
    super.key,
    required this.dish,
    this.width,
    this.disableTooltip = false,
  });

  final Dish dish;
  final double? width;
  final bool disableTooltip;

  @override
  Widget build(BuildContext context) {
    Widget result = Image.asset(
      AssetsPath.mealPortrait(dish.id),
      width: width,
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );

    if (!disableTooltip) {
      result = Tooltip(
        message: dish.nameI18nKey.xTr,
        child: result,
      );
    }

    return result;
  }
}
