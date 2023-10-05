import 'package:flutter/material.dart';

Widget buildListView({
  required List<Widget> children,
  ScrollController? controller,
  EdgeInsetsGeometry? padding,
}) {
  return ListView.builder(
    controller: controller,
    padding: padding,
    itemCount: children.length,
    itemBuilder: (context, index) {
      return children[index];
    },
  );
}