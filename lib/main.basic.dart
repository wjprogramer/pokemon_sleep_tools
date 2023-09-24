import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

void main() {
  final profile = PokemonRepository().getDemoProfile();
  debugPrint(profile.info());
}

