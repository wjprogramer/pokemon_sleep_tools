import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MyPageRoute route = ('/', (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        children: [
          TextButton(
            onPressed: () {
              context.go(MyStorybook.route);
            },
            child: const Text('Storybook'),
          ),
          TextButton(
            onPressed: () {
              context.go(MyStorybook.route);
            },
            child: const Text('Pokemon Box'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(''),
          ),
        ],
      ),
    );
  }
}
