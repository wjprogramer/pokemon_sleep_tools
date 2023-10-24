import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class BookmarkIcon extends StatelessWidget {
  const BookmarkIcon({
    Key? key,
    required this.marked,
    this.unMarkColor,
    this.size,
  }) : super(key: key);

  final bool marked;
  final Color? unMarkColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      marked ? Icons.bookmark : Icons.bookmark_border,
      color: marked ? orangeColor : unMarkColor,
      size: size,
    );
  }
}
