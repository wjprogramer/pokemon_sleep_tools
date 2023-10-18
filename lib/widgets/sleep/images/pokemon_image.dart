import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    super.key,
    required this.basicProfile,
    this.width,
    this.height,
    this.fit,
  });

  final PokemonBasicProfile basicProfile;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: basicProfile.nameI18nKey.xTr,
      child: Image.asset(
        AssetsPath.pokemonPortrait(basicProfile.boxNo),
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
