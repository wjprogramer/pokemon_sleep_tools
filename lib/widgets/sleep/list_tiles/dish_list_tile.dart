import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/dish_image.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/ingredient_image.dart';

class DishListTile extends StatelessWidget {
  const DishListTile({
    super.key,
    required this.dish,
    required this.ingredients,
    this.padding,
  });

  final Dish dish;
  final List<(Ingredient, int)> ingredients;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final _theme = context.theme;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING,
        vertical: 0,
      ),
      child: Row(
        children: [
          if (MyEnv.USE_DEBUG_IMAGE)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: DishImage(
                dish: dish,
                width: 52,
                disableTooltip: true,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  dish.nameI18nKey.xTr,
                  style: _theme.textTheme.bodyLarge,
                ),
                if (MyEnv.USE_DEBUG_IMAGE)
                  Wrap(
                    children: ingredients.map((dishCount) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IngredientImage(
                          ingredient: dishCount.$1,
                          width: 20,
                        ),
                        Gap.sm,
                        Text('x${dishCount.$2}'),
                        Gap.sm,
                      ],
                    )).toList(),
                  )
                else
                  Text(
                    ingredients?.map((ingredientPair) => '${ingredientPair.$1.nameI18nKey.xTr} x${ingredientPair.$2}')
                        .join(', ') ?? '',
                    style: _theme.textTheme.bodyMedium?.copyWith(
                      color: greyColor3,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
