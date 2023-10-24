import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/field_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

Future<PokemonSearchOptions?> showPokemonSearchDialog(BuildContext context, {
  required String titleText,
  required PokemonSearchOptions initialSearchOptions,
  CalculateCounts<PokemonSearchOptions>? calcCounts,
}) async {
  final res = await showSleepDialog(
    context,
    barrierDismissible: false,
    child: PokemonSearchDialog(
      titleText: titleText,
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
    ),
  );

  return res is PokemonSearchOptions ? res : null;
}

/// TODO: 感覺可以用 [TabBarView], [TabBar] 處理資料過長的問題
class PokemonSearchDialog extends StatefulWidget {
  const PokemonSearchDialog({
    super.key,
    required this.titleText,
    required this.initialSearchOptions,
    this.calcCounts,
  });

  final String titleText;
  final PokemonSearchOptions initialSearchOptions;
  final CalculateCounts<PokemonSearchOptions>? calcCounts;

  void popResult(BuildContext context, [ PokemonSearchOptions? value ]) {
    context.nav.pop(value);
  }

  @override
  State<PokemonSearchDialog> createState() => _PokemonSearchDialogState();
}

class _PokemonSearchDialogState extends State<PokemonSearchDialog> {
  FieldViewModel get _fieldViewModel => context.read<FieldViewModel>();
  var _ingredientLabelType = _IngredientLabelType.all;

  late TextEditingController _nameField;

  @override
  void initState() {
    super.initState();
    _nameField = TextEditingController(
      text: widget.initialSearchOptions.keyword,
    );
  }

