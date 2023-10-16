import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class IngredientImage extends StatelessWidget {
  const IngredientImage({
    super.key,
    required this.ingredient,
    this.width,
  });

  final Ingredient ingredient;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.ingredient(ingredient),
      errorBuilder: (_, __, ___) => Container(),
      width: width,
    );
  }
}
