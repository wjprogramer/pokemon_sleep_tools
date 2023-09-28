import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/storybook/storybook_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_food_menu/pokemon_food_menu_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/widgets/main/gap.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  double _menuButtonWidth = 100;
  double _menuButtonSpacing = 0;

  // TODO: 語言切換、地圖、圖鑑、
  @override
  Widget build(BuildContext context) {
    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _menuButtonWidth = menuItemWidthResults.childWidth;
    _menuButtonSpacing = menuItemWidthResults.spacing;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING,
      ),
      children: [
        const Text(
          '常用',
        ),
        Wrap(
          spacing: _menuButtonSpacing,
          runSpacing: _menuButtonSpacing,
          children: _wrapMenuItems(
            children: [
              MyElevatedButton(
                onPressed: () {
                  PokemonFoodMenuPage.go(context);
                },
                child: Text('t_food'.xTr),
              ),
              MyElevatedButton(
                onPressed: () {},
                child: const Text(''),
              ),
              MyElevatedButton(
                onPressed: () {},
                child: const Text(''),
              ),
            ],
          ),
        ),
        Gap.xl,
        const Text(
          '選單',
        ),
        Wrap(
          spacing: _menuButtonSpacing,
          runSpacing: _menuButtonSpacing,
          children: _wrapMenuItems(
            children: [
              MyElevatedButton(
                onPressed: () {},
                child: const Text(''),
              ),
              MyElevatedButton(
                onPressed: () {},
                child: const Text(''),
              ),
              
            ],
          ),
        ),
        if (kDebugMode) ...[
          Gap.xl,
          Text(
            't_developing'.xTr,
          ),
          Wrap(
            spacing: _menuButtonSpacing,
            runSpacing: _menuButtonSpacing,
            children: _wrapMenuItems(
              children: [
                MyElevatedButton(
                  onPressed: () {
                    context.nav.push(MyStorybookPage.route);
                  },
                  child: const Text('Storybook'),
                ),
                MyElevatedButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
                MyElevatedButton(
                  onPressed: () {},
                  child: const Text(''),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _wrapMenuItems({ required List<Widget> children }) {
    return children
        .map((e) => _wrapMenuItemContainer(child: e))
        .toList();
  }

  Widget _wrapMenuItemContainer({ required Widget child }) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: _menuButtonWidth,
      ),
      child: child,
    );
  }
}
