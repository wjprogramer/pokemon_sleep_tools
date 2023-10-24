import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/pokemon_rank_title_icon.dart';

class SnorlaxRankItem extends StatelessWidget {
  const SnorlaxRankItem({
    super.key,
    required this.rank,
  });

  final SnorlaxRank rank;

  @override
  Widget build(BuildContext context) {
    const baseFontSize = 14.0;

    final style = context.textTheme.bodySmall ?? const TextStyle(
      fontSize: baseFontSize,
    );
    final iconSize = (style.fontSize ?? baseFontSize) * 1.2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2, horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: rank.title.bgColor.withOpacity(.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle,
              ),
              child: PokemonRankTitleIcon(
                rank: rank.title,
                size: iconSize,
              ),
            ),
            Gap.xs,
            Text(
              '${rank.title.nameI18nKey.xTr} ${rank.number}',
              style: style,
            ),
          ]
        ),
      ),
    );
  }

}
