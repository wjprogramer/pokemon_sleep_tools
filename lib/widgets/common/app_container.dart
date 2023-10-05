import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/view_models/view_models.dart';
import 'package:provider/provider.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel()),
        ChangeNotifierProvider(create: (_) => TeamViewModel()),
        ChangeNotifierProvider(create: (_) => SleepFaceViewModel()),
      ],
      child: child,
    );
  }
}
