import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_common/common_picker/common_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator_result/exp_caculator_result_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// 參考 [CheckboxListTile] 整體樣式
/// 參考 [ListTile] 中的 _LisTileDefaultsM3 文字樣式
class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.checked,
    this.onCheckedChanged,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;

  // Checkbox properties
  final bool? checked;
  final ValueChanged<bool?>? onCheckedChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final listTileTheme = theme.listTileTheme;
    final colorScheme = theme.colorScheme;

    final bool hasSubtitle = subtitle != null;
    const isThreeLine = false;
    final bool isTwoLine = !isThreeLine && hasSubtitle;
    final bool isOneLine = !isThreeLine && !hasSubtitle;

    final minHeight = isTwoLine ? 72.0
        : isOneLine ? 56.0
        : 88.0;

    return InkWell(
      onTap: _getOnTap(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: minHeight,
        ),
        child: Row(
          children: [
            Gap.h,
            if (leading != null)
              leading!,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DefaultTextStyle(
                    style: listTileTheme.titleTextStyle ??
                        theme.textTheme.bodyLarge!.copyWith(
                          color: colorScheme.onSurface,
                        ),
                    child: title,
                  ),
                  if (subtitle != null)
                    DefaultTextStyle(
                      style: listTileTheme.subtitleTextStyle ??
                          theme.textTheme.bodyMedium!.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      child: subtitle!,
                    ),
                ],
              ),
            ),
            if (onCheckedChanged != null)
              SizedBox(
                height: CHECKBOX_SIZE,
                child: Checkbox(
                  value: checked,
                  onChanged: onCheckedChanged!,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            Gap.h,
          ],
        ),
      ),
    );
  }

  VoidCallback? _getOnTap() {
    if (onCheckedChanged != null) {
      return () => onCheckedChanged?.call(!(checked ?? false));
    }

    return null;
  }

}
