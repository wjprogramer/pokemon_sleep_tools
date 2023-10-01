import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';

class MainMenuSubtitle extends StatelessWidget {
  const MainMenuSubtitle({
    super.key,
    required this.icon,
    required this.title,
    this.paddingTop,
  });

  final Widget icon;
  final Widget title;

  final double? paddingTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop ?? Gap.xxl.mainAxisExtent,
        bottom: Gap.md.mainAxisExtent,
      ),
      child: Row(
        children: [
          icon,
          Gap.sm,
          Expanded(child: title,),
        ],
      ),
    );
  }
}
