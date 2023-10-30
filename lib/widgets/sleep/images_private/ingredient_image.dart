import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class IngredientImage extends StatelessWidget {
  const IngredientImage({
    super.key,
    required this.ingredient,
    this.size,
    this.disableTooltip = false,
  });

  final Ingredient ingredient;
  final double? size;
  final bool disableTooltip;

  @override
  Widget build(BuildContext context) {
    Widget result = Image.asset(
      AssetsPath.ingredient(ingredient),
      errorBuilder: (_, __, ___) => Container(),
      width: size,
    );

    if (size != null) {
      result = SizedBox(
        width: size,
        height: size,
        child: result,
      );
    }

    if (disableTooltip) {
      return result;
    }

    return Tooltip(
      message: ingredient.nameI18nKey.xTr,
      child: result,
    );
  }
}
