import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class FruitImage extends StatelessWidget {
  const FruitImage({
    super.key,
    required this.fruit,
  });

  final Fruit fruit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.fruit(fruit),
      errorBuilder: (_, __, ___) => Container(),
    );
  }
}
