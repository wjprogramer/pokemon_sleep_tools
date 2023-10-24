import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class FieldMenuIcon extends StatelessWidget {
  const FieldMenuIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Iconify(GameIcons.island, color: islandColor);
  }
}
