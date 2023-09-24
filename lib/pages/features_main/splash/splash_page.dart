import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static MyPageRoute route = ('/SplashPage', (_) => const SplashPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash'),
      ),
    );
  }
}
