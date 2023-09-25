import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/main/gap.dart';
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
      SubSkillPickerPage.route,
      arguments: SubSkillPickerPageArgs(),
    );
    return res as List<SubSkill>?;
  }

  void _popResult(BuildContext context, List<SubSkill>? subSkills) {
    context.nav.pop(subSkills);
  }

  @override
  State<SubSkillPickerPage> createState() => _SubSkillPickerPageState();
}

class _SubSkillPickerPageState extends State<SubSkillPickerPage> {
  static const _subSkillsSpacing = 12.0;

  var _theme = ThemeData();

  int? _currPickIndex = 0;
  final List<SubSkill?> _subSkillFields = List.generate(SubSkill.maxCount, (index) => null);

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    final size = MediaQuery.of(context).size;
    final subSkillButtonWidth = _calcButtonWidth(size);

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_sub_skills'.xTr,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(),
            decoration: BoxDecoration(
              border: Border(
                bottom: Divider.createBorderSide(context),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(SubSkill.maxCount, (index) => Expanded(
                  child: _buildSubSkillField(index),
                )),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: HORIZON_PADDING,
              ),
              children: [
                Gap.sm,
                Wrap(
                  spacing: _subSkillsSpacing,
                  runSpacing: _subSkillsSpacing,
                  children: SubSkill.values.map((subSkill) => Container(
                    constraints: BoxConstraints.tightFor(
                      width: subSkillButtonWidth,
                    ),
                    child: ElevatedButton(
                      onPressed: () => _pickSubSkill(subSkill),
                      style: ElevatedButton.styleFrom(
                      ),
                      child: Text(subSkill.name),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8, horizontal: 16,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: Divider.createBorderSide(context),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('t_confirm'.xTr),
                  ),
                ],
              ),
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

  Widget _buildSubSkillField(int index) {
    final isSelected = _currPickIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currPickIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            'Lv. ${SubSkill.levelList[index]}',
            style: _theme.textTheme.bodySmall,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minHeight: 50,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? _theme.primaryColor
                    : _theme.disabledColor,
              ),
            ),
            child: Text(
              _subSkillFields[index]?.name ?? '-',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _pickSubSkill(SubSkill value) {
    final pickIndex = _currPickIndex;
    if (pickIndex == null) {
      return;
    }

    setState(() {
      _subSkillFields[pickIndex] = value;
      _currPickIndex = (pickIndex + 1) % SubSkill.maxCount;
    });
  }

  void _submit() {
    final subSkills = _subSkillFields.nonNulls;

    if (subSkills.length != SubSkill.maxCount) {
      DialogUtility.text(
        context,
        title: Text('t_failed'.xTr),
        content: Text('t_incomplete'.xTr),
      );
      return;
    }

    widget._popResult(context, subSkills.toList());
  }

}
