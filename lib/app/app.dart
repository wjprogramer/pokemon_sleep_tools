import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/support_lang.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/translations.dart';
import 'package:pokemon_sleep_tools/app/app_dependencies.dart';
import 'package:pokemon_sleep_tools/pages/features_main/home/home_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/splash/splash_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final _navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  late MyRoutesMapping _routes;
  late Iterable<Locale> _locales;
  final _initRoute = SplashPage.route;

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

    _afterInitialized();
  }

  void _afterInitialized() {
    final navContext = _navigatorKey.currentContext!;
    navContext.nav.replaceWithoutAnimation(HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // i18n
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: _locales,
      // TODO:
      locale: SupportLang.zhTW.toLocale(),
      // routing
      navigatorKey: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => _routes[settings.name]!(settings.arguments),
        );
      },
      routes: {
        _initRoute.name: _initRoute.builder,
      },
      initialRoute: _initRoute.name,
    );
  }
}
