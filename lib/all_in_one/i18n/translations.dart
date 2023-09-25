// addTranslations;
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';

void setupI18n() {
  final codeToTextList = SupportLang.values
      .map((lang) => MapEntry(lang.i18nKey, lang.getText()));

  Map<String, Map<String, String>> x = {
    for (final codeText in codeToTextList)
      codeText.key: codeText.value,
  };

  Get.addTranslations(x);

  // TODO: remove
  Get.locale = SupportLang.zhTW.toLocale();
}
