import 'dart:io';

import 'package:flutter/foundation.dart';

/// 在網頁環境中，直接使用 [Platform] 會出事
class MyPlatform {
  MyPlatform._();

  static bool get isWeb => kIsWeb;

  static bool get isDesktop => !kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows);
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isWindows => !kIsWeb && Platform.isWindows;

}