import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.field,
    this.fullName = true,
    this.onTap,
    this.checked,
  });

  final PokemonField field;
  final bool fullName;
  final VoidCallback? onTap;
  final bool? checked;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final baseStyle = theme.textTheme.bodyMedium ?? TextStyle();
    final evaluatedChecked = checked ?? false;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: AssetImage(AssetsPath.field(field)),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
        border: Border.all(
          color: theme.dividerColor,
        ),
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
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: evaluatedChecked ? 1 : 0,
                  child: Icon(
                    Icons.check,
                    size: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    field.nameI18nKey.xTr,
                    style: baseStyle.copyWith(
                    ),
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
