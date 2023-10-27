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
    this.disableTooltip = false,
    this.isShiny = false,
  });

  final PokemonBasicProfile basicProfile;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool disableTooltip;
  final bool isShiny;

  @override
  Widget build(BuildContext context) {
    Widget result = _buildImage(shiny: isShiny);

    if (!disableTooltip) {
      result = Tooltip(
        message: basicProfile.nameI18nKey.xTr,
        child: result,
      );
    }

    return result;
  }

  Widget _buildImage({
    bool shiny = false,
}) {
    return Image.asset(
      shiny
          ? AssetsPath.pokemonPortraitShiny(basicProfile.boxNo)
          : AssetsPath.pokemonPortrait(basicProfile.boxNo),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        if (shiny) {
          _buildImage(shiny: false);
        }
        return Container();
      },
    );
  }
}
