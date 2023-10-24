import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/pokemon_specialty.dart';

class SpecialtyLabel extends StatelessWidget {
  const SpecialtyLabel({
    super.key,
    required this.specialty,
    this.fullName = true,
    this.onTap,
    this.checked,
  });

  final PokemonSpecialty specialty;
  final bool fullName;
  final VoidCallback? onTap;
  final bool? checked;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bgColor = specialty.color;
    final fgColor = bgColor.getFgColor(luminance: 0.5);

    final baseStyle = theme.textTheme.bodySmall ?? TextStyle();
    final evaluatedChecked = checked ?? false;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
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
                  (fullName ? specialty.nameI18nKey : specialty.shortNameI18nKey).xTr,
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
