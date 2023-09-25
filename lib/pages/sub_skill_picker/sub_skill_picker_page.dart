import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/main/my_app_bar.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

class SubSkillPickerPageArgs {
}

class SubSkillPickerPage extends StatefulWidget {
  const SubSkillPickerPage({super.key});

  static const MyPageRoute<SubSkillPickerPageArgs> route = ('/SubSkillPickerPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as SubSkillPickerPageArgs?;
    return const SubSkillPickerPage();
  }

  static Future<List<SubSkill>?> go(BuildContext context) async {
    final res = await context.nav.push(
      SubSkillPickerPage.route, arguments: SubSkillPickerPageArgs(),
    );
    return res as List<SubSkill>?;
  }

  static void _popResult(BuildContext context, List<SubSkill>? subSkills) {
    context.nav.pop(subSkills);
  }

  @override
  State<SubSkillPickerPage> createState() => _SubSkillPickerPageState();
}

class _SubSkillPickerPageState extends State<SubSkillPickerPage> {
  static const _subSkillsSpacing = 12.0;

  int? _currPickIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final subSkillButtonWidth = _calcButtonWidth(size);

    return Scaffold(
      appBar: buildAppBar(
        titleText: '',
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: List.generate(MAX_SUB_SKILL_COUNT, (index) => Container(

            )),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: HORIZON_PADDING,
              ),
              children: [
                Wrap(
                  spacing: _subSkillsSpacing,
                  runSpacing: _subSkillsSpacing,
                  children: SubSkill.values.map((e) => Container(
                    constraints: BoxConstraints.tightFor(
                      width: subSkillButtonWidth,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                      ),
                      child: Text(e.name),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: Divider.createBorderSide(context),
              ),
            ),
            child: Row(
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('t_confirm'.xTr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calcButtonWidth(Size screenSize) {
    const baseWidth = 150.0;

    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;

    // mainWidth = count * realWidth + spacing * (count - 1)
    // => mainWidth =  count * (realWidth + spacing) - spacing
    // => count = (mainWidth + spacing) / (realWidth + spacing)
    final count = (mainWidth + _subSkillsSpacing) ~/ (baseWidth + _subSkillsSpacing);

    final remainWidth = mainWidth - (count * baseWidth + (count - 1) * _subSkillsSpacing);
    return baseWidth + (remainWidth / count);
  }

}
