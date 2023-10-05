import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

const _horizontalMarginValue = 24.0;
const _horizontalListViewPaddingValue = 16.0;

typedef DialogContentChildrenBuilder = List<Widget> Function(BuildContext context, StateSetter setState);
typedef DialogContentChildBuilder = Widget Function(BuildContext context, StateSetter setState);

class DialogUtility {
  DialogUtility._();

  static void text(BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
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

  static Future<dynamic> sleepStyle(BuildContext context, {
    bool barrierDismissible = true,
    DialogContentChildBuilder? headerBuilder,
    DialogContentChildrenBuilder? childrenBuilder,
    DialogContentChildrenBuilder? footerBuilder,
  }) async {
    const horizontalMarginValue = 24.0;

    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        final screenSize = context.mediaQuery.size;
        final dialogHeight = math.min(screenSize.height * 0.8, 800).toDouble();
        final theme = context.theme;

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: horizontalMarginValue,
              ),
              constraints: BoxConstraints.tightFor(
                height: dialogHeight,
              ),
              decoration: BoxDecoration(
                color: theme.dialogBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: StatefulBuilder(
                builder: (context, innerSetState) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: Divider.createBorderSide(context),
                          ),
                        ),
                        child: headerBuilder?.call(context, innerSetState),
                      ),
                      Expanded(
                        child: buildListView(
                          children: childrenBuilder?.call(context, innerSetState) ?? [],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            top: Divider.createBorderSide(context),
                          ),
                        ),
                        child: Row(
                          children: footerBuilder?.call(context, innerSetState) ?? [],
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<PokemonSearchOptions?> pickPokemonSearchFilters(BuildContext context, {
    required PokemonSearchOptions initialSearchOptions,
    (int, int) Function(PokemonSearchOptions options)? calcCounts,
  }) async {
    final screenSize = context.mediaQuery.size;
    final mainWidth = screenSize.width - 2 * (_horizontalListViewPaddingValue / 2 + _horizontalMarginValue);

    const mainSkillBaseItemWidth = 120.0;
    const mainSkillSpacing = 0.0;

    const ingredientAndFruitBaseItemWidth = 90.0;
    const ingredientAndFruitSpacing = 0.0;

    final mainSkillItemWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: mainSkillBaseItemWidth,
      containerWidth: mainWidth,
      spacing: mainSkillSpacing,
    ).floor().toDouble();

    final ingredientAndFruitItemWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: ingredientAndFruitBaseItemWidth,
      containerWidth: mainWidth,
      spacing: ingredientAndFruitSpacing,
    ).floor().toDouble();

    TextEditingController? nameField;
    final keyword = initialSearchOptions.keyword.obs;

