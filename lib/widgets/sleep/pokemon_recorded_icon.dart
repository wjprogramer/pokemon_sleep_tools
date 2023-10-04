import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class PokemonRecordedIcon extends StatelessWidget {
  const PokemonRecordedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.catching_pokemon,
      color: color1,
    );
  }
}
