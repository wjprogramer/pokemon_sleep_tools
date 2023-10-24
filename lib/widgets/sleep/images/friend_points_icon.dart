import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class FriendPointsIcon extends StatelessWidget {
  const FriendPointsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.favorite,
      color: friendPointsIconColor,
    );
  }
}
