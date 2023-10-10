import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/app/app.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

// TODO:
// Icons.fire_extinguisher_sharp 這個很像傷藥、道具的 icon

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const AppContainer(
      child: MyApp()
    ),
  );
}
