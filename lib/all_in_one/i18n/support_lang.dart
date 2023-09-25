import 'dart:ui';

import 'package:pokemon_sleep_tools/all_in_one/i18n/translation/zh_tw.dart';

enum SupportLang {
  enUS('en', 'US', 'en_us', getZhTwTrText),
  jaJP('ja', 'JP', 'ja_jp', getZhTwTrText),
  zhTW('zh', 'TW', 'zh_tw', getZhTwTrText);

  const SupportLang(this.languageCode, this.countryCode, this.i18nKey, this.getText);

  final String languageCode;
  final String? countryCode;

  /// For app
  final String i18nKey;

  final Map<String, String> Function() getText;

  Locale toLocale() => Locale(languageCode, countryCode);
}

const defaultSupportLang = SupportLang.enUS;

extension LocaleX on Locale {

}

extension SupportLangX on SupportLang {

}
