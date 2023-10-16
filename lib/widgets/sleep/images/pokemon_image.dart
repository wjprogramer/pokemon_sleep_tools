import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    super.key,
    required this.basicProfile,
    this.width,
    this.height,
  });

  final PokemonBasicProfile basicProfile;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.pokemonPortrait(basicProfile.boxNo),
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );
  }
}
