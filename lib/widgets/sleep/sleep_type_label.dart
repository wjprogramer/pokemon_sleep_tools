import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/ui/ui.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class SleepTypeLabel extends StatelessWidget {
  const SleepTypeLabel({
    super.key,
    required this.sleepType,
  });

  final SleepType sleepType;

  @override
  Widget build(BuildContext context) {
    final bgColor = sleepType.color;
    final fgColor = bgColor.fgColor;
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        sleepType.nameI18nKey.xTr,
        style: (theme.textTheme.bodySmall ?? TextStyle()).copyWith(
          color: fgColor,
        ),
      ),
    );
  }
}
