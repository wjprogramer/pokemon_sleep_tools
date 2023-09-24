import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';

class SubSkillPickerPageArgs {
}

class SubSkillPickerPage extends StatefulWidget {
  const SubSkillPickerPage({super.key});

  static const MyPageRoute<SubSkillPickerPageArgs> route = ('/SubSkillPickerPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as SubSkillPickerPageArgs?;
    return const SubSkillPickerPage();
  }

  @override
  State<SubSkillPickerPage> createState() => _SubSkillPickerPageState();
}

class _SubSkillPickerPageState extends State<SubSkillPickerPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
