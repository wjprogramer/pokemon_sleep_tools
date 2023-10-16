import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonIconImage extends StatelessWidget {
  const PokemonIconImage({
    super.key,
    required this.basicProfile,
    this.width,
  });

  final PokemonBasicProfile basicProfile;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsPath.pokemonIcon(basicProfile.boxNo),
      width: width,
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );
  }
}
