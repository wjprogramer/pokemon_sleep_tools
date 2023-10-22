import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

enum ListItemsDecoration {
  dot,
  number,
}

class ListItems extends StatelessWidget {
  const ListItems({
    super.key,
    required this.children,
    this.decoration = ListItemsDecoration.dot,
  });

  final List<Widget> children;
  final ListItemsDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final indicator = Padding(
      padding: const EdgeInsets.only(top: 4),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: theme.textTheme.bodyMedium?.fontSize ?? 20,
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(
              right: 8,
            ),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: blackColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children.mapIndexed((i, e) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (e is! ListItems) ...[
            switch (decoration) {
              ListItemsDecoration.dot => indicator,
              ListItemsDecoration.number => Text('${i + 1}. '),
            },
          ],
          Expanded(
            child: e is! ListItems ? e : Padding(
              padding: const EdgeInsets.only(left: 16),
              child: e,
            ),
          ),
        ],
      )).toList(),
    );
  }
}
