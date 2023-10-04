import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/pokemon_type.dart';

class PokemonTypeIcon extends StatelessWidget {
  const PokemonTypeIcon({
    super.key,
    required this.type
  });

  final PokemonType type;

  @override
  Widget build(BuildContext context) {
    const sizeValue = 12.0;

    return Container(
      constraints: const BoxConstraints.tightFor(
        width: sizeValue, height: sizeValue,
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: type.color,
      ),
    );
  }
}
