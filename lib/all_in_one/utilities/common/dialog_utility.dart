import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

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

  static Future<void> sleepStyle(BuildContext context, {
    bool barrierDismissible = true,
    DialogContentChildBuilder? headerBuilder,
    DialogContentChildrenBuilder? childrenBuilder,
    DialogContentChildrenBuilder? footerBuilder,
  }) async {
    const horizontalMarginValue = 24.0;
    const horizontalListViewPaddingValue = 16.0;

    const mainSkillBaseItemWidth = 120.0;
    const mainSkillSpacing = 0.0;

    const ingredientAndFruitBaseItemWidth = 90.0;
    const ingredientAndFruitSpacing = 0.0;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        final screenSize = context.mediaQuery.size;
        final dialogHeight = math.min(screenSize.height * 0.8, 800).toDouble();
        final theme = context.theme;
        final mainWidth = screenSize.width - 2 * (horizontalListViewPaddingValue / 2 + horizontalMarginValue);

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

        Widget wrapHp({ required Widget child, }) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalListViewPaddingValue,
            ),
            child: child,
          );
        }

        Iterable<Widget> wrapHps({ required List<Widget> children }) {
          return children.map((e) => wrapHp(child: e));
        }

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
                        padding: const EdgeInsets.all(8.0),
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

  static Future<void> pickPokemonSearchFilters(BuildContext context) async {
    const horizontalMarginValue = 24.0;
    const horizontalListViewPaddingValue = 16.0;

    const mainSkillBaseItemWidth = 120.0;
    const mainSkillSpacing = 0.0;

    const ingredientAndFruitBaseItemWidth = 90.0;
    const ingredientAndFruitSpacing = 0.0;

    final screenSize = context.mediaQuery.size;
    final dialogHeight = math.min(screenSize.height * 0.8, 800).toDouble();
    final theme = context.theme;
    final mainWidth = screenSize.width - 2 * (horizontalListViewPaddingValue / 2 + horizontalMarginValue);

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

    Widget wrapHp({ required Widget child, }) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalListViewPaddingValue,
        ),
        child: child,
      );
    }

    Iterable<Widget> wrapHps({ required List<Widget> children }) {
      return children.map((e) => wrapHp(child: e));
    }

    sleepStyle(
      context,
      barrierDismissible: false,
      headerBuilder: (context, innerSetState) {
        return Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            Expanded(
              child: Text(
                '${'t_pokemon'.xTr} (20/42)', // TODO: 寶可夢盒 (符合條件/總共數量)
              ),
            ),
            TextButton(
              onPressed: () {
                context.nav.pop();
              },
              child: Text('t_reset'.xTr),
            ),
          ],
        );
      },
      childrenBuilder: (context, innerSetState) {
        return [
          ...wrapHps(
            children: [
              MySubHeader(
                titleText: 't_name_and_nickname'.xTr,
              ),
              Gap.sm,
              TextField(),
              Gap.xl,
              MySubHeader(
                titleText: 't_attributes'.xTr,
              ),
              Gap.sm,
              Text('一般、火、水、電'),
              Gap.xl,
              MySubHeader(
                titleText: 't_categories'.xTr,
              ),
              Gap.sm,
              Text('我的最愛、能進化、異色'),
              Gap.xl,
              MySubHeader(
                titleText: 't_fruits'.xTr,
              ),
              Gap.sm,
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: horizontalListViewPaddingValue / 2,
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
                      onTap: () {},
                      child: Row(
                        children: [
                          Checkbox(
                            value: true,
                            visualDensity: VisualDensity.compact,
                            onChanged: (v) {},
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
          ...wrapHps(
            children: [
              Gap.xl,
              MySubHeader(
                titleText: 't_ingredients'.xTr,
              ),
              Gap.sm,
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: horizontalListViewPaddingValue / 2,
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
                      onTap: () {},
                      child: Row(
                        children: [
                          Checkbox(
                            value: true,
                            visualDensity: VisualDensity.compact,
                            onChanged: (v) {},
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
          ...wrapHps(
            children: [
              Gap.xl,
              MySubHeader(
                titleText: 't_skills'.xTr,
              ),
              Gap.sm,
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: horizontalListViewPaddingValue / 2,
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
                      onTap: () {},
                      child: Row(
                        children: [
                          Checkbox(
                            value: true,
                            visualDensity: VisualDensity.compact,
                            onChanged: (v) {},
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
      footerBuilder: (context, innerSetState) {
        return [
          Spacer(),
          TextButton(
            onPressed: () {
              context.nav.pop();
            },
            child: Text('t_cancel'.xTr),
          ),
          TextButton(
            onPressed: () {
              context.nav.pop();
            },
            child: Text('t_ok'.xTr),
          ),
        ];
      },
    );
  }

  static void loading() {

  }

}