import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';

class IngredientLabel extends StatelessWidget {
  const IngredientLabel({
    Key? key,
    required this.sameIngredient,
    required this.ingredient,
    this.onTap,
  }) : super(key: key);

  final bool sameIngredient;
  final Ingredient ingredient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const borderRadiusValue = 12.0;
    // final sameIngredient = _ingredient == ingredient;
    final theme = context.theme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: Container(
        decoration: BoxDecoration(
          color: (sameIngredient ? blueColor : yellowColor).withOpacity(.6),
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            radius: borderRadiusValue,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6, vertical: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (MyEnv.USE_DEBUG_IMAGE)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: IngredientImage(
                        ingredient: ingredient,
                        width: 16,
                      ),
                    ),
                  Text(
                    ingredient.nameI18nKey.xTr,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
