import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class MyStorybook extends StatelessWidget {
  const MyStorybook({super.key});

  static MyPageRoute<void> route = ('/storybook', (_) => const MyStorybook());

  @override
  Widget build(BuildContext context) {
    return Storybook(
      stories: [
        AddIcon.story(),
      ],
    );
  }
}
