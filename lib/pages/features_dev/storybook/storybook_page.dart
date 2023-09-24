import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class MyStorybookPage extends StatelessWidget {
  const MyStorybookPage({super.key});

  static MyPageRoute<void> route = ('/MyStorybook', (_) => const MyStorybookPage());

  @override
  Widget build(BuildContext context) {
    return Storybook(
      stories: [
        AddIcon.story(),
      ],
    );
  }
}
