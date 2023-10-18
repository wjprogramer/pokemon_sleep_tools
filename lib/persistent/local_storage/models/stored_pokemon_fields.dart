part of '../local_storage.dart';

/// rawData
final class StoredPokemonFields implements BaseLocalFile {
  StoredPokemonFields({
    Map<PokemonField, StoredPokemonFieldItem>? fields,
  }) {
    if (fields != null) {
      this.fields.addAll(fields);
    }
  }

  factory StoredPokemonFields.fromJson(Map<String, dynamic> jsonObj) {
    final rawFields = jsonObj['fields'] as Map?;
    final newFields = <PokemonField, StoredPokemonFieldItem>{};

    if (rawFields != null) {
      for (final entry in rawFields.entries) {
        final field = PokemonField.values.firstWhereOrNull((e) => e.id.toString() == entry.key);
        if (field != null) {
          newFields[field] = StoredPokemonFieldItem.fromJson(entry.value);
        }
      }
    }

    return StoredPokemonFields(
      fields: newFields,
    );
  }

  final fields = <PokemonField, StoredPokemonFieldItem>{};

  Map<String, dynamic> toJson() {
    return {
      'fields': fields.toMap<String, dynamic>(
            (field, value) => field.id.toString(),
            (field, value) => value.toJson(),
      ),
    };
  }

  Future<StoredPokemonFieldItem> update(PokemonField field, {
    List<Fruit>? fruits
  }) async {
    final oldItem = fields[field] ?? StoredPokemonFieldItem.empty();
    final newItem = oldItem.copyWith(
      fruits: fruits,
    );
    fields[field] = newItem;
    return newItem;
  }

}

class StoredPokemonFieldItem {
  StoredPokemonFieldItem({
    required this.fruits,
  });

  List<Fruit> fruits;

  factory StoredPokemonFieldItem.fromJson(Map jsonObj) {
    final fruitOf = Fruit.values.toMap((fruit) => fruit.id, (fruit) => fruit);
    final fruits = ((jsonObj['fruitIds'] ?? []) as List)
        .map((fruitId) => fruitOf[fruitId])
        .whereNotNull()
        .toList();

    return StoredPokemonFieldItem(
      fruits: fruits,
    );
  }

  factory StoredPokemonFieldItem.empty() {
    return StoredPokemonFieldItem(
      fruits: [],
    );
  }

  StoredPokemonFieldItem copyWith({
    List<Fruit>? fruits,
  }) {
    return StoredPokemonFieldItem(
      fruits: fruits ?? this.fruits,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fruitIds': fruits.map((fruit) => fruit.id).toList(),
    };
  }

}
