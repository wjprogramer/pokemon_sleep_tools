import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar({
  String? titleText,
  List<Widget>? actions,
  Widget? title,
}) {
  return AppBar(
    title: titleText != null
        ? Text(titleText)
        : title,
    actions: actions,
  );
}
