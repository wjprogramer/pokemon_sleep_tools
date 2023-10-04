import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class CandyIcon extends StatelessWidget {
  const CandyIcon({
    Key? key,
    this.color = pinkColor,
    this.size,
  }) : super(key: key);

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Iconify(Mdi.candy, color: color, size: size,);
  }
}
