import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
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
    return Tooltip(
      message: pokemonType.nameI18nKey.xTr,
      child: Image.asset(
        AssetsPath.pokemonType(pokemonType),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container();
        },
      ),
    );
  }
}
