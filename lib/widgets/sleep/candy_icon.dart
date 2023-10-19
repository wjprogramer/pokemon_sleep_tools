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
    Widget result;

    if (MyEnv.USE_DEBUG_IMAGE) {
      result = Iconify(Mdi.candy, color: color, size: size,);
    } else {
      result = Iconify(Mdi.candy, color: color, size: size,);
    }

    return result;
  }
}
