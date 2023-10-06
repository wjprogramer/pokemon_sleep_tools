import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog.dart';

class DialogUtility {
  DialogUtility._();

  static void text(BuildContext context, {
    Widget? title,
    Widget? content,
    bool? barrierDismissible,
    List<Widget>? actions,
  }) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: actions ?? [
          TextButton(
            onPressed: () {
              context.nav.pop();
            },
            child: Text('t_confirm'.xTr),
          ),
        ],
      ),
    );
  }

  static void danger(BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    String? confirmText,
    Function()? onConfirm,
  }) {
    showAdaptiveDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: actions ?? [
          TextButton(
            onPressed: () {
              context.nav.pop();
            },
            child: Text('t_cancel'.xTr),
          ),
          TextButton(
            onPressed: () {
              context.nav.pop();
              onConfirm?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: dangerColor,
            ),
            child: Text(confirmText ?? 't_confirm'.xTr),
          ),
        ],
      ),
    );
  }

  static Future<PokemonSearchOptions?> searchPokemon(BuildContext context, {
    required PokemonSearchOptions initialSearchOptions,
    CalculateCounts<PokemonSearchOptions>? calcCounts,
  }) async {
    final res = await showPokemonSearchDialog(
      context,
      titleText: 't_pokemon'.xTr,
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
    );

    return res;
  }

  static Future<DishSearchOptions> pickDishSearchOptions(BuildContext context, {
    required DishSearchOptions initialSearchOptions,
    (int, int) Function(DishSearchOptions options)? calcCounts,
  }) async {
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

    return await showSleepSearchDialog<DishSearchOptions>(
      context,
      titleText: 't_recipes'.xTr,
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
      childrenBuilder: (context, search, searchOptions) {
        return [
          ...SleepSearchDialogBaseContent.hpList(
            children: [
              MySubHeader(
                titleText: 't_food'.xTr,
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
                        searchOptions.potCapacity = potCapacity;
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
                ...Ingredient.values.map((ingredient) => Container(
                  constraints: BoxConstraints.tightFor(
                    width: ingredientAndFruitItemWidth,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (!searchOptions.ingredientOf.contains(ingredient)) {
                          searchOptions.ingredientOf.add(ingredient);
                        } else {
                          searchOptions.ingredientOf.remove(ingredient);
                        }
                        search();
                      },
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

  static void loading() {

  }

}