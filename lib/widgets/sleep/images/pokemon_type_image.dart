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
    const sizeValue = 12.0;

    Widget result;

    if (!MyEnv.USE_DEBUG_IMAGE) {
      result = Container(
        constraints: const BoxConstraints.tightFor(
          width: sizeValue, height: sizeValue,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pokemonType.color,
        ),
      );
    } else {
      result = Image.asset(
        AssetsPath.pokemonType(pokemonType),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container();
        },
      );
    }

    return Tooltip(
      message: pokemonType.nameI18nKey.xTr,
      child: result,
    );
  }
}
