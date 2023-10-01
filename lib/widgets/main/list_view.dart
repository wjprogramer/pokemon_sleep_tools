import 'package:flutter/material.dart';

Widget buildListView({
  required List<Widget> children,
  EdgeInsetsGeometry? padding,
}) {
  return ListView.builder(
    padding: padding,
    itemCount: children.length,
    itemBuilder: (context, index) {
      return children[index];
    },
  );
}