import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/energy_icon.dart';

class DishCard extends StatelessWidget {
  const DishCard({
    super.key,
    required this.dish,
  });

  final Dish dish;

  static const _radiusValue = 16.0;

  @override
  Widget build(BuildContext context) {
    // TODO: improvement InkWell
    final theme = Theme.of(context);

    final radius = BorderRadius.circular(_radiusValue);

    const labelLevelBgColor = dishLevelLabelColor;
    final labelLevelFgColor = labelLevelBgColor.getFgColor(luminance: 0.6);

    return GestureDetector(
      onTap: () {
        debugPrint('Fuck2');
      },
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
                BoxShadow(),
              ]
            ),
            child: ClipRRect(
                borderRadius: radius,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        constraints: BoxConstraints.tightFor(
                          width: 80,
                        ),
                        decoration: BoxDecoration(
                          color: dishBgColor,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: labelLevelBgColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Lv. ',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: labelLevelFgColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // dishLevelLabelColor
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                dish.nameI18nKey.xTr,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Gap.xl,
                              Text(
                                't_ingredients'.xTr,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: dishIngredientColor,
                                  fontWeight: FontWeight.bold,
                                ),
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
                color: labelLevelBgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  EnergyIcon(
                    color: labelLevelFgColor,
                    size: 16,
                  ),
                  Gap.sm,
                  Text(
                    '999',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: labelLevelFgColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDishContent({ required bool isPlaceholder }) {
    return Container();
  }

}
