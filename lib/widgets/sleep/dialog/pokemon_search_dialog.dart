import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/base_dialog.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog_data.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog_data.dart';

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
        return [
          ...SleepSearchDialogBaseContent.hpList(
            children: [
              MySubHeader(
                titleText: 't_name_and_nickname'.xTr,
              ),
              Gap.sm,
              TextField(
                controller: _nameField,
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
              left: sleepStyleSearchDialogHorizontalListViewPaddingValue / 2,
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
                        if (searchOptions.fruitOf.contains(fruit)) {
                          searchOptions.fruitOf.remove(fruit);
                        } else {
                          searchOptions.fruitOf.add(fruit);
                        }
                        search();
                      },
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
          Gap.xl,
        ];
      },
      calcCounts: widget.calcCounts,
    );
  }
}




