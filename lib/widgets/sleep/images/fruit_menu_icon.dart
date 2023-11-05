import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class FruitMenuIcon extends StatelessWidget {
  const FruitMenuIcon({
    Key? key,
    this.color,
    this.size,
    this.disableTooltip = false,
  }) : super(key: key);

  final Color? color;
  final double? size;
  final bool disableTooltip;

  @override
  Widget build(BuildContext context) {
    Widget child = Iconify(
      Bi.apple,
      color: color,
      size: size,
    );

    if (!disableTooltip) {
      child = Tooltip(
        message: '樹果',
        child: child,
      );
    }

    return child;
  }
}
