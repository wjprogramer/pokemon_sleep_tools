part of '../local_storage.dart';

final class StoredFood implements BaseLocalFile {
  StoredFood({
    required this.ingredientOf,
  });

  StoredIngredientItems ingredientOf;

  factory StoredFood.fromJson(Map<String, dynamic> json) {
    return StoredFood(
      ingredientOf: StoredIngredientItems.fromJson(json['ingredientOf']),
    );
  }

  factory StoredFood.empty() {
    return StoredFood(
      ingredientOf: StoredIngredientItems(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredientOf': ingredientOf.toJson(),
    };
  }

  Future<void> updateIngredientAmount(Ingredient ingredient, int amount) async {
    final oldItem = ingredientOf.mapping[ingredient] ?? StoredIngredientItem.empty(ingredient);
    final newItem = oldItem.copyWith(
      amount: amount,
    );
    ingredientOf.mapping[ingredient] = newItem;
  }

  Future<void> resetAllAmounts() async {
    final newMapping = <Ingredient, StoredIngredientItem>{};
    for (final item in ingredientOf.mapping.entries) {
      newMapping[item.key] = item.value.copyWith(amount: 0);
    }
    final newIngredientOf = ingredientOf.copyWith(
      mapping: newMapping,
    );
    ingredientOf = newIngredientOf;
  }

}

class StoredIngredientItems {
  StoredIngredientItems();

  final mapping = <Ingredient, StoredIngredientItem>{};

  // fromJson
  factory StoredIngredientItems.fromJson(Map<String, dynamic> json) {
    final mapping = <Ingredient, StoredIngredientItem>{};
    final rawMapping = json['mapping'] as Map?;
    if (rawMapping != null) {
      for (final entry in rawMapping.entries) {
        final ingredient = Ingredient.values.firstWhereOrNull((e) => e.id.toString() == entry.key);
        if (ingredient != null) {
          mapping[ingredient] = StoredIngredientItem.fromJson(entry.value);
        }
      }
    }
    return StoredIngredientItems()..mapping.addAll(mapping);
  }

  StoredIngredientItems copyWith({
    Map<Ingredient, StoredIngredientItem>? mapping,
  }) {
    return StoredIngredientItems()
      ..mapping.addAll(mapping ?? this.mapping);
  }

  Map<String, dynamic> toJson() {
    return {
      'mapping': mapping.toMap<String, dynamic>(
        (ingredient, value) => ingredient.id.toString(),
        (ingredient, value) => value.toJson(),
      ),
    };
  }

}

class StoredIngredientItem {
  StoredIngredientItem(this.ingredient, {
    required this.amount,
  });

  final Ingredient ingredient;
  final int? amount;

  factory StoredIngredientItem.fromJson(Map<String, dynamic> json) {
    return StoredIngredientItem(
      Ingredient.values.firstWhere((e) => e.id.toString() == json['ingredient']),
      amount: json['amount'],
    );
  }

  factory StoredIngredientItem.empty(Ingredient ingredient) {
    return StoredIngredientItem(
      ingredient,
      amount: 0,
    );
  }

  StoredIngredientItem copyWith({
    int? amount,
  }) {
    return StoredIngredientItem(
      ingredient,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ingredient': ingredient.id.toString(),
      'amount': amount,
    };
  }

}
