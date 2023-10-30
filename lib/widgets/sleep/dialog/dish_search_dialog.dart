import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/base_dialog.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog_data.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images_private/ingredient_image.dart';

Future<DishSearchOptions?> showDishSearchDialog(BuildContext context, {
  required String titleText,
  required DishSearchOptions initialSearchOptions,
  CalculateCounts<DishSearchOptions>? calcCounts,
}) async {
  final res = await showSleepDialog(
    context,
    barrierDismissible: false,
    child: DishSearchDialog(
      titleText: titleText,
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
    ),
  );

  return res is DishSearchOptions ? res : null;
}

class DishSearchDialog extends StatefulWidget {
  const DishSearchDialog({
    super.key,
    required this.titleText,
    required this.initialSearchOptions,
    this.calcCounts,
  });

  final String titleText;
  final DishSearchOptions initialSearchOptions;
  final CalculateCounts<DishSearchOptions>? calcCounts;

  @override
  State<DishSearchDialog> createState() => _DishSearchDialogState();
}

class _DishSearchDialogState extends State<DishSearchDialog> {
  @override
  Widget build(BuildContext context) {
    final screenSize = context.mediaQuery.size;
    final mainWidth = screenSize.width - 2 * (sleepStyleSearchDialogHorizontalListViewPaddingValue / 2 + sleepStyleSearchDialogHorizontalMarginValue);

    const potBaseItemWidth = 40.0;
    const potSpacing = 12.0;

    const ingredientAndFruitBaseItemWidth = 90.0;
    const ingredientAndFruitSpacing = 0.0;

    final potCapacityItemWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: potBaseItemWidth,
      containerWidth: mainWidth,
      spacing: potSpacing,
    ).floor().toDouble();

    final ingredientAndFruitItemWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: ingredientAndFruitBaseItemWidth,
      containerWidth: mainWidth,
      spacing: ingredientAndFruitSpacing,
    ).floor().toDouble();

    return SleepSearchDialogBaseContent<DishSearchOptions>(
      titleText: 't_recipes'.xTr,
      initialSearchOptions: widget.initialSearchOptions,
      calcCounts: widget.calcCounts,
      childrenBuilder: (BuildContext context, void Function() search, DishSearchOptions searchOptions) {
        return [
          ...SleepSearchDialogBaseContent.hpList(
            children: [
              MySubHeader(
                titleText: '料理種類'.xTr,
              ),
              Gap.sm,
              ...DishType.values.map((dishType) => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (searchOptions.dishTypes.contains(dishType)) {
                      searchOptions.dishTypes.removeFirstWhere((e) => e == dishType);
                    } else {
                      searchOptions.dishTypes.add(dishType);
                    }
                    search();
                  },
                  child: Row(
                    children: [
                      IgnorePointer(
                        child: Checkbox(
                          value: searchOptions.dishTypes.contains(dishType),
                          onChanged: (_) { },
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          dishType.getDisplayText(),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Gap.xl,
              MySubHeader(
                titleText: 't_capacity'.xTr,
              ),
              Gap.sm,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: sleepStyleSearchDialogHorizontalListViewPaddingValue / 2,
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                ...POT_CAPACITIES_OPTIONS.map((potCapacity) {
                  final selected = potCapacity == searchOptions.potCapacity;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (searchOptions.potCapacity == potCapacity) {
                          searchOptions.potCapacity = null;
                        } else {
                          searchOptions.potCapacity = potCapacity;
                        }
                        search();
                      },
                      borderRadius: BorderRadius.circular(potCapacityItemWidth),
                      radius: double.infinity,
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints.tightFor(
                          width: potCapacityItemWidth,
                          height: potCapacityItemWidth,
                        ),
                        child: Text(
                          potCapacity.toString(),
                          style: TextStyle(
                            color: selected ? primaryColor : null,
                            fontWeight: selected ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          ...SleepSearchDialogBaseContent.hpList(
            children: [
              Gap.xl,
              MySubHeader(
                titleText: 't_ingredients'.xTr,
              ),
              Gap.sm,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: sleepStyleSearchDialogHorizontalListViewPaddingValue / 2,
            ),
            child: Wrap(
              spacing: ingredientAndFruitSpacing,
              runSpacing: 4,
              children: [
                if (MyEnv.USE_DEBUG_IMAGE) ...Ingredient.values.map((ingredient) => IconButton(
                  onPressed: () => _toggleIngredient(searchOptions, ingredient, search),
                  icon: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          shape: BoxShape.circle,
                        ),
                        child: IngredientImage(
                          ingredient: ingredient,
                          size: 30,
                        ),
                      ),
                      if (searchOptions.ingredientOf.contains(ingredient)) Positioned(
                        right: 5,
                        bottom: 5,
                        child: Container(
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.check,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )) else ...Ingredient.values.map((ingredient) => Container(
                  constraints: BoxConstraints.tightFor(
                    width: ingredientAndFruitItemWidth,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _toggleIngredient(searchOptions, ingredient, search),
                      child: Row(
                        children: [
                          IgnorePointer(
                            child: Checkbox(
                              value: searchOptions.ingredientOf.contains(ingredient),
                              visualDensity: VisualDensity.compact,
                              onChanged: (v) {},
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ingredient.nameI18nKey.xTr,
                            ),
                          ),
                          Gap.xs,
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          Gap.xl,
        ];
      },
    );
  }

  void _toggleIngredient(DishSearchOptions searchOptions, Ingredient ingredient, VoidCallback search) {
    if (!searchOptions.ingredientOf.contains(ingredient)) {
      searchOptions.ingredientOf.add(ingredient);
    } else {
      searchOptions.ingredientOf.remove(ingredient);
    }
    search();
  }

}


