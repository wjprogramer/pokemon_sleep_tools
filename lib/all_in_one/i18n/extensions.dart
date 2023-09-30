import 'package:get/utils.dart';

extension StringI18nX on String {

  String get xTr => tr;

  String xTrParams([Map<String, String> params = const {}]) => trParams(params);

}