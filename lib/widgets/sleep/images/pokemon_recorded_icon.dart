import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class PokemonRecordedIcon extends StatelessWidget {
  const PokemonRecordedIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  static const defaultColor = color1;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.catching_pokemon,
      color: defaultColor,
    );
  }
}
