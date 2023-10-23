import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/app/app.dart';

class AppI18nManager {
  AppI18nManager._();

  static void changeLang(SupportLang lang) {
    MyApp.of(MyApp.navContext).setLang(lang);
  }

}