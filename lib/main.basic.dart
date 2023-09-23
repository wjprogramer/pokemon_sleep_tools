import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';

void main() {
  final profile = PokemonRepository().getDemoProfile();
  print(profile.info());
}

