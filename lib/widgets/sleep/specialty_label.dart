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
  });

  final PokemonSpecialty specialty;
  final bool fullName;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bgColor = specialty.color;
    final fgColor = bgColor.getFgColor(luminance: 0.5);

    final baseStyle = theme.textTheme.bodySmall ?? TextStyle();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        (fullName ? specialty.nameI18nKey : specialty.shortNameI18nKey).xTr,
        style: baseStyle.copyWith(
          color: fgColor,
        ),
      ),
    );
  }
}
