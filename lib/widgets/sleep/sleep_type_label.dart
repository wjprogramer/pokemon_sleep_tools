import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/ui/ui.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class SleepTypeLabel extends StatelessWidget {
  const SleepTypeLabel({
    super.key,
    required this.sleepType,
    this.onTap,
    this.checked,
  });

  final SleepType sleepType;
  final VoidCallback? onTap;
  final bool? checked;

  @override
  Widget build(BuildContext context) {
    final bgColor = sleepType.color;
    final fgColor = bgColor.fgColor;
    final theme = context.theme;

    final baseStyle = theme.textTheme.bodySmall ?? TextStyle();
    final evaluatedChecked = checked ?? false;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 16,
                  width: evaluatedChecked ? 16 : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    opacity: evaluatedChecked ? 1 : 0,
                    child: Icon(
                      Icons.check,
                      color: fgColor,
                      size: 14,
                    ),
                  ),
                ),
                Text(
                  sleepType.nameI18nKey.xTr,
                  style: baseStyle.copyWith(
                    color: fgColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
