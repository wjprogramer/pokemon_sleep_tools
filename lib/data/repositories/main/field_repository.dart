import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class FieldRepository implements MyInjectable {
  MyLocalStorage get _localStorage => getIt();

  Future<StoredPokemonFields> getStored() async {
    return await _localStorage.readPokemonFields();
  }

  Future<StoredPokemonFields> updateField(PokemonField field, {
    List<Fruit>? fruits,
  }) async {
    final newStored = await _localStorage.readWrite<StoredPokemonFields>(StoredPokemonFields, (stored) async {
      await stored.update(
        field, fruits: fruits,
      );
      return stored;
    });
    return newStored;
  }

}