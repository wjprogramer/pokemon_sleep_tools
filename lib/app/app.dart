import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/support_lang.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/translations.dart';
import 'package:pokemon_sleep_tools/app/app_dependencies.dart';
import 'package:pokemon_sleep_tools/app/src/app_builder.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_common/not_found_route/not_found_route_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/splash/splash_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';
import 'package:pokemon_sleep_tools/styles/styles.dart';
import 'package:pokemon_sleep_tools/view_models/food_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/view_models.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState of(BuildContext context) => context.findAncestorStateOfType<MyAppState>()!;

  static BuildContext get navContext => _navigatorKey.currentContext!;
}

final _navigatorKey = GlobalKey<NavigatorState>();

class MyAppState extends State<MyApp> {
  PokemonBasicProfileRepository get _pokemonBasicProfileRepository => getIt();
  MyLocalStorage get _localStorage => getIt();
  MyCacheManager get _cache => getIt();

  late MyRoutesMapping _routes;
  late Iterable<Locale> _locales;
  final _initRoute = SplashPage.route;
  var _initLang = SupportLang.zhTW;

  @override
  void initState() {
    super.initState();
    _routes = generateRoutes();
    _locales = SupportLang.values.map((e) => e.toLocale()).toList();

    WidgetsBinding.instance.addPostFrameCallback(_init);
  }

  Future<void> _init(Duration timeStamp) async {
    setupDependencies();
    setupI18n();
    await _initDataPersistent();
    await _initData();

    if (!kIsWeb && Platform.isWindows) {
    }

    _afterInitialized();
  }

  void _afterInitialized() {
    final navContext = _navigatorKey.currentContext!;
    navContext.nav.replaceWithoutAnimation(HomePage.route);
  }

  Future<void> _initDataPersistent() async {
    await _localStorage.init();
  }

  Future<void> _initData() async {
    await context.read<SleepFaceViewModel>().init();
    await context.read<FieldViewModel>().init();
    await context.read<FoodViewModel>().init();
  }

  void setLang(SupportLang lang) {
    // setState(() {
    //   _currLang = lang;
    // });
    Get.updateLocale(lang.toLocale());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: generateTempTheme(),
      builder: appBuilder(),
      scrollBehavior: kIsWeb ? null
          : Platform.isWindows || Platform.isMacOS ? _DesktopAppScrollBehavior()
          : null,
      // i18n
      translations: MyTranslations(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _locales,
      locale: _initLang.toLocale(),
      fallbackLocale: SupportLang.enUS.toLocale(),
      // routing
      navigatorKey: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) {
            return _routes[settings.name]?.call(settings.arguments)
                ?? NotFoundRoutePage(settings: settings,);
          },
        );
      },
      routes: {
        _initRoute.name: _initRoute.builder,
        // if (kIsWeb)
        // '/': (_) => HomePage(),
          // for (final route in _routes.entries)
          //   route.key: route.value,
      },
      initialRoute: _initRoute.name,
    );
  }
}

/// 讓桌面版可以透過滑鼠拖曳 ListView, PageView 等
class _DesktopAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
