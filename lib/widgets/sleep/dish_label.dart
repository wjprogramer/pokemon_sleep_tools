import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';

const _dishImageOrPlaceholderSize = 32.0;

class DishLabel extends StatelessWidget {
  const DishLabel({
    super.key,
    required this.dish,
  });

  static const defaultImageSize = 32.0;

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    Widget result;

    if (!MyEnv.USE_DEBUG_IMAGE) {
      result = Text(dish.nameI18nKey.xTr);
    } else {
      result = Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DishImage(
              dish: dish,
              width: _dishImageOrPlaceholderSize,
            ),
            Text(
              dish.nameI18nKey.xTr,
              style: textTheme.bodySmall,
            ),
            Gap.sm,
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: dish.dishType.color.withOpacity(.2),
      ),
      child: result,
    );
  }
}
