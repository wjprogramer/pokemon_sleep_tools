import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar({
  String? titleText,
  List<Widget>? actions,
}) {
  return AppBar(
    title: titleText != null
        ? Text(titleText)
        : null,
    actions: actions,
  );
}
