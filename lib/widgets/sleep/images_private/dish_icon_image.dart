import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class DishIconImage extends StatelessWidget {
  const DishIconImage({
    super.key,
    required this.dish,
    this.width,
  });

  final Dish dish;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: dish.nameI18nKey.xTr,
      child: Image.asset(
        AssetsPath.mealIcon(dish.id),
        errorBuilder: (context, error, stackTrace) {
          return Container();
        },
      ),
    );
  }
}
