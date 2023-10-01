import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class AddIcon extends StatelessWidget {
  const AddIcon({super.key});

  static Story story() {
    return Story(
      name: 'Add Icon',
      builder: (_) => const AddIcon(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.add_circle,
      color: color1,
    );
  }
}

