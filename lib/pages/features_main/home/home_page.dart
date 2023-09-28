import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/fragments/home_fragment/home_fragment.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/fragments/pokemon_box_fragment/pokemon_box_fragment.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/fragments/sleep_fragment/sleep_fragment.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static MyPageRoute route = ('/', (_) => const HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokemonProfileRepository get _pokemonProfileRepository => getIt();

  late PageController _pageController;
  late List<_Fragment> _fragments;

  @override
  void initState() {
    super.initState();
    _fragments = _initFragments();

    _pageController = PageController(
      keepPage: true,
      initialPage: _fragments.indexOrNullWhere((element) => false) ?? 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_Fragment> _initFragments() {
    return [
      _Fragment(
        builder: (context) => const PokemonBoxFragment(),
        labelTextBuilder: () => 'Pokemon',
        iconData: Icons.add,
      ),
      _Fragment(
        builder: (context) => const HomeFragment(),
        labelTextBuilder: () => 'Home',
        iconData: Icons.add,
      ),
      _Fragment(
        builder: (context) => const SleepFragment(),
        labelTextBuilder: () => 'Sleep',
        iconData: Icons.add,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: PageView(
        controller: _pageController,
        children: _fragments.map((fragment) => fragment.builder(context)).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrIndex(),
        items: _fragments.mapIndexed((index, fragment) => BottomNavigationBarItem(
          icon: Icon(fragment.iconData),
          label: fragment.labelTextBuilder(),
        )).toList(),
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() { });
        },
      ),
    );
  }

  int _getCurrIndex() {
    if (!_pageController.hasClients) {
      return 0;
    }
    return _pageController.page?.toInt() ?? 0;
  }
}

class _Fragment {
  _Fragment({
    required this.builder,
    required this.labelTextBuilder,
    required this.iconData,
  });

  final WidgetBuilder builder;
  final String Function() labelTextBuilder;
  final IconData iconData;
}