  @override
  void dispose() {
    _nameField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = context.mediaQuery.size;
    final mainWidth = screenSize.width - 2 * (sleepStyleSearchDialogHorizontalListViewPaddingValue / 2 + sleepStyleSearchDialogHorizontalMarginValue);

    const mainSkillBaseItemWidth = 140.0;
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

    return SleepSearchDialogBaseContent<PokemonSearchOptions>(
      titleText: widget.titleText,
      initialSearchOptions: widget.initialSearchOptions,
      onOptionsCreated: (options, search) {
        _nameField.addListener(() {
          options.setKeywordWithoutListen(_nameField.text);
          search();
        });
        options.addKeywordListener((value) {
          _nameField.text = value;
          search();
        });
      },
      childrenBuilder: (context, search, searchOptions) {
        final keywordFieldIsEmpty = _nameField.text.trim().isEmpty;

        return [
          ...SleepSearchDialogBaseContent.hpList(
            children: [
              MySubHeader(
                titleText: 't_specialty'.xTr,
              ),
              Gap.sm,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...PokemonSpecialty.values.map((specialty) => SpecialtyLabel(
                    specialty: specialty,
                    checked: searchOptions.specialtyOf.contains(specialty),
                    onTap: () {
                      searchOptions.specialtyOf.toggle(specialty);
                      search();
                    },
                  )),
                ],
              ),
              MySubHeader(
                titleText: 't_name_and_nickname'.xTr,
              ),
              Gap.sm,
              TextField(
                controller: _nameField,
                decoration: InputDecoration(
                  suffixIcon: AnimatedOpacity(
                    opacity: keywordFieldIsEmpty ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      onPressed: keywordFieldIsEmpty ? null : () {
                        _nameField.clear();
                        searchOptions.setKeywordWithoutListen('');
                        search();
                      },
                      icon: Icon(
                        Icons.clear,
                      ),
                    ),
                  ),
                ),
              ),
              Gap.xl,
              MySubHeader(
                titleText: 't_attributes'.xTr,
              ),
              Gap.sm,
              Wrap(
                spacing: 0,
                runSpacing: 0,
                children: [
                  if (MyEnv.USE_DEBUG_IMAGE) ...[
                    ...PokemonType.values.map((pokemonType) => IconButton(
                      onPressed: () {
                        if (searchOptions.typeof.contains(pokemonType)) {
                          searchOptions.typeof.remove(pokemonType);
                        } else {
                          searchOptions.typeof.add(pokemonType);
                        }
                        search();
                      },
                      tooltip: pokemonType.nameI18nKey.xTr,
                      icon: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: PokemonTypeImage(
                              pokemonType: pokemonType,
                              width: 30,
                            ),
                          ),
                          if (searchOptions.typeof.contains(pokemonType)) Positioned(
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
                    ))
                  ],
                ],
              ),
              Gap.xl,
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
              left: sleepStyleSearchDialogHorizontalListViewPaddingValue / 2,
            ),
            child: Wrap(
              spacing: ingredientAndFruitSpacing,
              runSpacing: 4,
              children: [
                if (MyEnv.USE_DEBUG_IMAGE) ...Fruit.values.map((fruit) => IconButton(
                  onPressed: () => _toggleFruit(fruit, searchOptions, search),
                  tooltip: fruit.nameI18nKey.xTr,
                  icon: Stack(
                    children: [
                      FruitImage(
                        fruit: fruit,
                        width: 30,
                      ),
                      if (searchOptions.fruitOf.contains(fruit)) Positioned(
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
                )) else ...Fruit.values.map((fruit) => Container(
                  constraints: BoxConstraints.tightFor(
                    width: ingredientAndFruitItemWidth,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _toggleFruit(fruit, searchOptions, search),
                      child: Row(
                        children: [
                          IgnorePointer(
                            child: Checkbox(
                              value: searchOptions.fruitOf.contains(fruit),
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
          TextButton(
            onPressed: () async {
              final filedForSnorlax = await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    content: Container(
                      constraints: BoxConstraints.tightFor(
                        height: screenSize.height * 0.5,
                        width: mainWidth,
                      ),
                      child: ListView(
                        children: [
                          ...PokemonField.values.map((field) => ListTile(
                            onTap: () {
                              context.nav.pop(field);
                            },
                            title: Text(field.nameI18nKey.xTr),
                          )),
                        ],
                      ),
                    ),
                  );
                },
              );

              if (filedForSnorlax is! PokemonField) {
                return;
              }

              List<Fruit> fruits;
              if (filedForSnorlax == PokemonField.f1) {
                fruits = _fieldViewModel.getItem(filedForSnorlax).fruits;
              } else {
                fruits = filedForSnorlax.fruits;
              }
              searchOptions.fruitOf
                ..clear()
                ..addAll(fruits);
              search();
            },
            child: Text('t_snorlax_s_favorite_tree_fruit'.xTr),
          ),
          ...SleepSearchDialogBaseContent.hpList(
            children: [
              Gap.xl,
              MySubHeader(
                titleText: 't_ingredients'.xTr,
              ),
              Gap.sm,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ..._IngredientLabelType.valueList
                        .map((ingredientLabelType) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildIngredientLabelTypeChip(ingredientLabelType, search, searchOptions),
                        )),
                  ],
                ),
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
                ...Ingredient.values.map((ingredient) {
                  final disableIngredient = _ingredientLabelType == _IngredientLabelType.lv1 &&
                      ingredient.disableLv1;

                  if (MyEnv.USE_DEBUG_IMAGE) {
                    return IconButton(
                      onPressed: disableIngredient
                          ? null
                          : () => _toggleIngredient(ingredient, searchOptions, search),
                      tooltip: ingredient.nameI18nKey.xTr,
                      icon: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: disableIngredient ? greyColor2 : null,
                              shape: BoxShape.circle,
                            ),
                            child: IngredientImage(
                              ingredient: ingredient,
                              width: 30,
                            ),
                          ),
                          if (_isIngredientChecked(searchOptions, ingredient)) Positioned(
                            right: 5,
                            bottom: 5,
                            child: Container(
                              width: 10,
                              height: 10,
                              child: Icon(
                                Icons.check,
                                color: _isIngredientCheckedByCurrentFilterOption(searchOptions, ingredient)
                                    ? primaryColor : primaryColor.withOpacity(.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    constraints: BoxConstraints.tightFor(
                      width: ingredientAndFruitItemWidth,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleIngredient(ingredient, searchOptions, search),
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
                  );
                }),
                // if (MyEnv.USE_DEBUG_IMAGE) ...Ingredient.values.map((ingredient) => ) else ...Ingredient.values.map((ingredient) => ),
              ],
            ),
          ),
          ...SleepSearchDialogBaseContent.hpList(
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
              left: sleepStyleSearchDialogHorizontalListViewPaddingValue / 2,
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
          ...SleepSearchDialogBaseContent.hpList(
            children: [
              Gap.xl,
              MySubHeader(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        't_discoverable_islands'.xTr,
                      ),
                    ),
                    Tooltip(
                      message: '寶可夢可在哪些島嶼上發現'.xTr,
                      child: Icon(
                        Icons.info_outline,
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: PokemonField.values.map((field) => FieldLabel(
                  field: field,
                  checked: searchOptions.fieldOf.contains(field),
                  onTap: () {
                    searchOptions.fieldOf.toggle(field);
                    search();
                  },
                )).toList(),
              ),
              Gap.sm,
              if (kDebugMode) ...[
                MySubHeader(
                  titleText: 't_evolutionary_stage'.xTr,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('t_current_stage'.xTr),
                    ...[1,2,3].map((evolutionStage) => _buildEvolutionChip(
                      number: evolutionStage,
                      checked: searchOptions.currEvolutionStageOf.contains(evolutionStage),
                      onTap: () {
                        searchOptions.currEvolutionStageOf.toggle(evolutionStage);
                        search();
                      },
                    )),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('t_final_stage'.xTr),
                    ...[1,2,3].map((evolutionStage) => _buildEvolutionChip(
                      number: evolutionStage,
                      checked: searchOptions.maxEvolutionStageOf.contains(evolutionStage),
                      onTap: () {
                        searchOptions.maxEvolutionStageOf.toggle(evolutionStage);
                        search();
                      },
                    )),
                  ],
                ),
              ],
              Gap.sm,
              MySubHeader(
                titleText: 't_sleep_type'.xTr,
              ),
              Gap.sm,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...SleepType.values.whereNot((e) => e == SleepType.st99).map((sleepType) => SleepTypeLabel(
                    sleepType: sleepType,
                    checked: searchOptions.sleepTypeOf.contains(sleepType),
                    onTap: () {
                      searchOptions.sleepTypeOf.toggle(sleepType);
                      search();
                    },
                  )),
                ],
              ),
            ],
          ),
          Gap.xl,
        ];
      },
      calcCounts: widget.calcCounts,
    );
  }

  void _toggleIngredient(Ingredient ingredient, PokemonSearchOptions searchOptions, Function() search) {
    final ingredientOf = switch (_ingredientLabelType) {
      _IngredientLabelType.all => searchOptions.ingredientOf,
      _IngredientLabelType.lv1 => searchOptions.ingredientOfLv1,
      _IngredientLabelType.lv30 => searchOptions.ingredientOfLv30,
      _IngredientLabelType.lv60 => searchOptions.ingredientOfLv60,
    };

    switch (_ingredientLabelType) {
      case _IngredientLabelType.all:
        if (!searchOptions.ingredientOf.contains(ingredient)) {
          searchOptions
            ..ingredientOfLv1.remove(ingredient)
            ..ingredientOfLv30.remove(ingredient)
            ..ingredientOfLv60.remove(ingredient);
        }
        searchOptions.ingredientOf.toggle(ingredient);
        break;
      case _IngredientLabelType.lv1:
      case _IngredientLabelType.lv30:
      case _IngredientLabelType.lv60:
        ingredientOf.toggle(ingredient);
        break;
    }
    search();
  }

  void _toggleFruit(Fruit fruit, PokemonSearchOptions searchOptions, Function() search) {
    if (searchOptions.fruitOf.contains(fruit)) {
      searchOptions.fruitOf.remove(fruit);
    } else {
      searchOptions.fruitOf.add(fruit);
    }
    search();
  }

  Widget _buildIngredientLabelTypeChip(_IngredientLabelType ingredientLabelType, VoidCallback search, PokemonSearchOptions searchOptions) {
    const color = blackColor;
    final borderRadius = BorderRadius.circular(8);
    final isSelected = _ingredientLabelType == ingredientLabelType;
    final selectedIngredientCount = switch (ingredientLabelType) {
      _IngredientLabelType.all => searchOptions.ingredientOf.length,
      _IngredientLabelType.lv1 => searchOptions.ingredientOfLv1.length,
      _IngredientLabelType.lv30 => searchOptions.ingredientOfLv30.length,
      _IngredientLabelType.lv60 => searchOptions.ingredientOfLv60.length,
    };

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: ingredientLabelType.tooltip.xTr,
        child: InkWell(
          onTap: () {
            setState(() {
              _ingredientLabelType = ingredientLabelType;
            });
          },
          borderRadius: borderRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4, vertical: 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? positiveColor : color.withOpacity(.3),
              ),
              borderRadius: borderRadius,
              color: isSelected ? positiveColor.withOpacity(.3) : null,
            ),
            constraints: const BoxConstraints(
              minWidth: 50,
            ),
            child: Text(
              '${ingredientLabelType.nameI18nKey.xTr} ${selectedIngredientCount == 0 ? '' : ' ($selectedIngredientCount)'}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  bool _isIngredientCheckedByCurrentFilterOption(PokemonSearchOptions searchOptions, Ingredient ingredient) {
    final ingredientOf = switch (_ingredientLabelType) {
      _IngredientLabelType.all => searchOptions.ingredientOf,
      _IngredientLabelType.lv1 => searchOptions.ingredientOfLv1,
      _IngredientLabelType.lv30 => searchOptions.ingredientOfLv30,
      _IngredientLabelType.lv60 => searchOptions.ingredientOfLv60,
    };

    if (_ingredientLabelType == _IngredientLabelType.all) {
      return ingredientOf.contains(ingredient);
    }

    return ingredientOf.contains(ingredient);
  }

  bool _isIngredientChecked(PokemonSearchOptions searchOptions, Ingredient ingredient) {
    final ingredientOf = switch (_ingredientLabelType) {
      _IngredientLabelType.all => searchOptions.ingredientOf,
      _IngredientLabelType.lv1 => searchOptions.ingredientOfLv1,
      _IngredientLabelType.lv30 => searchOptions.ingredientOfLv30,
      _IngredientLabelType.lv60 => searchOptions.ingredientOfLv60,
    };

    if (_ingredientLabelType == _IngredientLabelType.all) {
      return ingredientOf.contains(ingredient);
    }

    return searchOptions.ingredientOf.contains(ingredient) ||
        ingredientOf.contains(ingredient);
  }

  Widget _buildEvolutionChip({
    required int number,
    required bool checked,
    required VoidCallback onTap,
  }) {
    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Ink(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      number.toString(),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: greyColor2,
                    shape: BoxShape.circle,
                  ),
                )
              ),
            ),
          ),
        ),
        if (checked) Positioned(
          right: 0,
          bottom: 5,
          child: IgnorePointer(
            child: Container(
              child: Icon(
                Icons.check,
                color: primaryColor,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

}

enum _IngredientLabelType {
  all('t_no_level_limit', '搜尋所有食材'),
  lv1('Lv 1', '只搜尋 Lv 1 的食材'),
  lv30('Lv 30', '只搜尋 Lv 30 的食材'),
  lv60('Lv 60', '只搜尋 Lv 60 的食材');

  const _IngredientLabelType(this.nameI18nKey, this.tooltip);

  final String nameI18nKey;
  final String tooltip;

  static List<_IngredientLabelType> valueList = [
    all,
    lv1,
    lv30,
    lv60,
  ];
}




