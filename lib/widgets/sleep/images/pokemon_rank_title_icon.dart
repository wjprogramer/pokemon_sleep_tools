import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class PokemonRankTitleIcon extends StatelessWidget {
  const PokemonRankTitleIcon({
    super.key,
    required this.rank,
    this.size,
  });

  final RankTitle rank;
  final double? size;

  @override
  Widget build(BuildContext context) {
    List<Color> colors;
    Gradient gradient;
    List<double> stops = [.5, .5];

    switch (rank) {
      case RankTitle.t1:
        colors = [
          rankTitle1Color,
          rankTitle1Color,
        ];
        gradient = RadialGradient(
          center: Alignment.topCenter,
          colors: colors,
          stops: stops,
        );
        break;
      case RankTitle.t2:
        colors = [
          rankTitle2Color1,
          rankTitle2Color2,
          rankTitle2Color2,
          rankTitle2Color1,
        ];
        stops = [
          .6, .6, .9, .9,
        ];
        gradient = RadialGradient(
          center: Alignment.topCenter,
          colors: colors,
          stops: stops,
        );
        break;
      case RankTitle.t3:
        colors = [
          rankTitle3Color2,
          rankTitle3Color1,
          rankTitle3Color1,
          rankTitle3Color2,
        ];
        stops = [
          .6, .6, .8, .8,
        ];
        gradient = RadialGradient(
          center: Alignment(0, -0.4),
          colors: colors,
          stops: stops,
        );
        break;
      case RankTitle.t4:
        colors = [
          rankTitle4Color1,
          rankTitle4Color1,
        ];
        gradient = RadialGradient(
          center: Alignment.topCenter,
          colors: colors,
          stops: stops,
        );
        break;
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => gradient
          .createShader(bounds),
      // shaderCallback: (Rect bounds) => gradient
      //     .createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height)),
      child: Icon(
        Icons.catching_pokemon,
        size: size,
      ),
    );
  }
}
