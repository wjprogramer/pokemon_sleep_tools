import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/view_models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dream_chip_icon.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/energy_icon.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

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
          color: sameIngredient ? blueColor : yellowColor,
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
              child: Text(
                ingredient.nameI18nKey.xTr,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
