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
    List<Fruit>? fruits,
    required int? bonus,
  }) async {
    final oldItem = fields[field] ?? StoredPokemonFieldItem.empty();
    final newItem = oldItem.copyWith(
      fruits: fruits,
      bonus: bonus,
    );
    fields[field] = newItem;
    return newItem;
  }

}

class StoredPokemonFieldItem {
  StoredPokemonFieldItem({
    required this.fruits,
    required this.bonus,
  });

  List<Fruit> fruits;

  /// 數值範圍為 0 ~ 100
  /// 遊戲內實際值為 0 ~ 100 %
  int? bonus;

  factory StoredPokemonFieldItem.fromJson(Map jsonObj) {
    final fruitOf = Fruit.values.toMap((fruit) => fruit.id, (fruit) => fruit);
    final fruits = ((jsonObj['fruitIds'] ?? []) as List)
        .map((fruitId) => fruitOf[fruitId])
        .whereNotNull()
        .toList();
    final bonus = jsonObj['bonus'] is num
        ? (jsonObj['bonus'] as num).toInt() : null;

    return StoredPokemonFieldItem(
      fruits: fruits,
      bonus: bonus,
    );
  }

  factory StoredPokemonFieldItem.empty() {
    return StoredPokemonFieldItem(
      fruits: [],
      bonus: null,
    );
  }

  StoredPokemonFieldItem copyWith({
    List<Fruit>? fruits,
    required int? bonus,
  }) {
    return StoredPokemonFieldItem(
      fruits: fruits ?? this.fruits,
      bonus: bonus ?? this.bonus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fruitIds': fruits.map((fruit) => fruit.id).toList(),
      'bonus': bonus,
    };
  }

}