    final res = await _sleepStyleSearchDialog<PokemonSearchOptions>(
      context,
      titleText: 't_pokemon'.xTr,
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
      onOptionsCreated: (searchOptions, search) {
        final ctrl = TextEditingController(text: searchOptions.keyword);
        ctrl.addListener(() {
          searchOptions.keyword = ctrl.text;
          search();
        });
        nameField = ctrl;
      },
      childrenBuilder: (context, search, searchOptions) {
        return [
          ..._wrapHps(
            children: [
              MySubHeader(
                titleText: 't_name_and_nickname'.xTr,
              ),
              Gap.sm,
              TextField(
                controller: nameField,
              ),
              Gap.xl,
              // TODO:
              // MySubHeader(
              //   titleText: 't_attributes'.xTr,
              // ),
              // Gap.sm,
              // Text('一般、火、水、電'),
              // Gap.xl,
              // MySubHeader(
              //   titleText: 't_categories'.xTr,
              // ),
              // Gap.sm,
              // Text('我的最愛、能進化、異色'),
              // Gap.xl,
              MySubHeader(
                titleText: 't_fruits'.xTr,
              ),
              Gap.sm,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: _horizontalListViewPaddingValue / 2,
            ),
            child: Wrap(
              spacing: ingredientAndFruitSpacing,
              runSpacing: 4,
              children: [
                ...Fruit.values.map((fruit) => Container(
                  constraints: BoxConstraints.tightFor(
                    width: ingredientAndFruitItemWidth,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        searchOptions.fruitOf[fruit] = !(
                            searchOptions.fruitOf[fruit] ?? false
                        );
                        search();
                      },
                      child: Row(
                        children: [
                          IgnorePointer(
                            child: Checkbox(
                              value: searchOptions.fruitOf[fruit] ?? false,
                              visualDensity: VisualDensity.compact,
                              onChanged: (v) {
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(
                              fruit.nameI18nKey.xTr,
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
          ..._wrapHps(
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
              left: _horizontalListViewPaddingValue / 2,
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
                        if (searchOptions.ingredientOf.contains(ingredient)) {
                          searchOptions.ingredientOf.remove(ingredient);
                        } else {
                          searchOptions.ingredientOf.add(ingredient);
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
          ..._wrapHps(
            children: [
              Gap.xl,
              MySubHeader(
                titleText: 't_main_skills'.xTr,
              ),
              Gap.sm,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: _horizontalListViewPaddingValue / 2,
            ),
            child: Wrap(
              spacing: mainSkillSpacing,
              runSpacing: 4,
              children: [
                ...MainSkill.values.map((mainSkill) => Container(
                  constraints: BoxConstraints.tightFor(
                    width: mainSkillItemWidth,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (searchOptions.mainSkillOf.contains(mainSkill)) {
                          searchOptions.mainSkillOf.remove(mainSkill);
                        } else {
                          searchOptions.mainSkillOf.add(mainSkill);
                        }
                        search();
                      },
                      child: Row(
                        children: [
                          IgnorePointer(
                            child: Checkbox(
                              value: searchOptions.mainSkillOf.contains(mainSkill),
                              visualDensity: VisualDensity.compact,
                              onChanged: (v) {
                              },
                            ),
                          ),
                          Gap.xs,
                          Expanded(
                            child: Text(
                              mainSkill.nameI18nKey.xTr,
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

    return res;
  }

  static Future<DishSearchOptions> pickDishSearchOptions(BuildContext context, {
    required DishSearchOptions initialSearchOptions,
    (int, int) Function(DishSearchOptions options)? calcCounts,
  }) async {
    final screenSize = context.mediaQuery.size;
    final mainWidth = screenSize.width - 2 * (_horizontalListViewPaddingValue / 2 + _horizontalMarginValue);

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

    return await _sleepStyleSearchDialog<DishSearchOptions>(
      context,
      titleText: 't_recipes'.xTr,
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
      childrenBuilder: (context, search, searchOptions) {
        return [
          ..._wrapHps(
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
              left: _horizontalListViewPaddingValue / 2,
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
          ..._wrapHps(
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
              left: _horizontalListViewPaddingValue / 2,
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

  static Future<T> _sleepStyleSearchDialog<T extends BaseSearchOptions>(BuildContext context, {
    required String titleText,
    required T initialSearchOptions,
    (int, int) Function(T options)? calcCounts,
    Function(T options, VoidCallback search)? onOptionsCreated,
    required List<Widget> Function(BuildContext context, VoidCallback search, T searchOptions) childrenBuilder,
  }) async {
    StateSetter? dialogSetState;
    final searchOptions = initialSearchOptions.clone() as T;

    int? matchCount;
    int? allCount;

    tryCalcCounts() {
      if (calcCounts != null) {
        final calcMatchCount = calcCounts(searchOptions);
        matchCount = calcMatchCount.$1;
        allCount = calcMatchCount.$2;
      }
    }
    tryCalcCounts();

    void search() {
      tryCalcCounts();
      dialogSetState?.call(() {});
    }
    onOptionsCreated?.call(searchOptions, search);

    await sleepStyle(
      context,
      barrierDismissible: false,
      headerBuilder: (context, innerSetState) {
        var suffixHeaderText = '';
        if (matchCount != null && allCount != null) {
          suffixHeaderText += '($matchCount/$allCount)';
        }

        return _header(
          titleText: '$titleText $suffixHeaderText',
          onReset: () {
            searchOptions.clear();
            search();
          },
        );
      },
      childrenBuilder: (context, innerSetState) {
        dialogSetState = innerSetState;
        return childrenBuilder(context, search, searchOptions);
      },
      footerBuilder: (context, innerSetState) => _footer(context),
    );

    return searchOptions;
  }

  static Widget _header({
    required String titleText,
    required VoidCallback onReset,
  }) {
    return Row(
      children: [
        IgnorePointer(
          child: IconButton(
            onPressed: () { },
            icon: const Icon(Icons.search),
          ),
        ),
        Expanded(
          child: Text(
            titleText,
          ),
        ),
        TextButton(
          onPressed: onReset,
          child: Text('t_reset'.xTr),
        ),
      ],
    );
  }

  /// For dialog children in list view
  static Iterable<Widget> _wrapHps({ required List<Widget> children }) {
    return Hp.list(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalListViewPaddingValue,
      ),
      children: children,
    );
  }

  static List<Widget> _footer(BuildContext context) {
    return [
      const Spacer(),
      TextButton(
        onPressed: () => context.nav.pop(),
        child: Text('t_cancel'.xTr),
      ),
      TextButton(
        onPressed: () => context.nav.pop(),
        child: Text('t_ok'.xTr),
      ),
    ];
  }

  static void loading() {

  }

}