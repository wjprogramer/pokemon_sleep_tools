import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class FruitImage extends StatelessWidget {
  const FruitImage({
    super.key,
    required this.fruit,
    this.width,
  });

  final Fruit fruit;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: fruit.nameI18nKey.xTr,
      child: Image.asset(
        AssetsPath.fruit(fruit),
        width: width,
        errorBuilder: (_, __, ___) => Container(),
      ),
    );
  }
}
