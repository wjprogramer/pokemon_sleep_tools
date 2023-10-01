import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class EnergyIcon extends StatelessWidget {
  const EnergyIcon({
    super.key,
    this.size,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.local_fire_department_outlined,
      color: color ?? warningColor,
      size: size,
    );
  }
}
