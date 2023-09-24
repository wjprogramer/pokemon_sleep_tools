import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
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
  late Map<String, MyRouteBuilder<Object?>> _routes;
  final _initRoute = SplashPage.route;

  @override
  void initState() {
    super.initState();
    _routes = generateRoutes();

    WidgetsBinding.instance.addPostFrameCallback(_init);
  }

  Future<void> _init(Duration timeStamp) async {
    setupDependencies();

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
