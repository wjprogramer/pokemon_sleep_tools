import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonIconImage extends StatelessWidget {
  const PokemonIconImage({
    super.key,
    required this.basicProfile,
    this.width,
    this.height,
    this.fit,
    this.disableTooltip = false,
  });

  final PokemonBasicProfile basicProfile;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool disableTooltip;

  @override
  Widget build(BuildContext context) {
    Widget result = Image.asset(
      AssetsPath.pokemonIcon(basicProfile.boxNo),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );

    if (!disableTooltip) {
      result = Tooltip(
        message: basicProfile.nameI18nKey.xTr,
        child: result,
      );
    }

    return result;
  }
}
