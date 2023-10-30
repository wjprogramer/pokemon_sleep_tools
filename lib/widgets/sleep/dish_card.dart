import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';

/// TODO: use and improve InkWell
/// TODO: 根據不同的 [DishType] 決定不同 Icon
class DishCard extends StatelessWidget {
  const DishCard({
    super.key,
    required this.dish,
    required this.level,
    this.energy,
    this.onTap,
    this.storedIngredientOf,
  });

  final Dish dish;
  final int level;
  final int? energy;
  final VoidCallback? onTap;
  final Map<Ingredient, StoredIngredientItem>? storedIngredientOf;

  static const _radiusValue = 16.0;
  static const _ingredientLabelVerticalPaddingValue = 2.0;

  bool get _shouldCheckQuantity => storedIngredientOf != null;

  Widget _buildQuantity(Ingredient ingredient, int requiredQuantity, TextStyle baseStyle) {
    if (_shouldCheckQuantity) {
      final currCount = storedIngredientOf?[ingredient]?.amount ?? 0;
      final notEnoughCount = requiredQuantity - currCount;

      if (notEnoughCount > 0) {
        return Text(
          '$requiredQuantity (-$notEnoughCount)',
          style: baseStyle.copyWith(
            color: dangerColor,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }

    return Text(
      requiredQuantity.toString(),
      style: baseStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(_radiusValue);

    final ingredientBaseStyle = theme.textTheme.bodySmall ?? const TextStyle();
    final ingredientAndQuantityList = dish.getIngredients();

    Color labelBgColor;
    Color dishBgColor;
    Color dishIconColor;
    Color dishBorderColor;
    Color dishMaterialBgColor;

    switch (dish.dishType) {
      // TODO: Color
      case DishType.currySoup:
        labelBgColor = dishCurryLabelBgColor;
        dishBgColor = dishCurryBgColor;
        dishIconColor = Colors.red.shade300;
        dishBorderColor = Colors.red.shade100;
        dishMaterialBgColor = Colors.red.shade50;
        break;
      case DishType.salad:
        labelBgColor = dishSaladLevelLabelColor;
        dishBgColor = dishSaladBgColor;
        dishIconColor = dishSaladIconColor;
        dishBorderColor = dishSaladBorderColor;
        dishMaterialBgColor = dishSaladMaterialBgColor;
        break;
      case DishType.dessertDrinks:
        labelBgColor = Colors.green;
        dishBgColor = Colors.green.shade50;
        dishIconColor = Colors.green;
        dishBorderColor = Colors.green.shade200;
        dishMaterialBgColor = Colors.green.shade50;
        break;
    }

    final labelFgColor = labelBgColor.getFgColor(luminance: 0.6);
    final energyLabelStyle = theme.textTheme.bodyLarge?.copyWith(
      color: labelFgColor,
      fontWeight: FontWeight.bold,
    );
    final levelLabelStyle = theme.textTheme.bodySmall?.copyWith(
      color: labelFgColor,
    );

    Widget buildEnergyLabel({ bool isPlaceholder = false }) {
      return Row(
        children: [
          EnergyIcon(
            color: labelFgColor,
            size: 16,
          ),
          Gap.xs,
          Stack(
            children: [
              Opacity(
                opacity: 0,
                child: Text(
                  Display.numInt(99999),
                  style: energyLabelStyle,
                ),
              ),
              if (!isPlaceholder)
                Positioned.fill(
                  child: Text(
                    Display.numInt(energy ?? 0),
                    style: energyLabelStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
        ],
      );
    }

    Widget buildLevelLabelValue() {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: labelBgColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
          ),
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0,
              child: Visibility(
                visible: true,
                child: Text(
                  'Lv. $MAX_RECIPE_LEVEL',
                  style: levelLabelStyle,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                '$level',
                style: levelLabelStyle,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Text(
                'Lv.',
                style: levelLabelStyle,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: dishBorderColor,
                width: 1.5,
              ),
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(1, 5),
                  blurRadius: 10,
                  color: theme.shadowColor.withOpacity(0.02),
                ),
              ]
            ),
            child: ClipRRect(
                borderRadius: radius,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        constraints: const BoxConstraints.tightFor(
                          width: 80,
                        ),
                        decoration: BoxDecoration(
                          color: dishBgColor,
                        ),
                        child: Stack(
                          children: [
                            Container(),
                            if (MyEnv.USE_DEBUG_IMAGE)
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: DishIconImage(
                                  dish: dish,
                                  disableTooltip: true,
                                ),
                              )
                            else
                              Align(
                                alignment: const Alignment(0, 0.2),
                                child: Iconify(
                                  Mdi.cutlery_fork_knife,
                                  color: dishIconColor,
                                ),
                              ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: buildLevelLabelValue(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Stack(
                                        children: [
                                          Text('\n'),
                                          Text(
                                            dish.nameI18nKey.xTr,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Gap.sm,
                                  Opacity(
                                    opacity: 0,
                                    child: buildEnergyLabel(isPlaceholder: true),
                                  ),
                                ],
                              ),
                              Gap.sm,
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: _ingredientLabelVerticalPaddingValue,
                                    ),
                                    child: Text(
                                      't_ingredients'.xTr,
                                      style: ingredientBaseStyle?.copyWith(
                                        color: dishSaladIngredientColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Gap.md,
                                  Expanded(
                                    child: Container(
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          if (ingredientAndQuantityList.isEmpty)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: _ingredientLabelVerticalPaddingValue,
                                              ),
                                              child: Text('t_none'.xTr, style: ingredientBaseStyle,),
                                            )
                                          else ...ingredientAndQuantityList.map((ingredientToQuantity) {
                                            final ingredient = ingredientToQuantity.$1;
                                            final quantity = ingredientToQuantity.$2;

                                            Widget labelNameContent;
                                            if (MyEnv.USE_DEBUG_IMAGE) {
                                              labelNameContent = IngredientImage(
                                                size: 20,
                                                ingredient: ingredient,
                                              );
                                            } else {
                                              labelNameContent = Text(
                                                ingredient.nameI18nKey.xTr,
                                                style: ingredientBaseStyle,
                                              );
                                            }

                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: _ingredientLabelVerticalPaddingValue,
                                                    horizontal: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: dishMaterialBgColor,
                                                    borderRadius: MyEnv.USE_DEBUG_IMAGE ? null : BorderRadius.circular(4),
                                                    shape: MyEnv.USE_DEBUG_IMAGE ? BoxShape.circle : BoxShape.rectangle,
                                                  ),
                                                  child: labelNameContent,
                                                ),
                                                _buildQuantity(ingredient, quantity, ingredientBaseStyle),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: labelBgColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(_radiusValue),
                ),
              ),
              child: buildEnergyLabel(),
            ),
          ),
        ],
      ),
    );
  }

}
