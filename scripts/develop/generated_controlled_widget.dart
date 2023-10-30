import 'dart:io';
import 'package:path/path.dart' as path;

// ignore_for_file: avoid_print

Directory current = Directory.current;
late String outputDirectory;

const viewTemplate = r'''
part of '$SNAKE_NAME$_page.dart';

class _$NAME$View extends WidgetView<$NAME$Page, _$NAME$Logic> {
  const _$NAME$View(_$NAME$Logic state) : super(state);

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
''';

const logicTemplate = r'''
part of '$SNAKE_NAME$_page.dart';

class _$NAME$Logic extends State<$NAME$Page> {
  var _theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return _$NAME$View(this);
  }
}
''';

const widgetTemplate = r'''
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

part '$SNAKE_NAME$_logic.dart';
part '$SNAKE_NAME$_view.dart';

class $NAME$Page extends StatefulWidget {
  const $NAME$Page._();
  
  static const MyPageRoute route = ('/$NAME$Page', _builder);
  static Widget _builder(dynamic args) {
    return const $NAME$Page._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<$NAME$Page> createState() => _$NAME$Logic();
}
''';

String convertToSnakeNaming(String name) {
  final beforeCapitalLetter = RegExp(r"(?=[A-Z])");
  var parts = name.split(beforeCapitalLetter);
  return parts.join('_');
}

String generateContent(String name, String snakeName, String template) {
  return template
      .replaceAll(r'$NAME$', name)
      .replaceAll(r'$SNAKE_NAME$', snakeName);
}

main(args) {
  if (args.isEmpty) {
    print('# 指令格式為 dart .../....dart <feature_name> <名稱>');
    return;
  }

  final featureName = args[0] as String;
  final name = args[1] as String;

  // feature
  outputDirectory = path.join(current.path, 'lib', 'pages', 'features_$featureName');

  // check page name
  final uppercaseRegex = RegExp('[A-Z]');
  if (!uppercaseRegex.hasMatch(name[0])) {
    print('請以大寫為開頭');
    return;
  }

  final snakeName = convertToSnakeNaming(name).toLowerCase();

  final widgetFile = File('$outputDirectory\\$snakeName\\${snakeName}_page.dart');
  final viewFile = File('$outputDirectory\\$snakeName\\${snakeName}_view.dart');
  final logicFile =
  File('$outputDirectory\\$snakeName\\${snakeName}_logic.dart');

  var widgetContent = generateContent(name, snakeName, widgetTemplate);
  var viewContent = generateContent(name, snakeName, viewTemplate);
  var logicContent = generateContent(name, snakeName, logicTemplate);

  widgetFile.createSync(recursive: true);
  viewFile.createSync(recursive: true);
  logicFile.createSync(recursive: true);

  widgetFile.writeAsStringSync(widgetContent);
  viewFile.writeAsStringSync(viewContent);
  logicFile.writeAsStringSync(logicContent);
}
