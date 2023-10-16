import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/app/app.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

// TODO:
// Icons.fire_extinguisher_sharp 這個很像傷藥、道具的 icon

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MyEnv.instance.init();

  runApp(
    const AppContainer(
      child: MyApp()
    ),
  );
}
