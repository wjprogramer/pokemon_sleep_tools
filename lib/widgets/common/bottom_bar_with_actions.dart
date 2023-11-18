import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/common/my_outlined_button_2.dart';

class BottomBarWithActions extends StatelessWidget {
  const BottomBarWithActions({
    super.key,
    this.onSearch,
    this.isSearchOn,
    this.onSort,
    this.sortText,
    this.onAscendingChanged,
    this.isAscending = false,
    this.suffixActions,
    this.onVisibleChanged,
    this.isVisible,
  });

  // UI
  static const _iconSize = 16.0;
  static const _textSize = 12.0;

  // Search
  final Function()? onSearch;
  final bool? isSearchOn;

  // Sort
  final Function()? onSort;
  final String? sortText;
  final ValueChanged<bool>? onAscendingChanged;
  final bool isAscending;

  // Visible
  final ValueChanged<bool>? onVisibleChanged;
  final bool? isVisible;

  // Others
  final List<Widget>? suffixActions;

  @override
  Widget build(BuildContext context) {
    const spacing = Gap.mdV;
    const buttonHorizontalSpacing = Gap.md;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: Divider.createBorderSide(context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Gap.mdV, Gap.smV, 0, Gap.smV,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onVisibleChanged != null)
                Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: MyOutlinedButton2(
                    onPressed: () => onVisibleChanged?.call((!(isVisible ?? false))),
                    child: Row(
                      children: [
                        Icon(
                          isVisible ?? false ? Icons.visibility : Icons.visibility_off,
                        ),
                      ],
                    ),
                  ),
                ),
              if (onSearch != null)
                Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: MyOutlinedButton2.compact(
                    onPressed: () => onSearch?.call(),
                    child: Row(
                      children: [
                        buttonHorizontalSpacing,
                        const Icon(
                          Icons.search,
                          size: _iconSize,
                        ),
                        if (isSearchOn != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: Gap.smV,
                            ),
                            child: Text(
                              isSearchOn ?? false ? 'On' : 'Off',
                              style: const TextStyle(fontSize: _textSize),
                            ),
                          ),
                        buttonHorizontalSpacing,
                      ],
                    ),
                  ),
                ),
              if (onSort != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: MyOutlinedButton2.compact(
                    onPressed: () => onSort?.call(),
                    child: Row(
                      children: [
                        buttonHorizontalSpacing,
                        const Icon(
                          Icons.sort,
                          size: _iconSize,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: (sortText ?? '').isEmpty ? 0 : Gap.smV,
                          ),
                          child: Text(
                            sortText ?? '',
                            style: const TextStyle(fontSize: _textSize),
                          ),
                        ),
                        buttonHorizontalSpacing,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: MyOutlinedButton2.compact(
                    onPressed: () => onAscendingChanged?.call(!isAscending),
                    child: Icon(
                      isAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: _iconSize,
                    ),
                  ),
                ),
              ],
              ...?suffixActions,
              // Padding(
              //   padding: const EdgeInsets.only(right: spacing),
              //   child: MyOutlinedButton2(
              //     onPressed: () => onSearch?.call(),
              //     child: Row(
              //       children: [
              //         Icon(Icons.sort),
              //         Text(filterText ?? ''),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
