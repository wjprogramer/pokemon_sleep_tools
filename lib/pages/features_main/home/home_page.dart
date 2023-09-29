import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
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
  late ThemeData _theme;
  late PageController _pageController;
  late List<_Fragment> _fragments;
  int _currPage = 0;

  @override
  void initState() {
    super.initState();
    _fragments = _initFragments();

    const initialPage = 1; // _fragments.indexOrNullWhere((element) => element is HomeFragment) ?? 0;
    _currPage = initialPage;
    _pageController = PageController(
      keepPage: true,
      initialPage: initialPage,
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
        titleBuilder: () => 'Pokemon',
        iconBuilder: (context, color) => Iconify(
          FluentMdl2.webcam_2, color: color,
        ),
      ),
      _Fragment(
        builder: (context) => const HomeFragment(),
        titleBuilder: () => 'Home',
        iconBuilder: (context, color) => Icon(Icons.home, color: color,),
      ),
      _Fragment(
        builder: (context) => const SleepFragment(),
        titleBuilder: () => 'Sleep',
        iconBuilder: (context, color) => Iconify(
          Tabler.zzz, color: color,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _fragments[_currPage].titleBuilder(),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _fragments.map((fragment) => fragment.builder(context)).toList(),
        onPageChanged: (page) {
          _currPage = page;
          setState(() { });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currPage,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: _fragments.mapIndexed((index, fragment) {
          final color = _getBottomNavIconColor(isSelected: _currPage == index);

          return BottomNavigationBarItem(
            icon: fragment.iconBuilder(context, color),
            label: fragment.titleBuilder(),
          );
        }).toList(),
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  Color _getBottomNavIconColor({ required bool isSelected }) {
    final bottomNavigationBarTheme = _theme.bottomNavigationBarTheme;
    
    final Color themeColor;
    switch (_theme.brightness) {
      case Brightness.light:
        themeColor = _theme.colorScheme.primary;
      case Brightness.dark:
        themeColor = _theme.colorScheme.secondary;
    }

    return isSelected
        ? (bottomNavigationBarTheme.selectedIconTheme?.color ?? themeColor)
        : (bottomNavigationBarTheme.unselectedIconTheme?.color ?? _theme.unselectedWidgetColor);
  }
}

class _Fragment {
  _Fragment({
    required this.builder,
    required this.titleBuilder,
    required this.iconBuilder,
  });

  final WidgetBuilder builder;
  final String Function() titleBuilder;
  final Widget Function(BuildContext, Color?) iconBuilder;
}
