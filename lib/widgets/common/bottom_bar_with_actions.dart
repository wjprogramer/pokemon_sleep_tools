import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/common/my_outlined_button_2.dart';

class BottomBarWithActions extends StatelessWidget {
  const BottomBarWithActions({
    super.key,
    this.onSearch,
    this.isSearchOn,
    this.onFilter,
    this.filterText,
    this.onAscendingChanged,
    this.isAscending = false,
  });

  final Function()? onSearch;
  final bool? isSearchOn;
  final Function()? onFilter;
  final String? filterText;
  final ValueChanged<bool>? onAscendingChanged;
  final bool isAscending;

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
              if (onFilter != null)
                Padding(
                  padding: const EdgeInsets.only(right: spacing),
                  child: MyOutlinedButton2(
                    onPressed: () => onSearch?.call(),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list),
                        Text(filterText ?? ''),
                      ],
                    ),
                  ),
                ),
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
