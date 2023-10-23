import 'dart:ui';

import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/translation/de_de.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/translation/en_us.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/translation/ja_jp.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/translation/ko_kr.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/translation/zh_tw.dart';

enum SupportLang {
  enUS('en', 'US', 'en_us', 'English', getEnUsTrText),
  jaJP('ja', 'JP', 'ja_jp', '日本語', getJaJpTrText),
  koKR('ko', 'KR', 'ko_kr', '한국어', getKoKrTrText),
  deDe('de', 'DE', 'de_de', 'Deutsch', getDeDeTrText),
  zhTW('zh', 'TW', 'zh_tw', '中文', getZhTwTrText);

  const SupportLang(this.languageCode, this.countryCode, this.i18nKey, this.displayName, this.getText);

  final String languageCode;
  final String? countryCode;

  /// For app
  final String i18nKey;

  final String displayName;

  final Map<String, String> Function() getText;

  Locale toLocale() => Locale(languageCode, countryCode);
}

const defaultSupportLang = SupportLang.enUS;

extension LocaleX on Locale {

}

extension SupportLangX on SupportLang {

}

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => SupportLang.values.toMap(
      (e) => e.i18nKey,
      (e) => e.getText(),
  );

}
