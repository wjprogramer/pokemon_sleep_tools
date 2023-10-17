import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonTypeImage extends StatelessWidget {
  const PokemonTypeImage({
    super.key,
    required this.pokemonType,
    this.width,
    this.height,
    this.fit,
  });

  final PokemonType pokemonType;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.pokemonType(pokemonType),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );
  }
}
