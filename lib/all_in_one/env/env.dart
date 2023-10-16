import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyEnv {
  MyEnv._();

  static MyEnv? _instance;
  static MyEnv get instance {
    _instance ??= MyEnv._();
    return _instance!;
  }

  // ignore_for_file: non_constant_identifier_names
  static late bool USE_DEBUG_IMAGE;

  Future<void> init() async {
    await dotenv.load(fileName: ".env");
    _load();
  }

  void _load() {
    USE_DEBUG_IMAGE = dotenv.env['USE_DEBUG_IMAGE'] == 'true';
  }

}