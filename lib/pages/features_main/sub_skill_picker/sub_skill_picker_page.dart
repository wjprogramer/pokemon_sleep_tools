import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';

class SubSkillPickerPageArgs {
  SubSkillPickerPageArgs({
    this.initialValue,
  });

  final List<SubSkill>? initialValue;
}

class SubSkillPickerPage extends StatefulWidget {
  const SubSkillPickerPage({super.key, required this.args});

  static const MyPageRoute<SubSkillPickerPageArgs> route = ('/SubSkillPickerPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as SubSkillPickerPageArgs;
    return SubSkillPickerPage(args: args);
  }

  static Future<List<SubSkill>?> go(BuildContext context, {
    List<SubSkill>? initialValue,
  }) async {
    final res = await context.nav.push(
      SubSkillPickerPage.route,
      arguments: SubSkillPickerPageArgs(initialValue: initialValue),
    );
    return res as List<SubSkill>?;
  }

  void _popResult(BuildContext context, List<SubSkill>? subSkills) {
    context.nav.pop(subSkills);
  }

  final SubSkillPickerPageArgs args;

  @override
  State<SubSkillPickerPage> createState() => _SubSkillPickerPageState();
}

class _SubSkillPickerPageState extends State<SubSkillPickerPage> {
  var _theme = ThemeData();
  double _subSkillButtonWidth = 100;
  double _subSkillButtonSpacing = 0;

  var _subSkillsItems = <_SubSkillItem>[];

  int? _currPickIndex = 0;
  final List<SubSkill?> _subSkillFields = List.generate(SubSkill.maxCount, (index) => null);

  @override
  void initState() {
    super.initState();
    _initSubSkillItems();

    final initialValue = widget.args.initialValue ?? [];

    for (int i = 0; i < initialValue.length; i++) {
      _subSkillFields[i] = initialValue[i];
    }
  }

  void _initSubSkillItems() {
    final subSkills = [...SubSkill.values];

    SubSkill getSubSkill(SubSkill subSkill) {
      subSkills.remove(subSkill);
      return subSkill;
    }

    _subSkillsItems = [
      _SubSkillGroupItem(
        name: '樹果數量',
        skillS: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s1),
        ),
      ),
      _SubSkillGroupItem(
        name: '食材機率',
        skillM: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s5),
        ),
        skillS: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s6),
        ),
      ),
      _SubSkillGroupItem(
        name: '幫忙速度',
        skillM: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s3),
        ),
        skillS: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s4),
        ),
      ),
      _SubSkillGroupItem(
        name: '技能等級',
        skillM: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s7),
        ),
        skillS: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s8),
        ),
      ),
      _SubSkillGroupItem(
        name: '技能機率',
        skillM: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s9),
        ),
        skillS: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s10),
        ),
      ),
      _SubSkillGroupItem(
        name: '持有上限',
        skillL: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s11),
        ),
        skillM: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s12),
        ),
        skillS: _SubSkillValueItem(
          value: getSubSkill(SubSkill.s13),
        ),
      ),
      _SubSkillGroupItem(
        name: '其他',
        otherSubSkills: subSkills.map((subSkill) => _SubSkillValueItem(
          value: subSkill,
        )).toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    final buttonWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _subSkillButtonWidth = buttonWidthResults.childWidth;
    _subSkillButtonSpacing = buttonWidthResults.spacing;

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
                ..._subSkillsItems.map(_buildSubSkillItems).expand((e) => e),
                Gap.sm,
              ],
            ),
          ),
          BottomBarWithConfirmButton(
            submit: _submit,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubSkillItems(_SubSkillItem subSkillItem) {
    final results = <Widget>[];

    switch (subSkillItem) {
      case _SubSkillGroupItem():
        final skillS = subSkillItem.skillS;
        final skillM = subSkillItem.skillM;
        final skillL = subSkillItem.skillL;
        final otherSkills = subSkillItem.otherSubSkills;

        results.addAll([
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  constraints: const BoxConstraints.tightFor(
                    width: 100,
                  ),
                  child: Text(subSkillItem.name),
                ),
                if (skillS != null) _buildLeveledSubSkillItem(skillS.value, 'S'),
                if (skillM != null) _buildLeveledSubSkillItem(skillM.value, 'M'),
                if (skillL != null) _buildLeveledSubSkillItem(skillL.value, 'L'),
              ],
            ),
          ),
          if (otherSkills != null && otherSkills.isNotEmpty)
            Wrap(
              spacing: _subSkillButtonSpacing,
              runSpacing: _subSkillButtonSpacing,
              children: otherSkills.map((e) => e.value).map((subSkill) => Container(
                constraints: BoxConstraints.tightFor(
                  width: _subSkillButtonWidth,
                ),
                child: MyElevatedButton(
                  onPressed: () => _pickSubSkill(subSkill),
                  style: ElevatedButton.styleFrom(
                  ),
                  child: Text(subSkill.nameI18nKey),
                ),
              )).toList(),
            ),
        ]);
      case _SubSkillValueItem():
    }

    return results;
  }

  Widget _buildLeveledSubSkillItem(SubSkill subSkill, String code) {
    return InkWell(
      onTap: () => _pickSubSkill(subSkill),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Text(code),
      ),
    );
  }

  // TODO: 要在選中的技能上標注目前對應的數字 (index)
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
              color: isSelected ? _theme.primaryColorLight : null,
              border: Border.all(
                color: isSelected
                    ? _theme.primaryColor
                    : _theme.disabledColor,
              ),
            ),
            child: Text(
              _subSkillFields[index]?.nameI18nKey ?? '-',
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

sealed class _SubSkillItem {
  _SubSkillItem({
    required this.name,
  });

  final String name;
}

class _SubSkillGroupItem extends _SubSkillItem {
  _SubSkillGroupItem({
    required super.name,
    this.skillL,
    this.skillM,
    this.skillS,
    this.otherSubSkills,
  });

  List<_SubSkillValueItem> get items => [];

  _SubSkillValueItem? skillL;
  _SubSkillValueItem? skillM;
  _SubSkillValueItem? skillS;
  List<_SubSkillValueItem>? otherSubSkills;

}

class _SubSkillValueItem extends _SubSkillItem {
  _SubSkillValueItem({
    required this.value,
  }) : super(name: value.nameI18nKey);

  SubSkill value;
}