import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Map<String, MyRouteBuilder> _routes;

  @override
  void initState() {
    super.initState();
    _routes = generateRoutes();
  }

  @override
  Widget build(BuildContext context) {
    // Navigator.of(context).pushNamed(routeName);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => _routes[settings.name]!(settings.arguments),
        );
      },
      initialRoute: '/',
    );
  }
}
