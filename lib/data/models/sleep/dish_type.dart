import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

enum DishType {
  currySoup(dishType1Color),
  salad(dishType2Color),
  dessertDrinks(dishType3Color);

  const DishType(this.color);

  final Color color;
}

extension DishTypeX on DishType {
  getDisplayText() {
    return switch (this) {
      DishType.currySoup => '${'t_curry'.xTr}${'t_separator'.xTr}${'t_curry'.xTr}',
      DishType.salad => 't_salad'.xTr,
      DishType.dessertDrinks => '${'t_desserts'.xTr}${'t_separator'.xTr}${'t_drinks'.xTr}',
    };
  }
}