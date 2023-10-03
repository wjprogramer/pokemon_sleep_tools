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
  });

  final Function()? onSearch;
  final bool? isSearchOn;
  final Function()? onSort;
  final String? sortText;
  final ValueChanged<bool>? onAscendingChanged;
  final bool isAscending;

  final List<Widget>? suffixActions;

  @override
  Widget build(BuildContext context) {
    const spacing = Gap.mdV;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: Divider.createBorderSide(context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Gap.mdV, Gap.xsV, 0, 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onSearch != null)
                Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: MyOutlinedButton2(
                    onPressed: () => onSearch?.call(),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        if (isSearchOn != null)
                          Text(isSearchOn ?? false ? 'On' : 'Off'),
                      ],
                    ),
                  ),
                ),
              if (onSort != null)
                Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: MyOutlinedButton2(
                    onPressed: () => onSort?.call(),
                    child: Row(
                      children: [
                        Icon(Icons.sort),
                        Text(sortText ?? ''),
                      ],
                    ),
                  ),
                ),
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
