import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar({
  String? titleText,
}) {
  return AppBar(
    title: titleText != null
        ? Text(titleText)
        : null,
  );
}
