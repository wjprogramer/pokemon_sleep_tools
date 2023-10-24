import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class EnergyIcon extends StatelessWidget {
  const EnergyIcon({
    super.key,
    this.size,
    this.color,
    this.disableTooltip = false,
  });

  final double? size;
  final Color? color;
  final bool disableTooltip;

  @override
  Widget build(BuildContext context) {
    Widget result = Icon(
      Icons.local_fire_department_outlined,
      color: color ?? warningColor,
      size: size,
    );

    if (!disableTooltip) {
      result = Tooltip(
        message: '能量'.xTr,
        child: result,
      );
    }

    return result;
  }
}
