import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class ListItems extends StatelessWidget {
  const ListItems({
    super.key,
    required this.children,
  });

  final List<Widget> children;

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
      children: children.map((e) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          indicator,
          Expanded(child: e),
        ],
      )).toList(),
    );
  }
}
