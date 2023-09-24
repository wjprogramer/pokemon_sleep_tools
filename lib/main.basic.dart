import 'package:flutter/foundation.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

void main() {
  final profile = PokemonBasicProfileRepository().getDemoProfile();
  debugPrint(profile.info());
}

