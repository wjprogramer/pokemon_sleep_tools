import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// 參考 [CheckboxListTile] 整體樣式
/// 參考 [ListTile] 中的 _LisTileDefaultsM3 文字樣式
class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
    this.checked,
    this.onCheckedChanged,
    this.isCheckboxRight = true,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final VoidCallback? onTap;

  // Checkbox properties
  final bool? checked;
  final ValueChanged<bool?>? onCheckedChanged;
  final bool isCheckboxRight;

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
            if (onCheckedChanged != null && !isCheckboxRight)
              Padding(
                padding: const EdgeInsets.only(right: Gap.mdV),
                child: _buildCheckbox(),
              ),
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
            if (onCheckedChanged != null && isCheckboxRight)
              _buildCheckbox(),
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
    return onTap;
  }

  Widget _buildCheckbox() {
    return SizedBox(
      height: CHECKBOX_SIZE,
      child: IgnorePointer(
        child: Checkbox(
          value: checked,
          onChanged: onCheckedChanged ?? (_) {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

}
