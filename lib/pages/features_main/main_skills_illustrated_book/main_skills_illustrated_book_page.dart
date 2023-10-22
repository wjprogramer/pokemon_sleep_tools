import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skill/main_skill_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class MainSkillsIllustratedBookPage extends StatefulWidget {
  const MainSkillsIllustratedBookPage._();

  static const MyPageRoute route = ('/MainSkillsIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const MainSkillsIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<MainSkillsIllustratedBookPage> createState() => _MainSkillsIllustratedBookPageState();
}

class _MainSkillsIllustratedBookPageState extends State<MainSkillsIllustratedBookPage> {

  // UI
  late ThemeData _theme;
  double _itemWidth = 200;
  static const double _itemSpacing = 12;

  // Data
  var _mainSkills = MainSkill.values;

  @override
  void initState() {
    super.initState();
    _mainSkills = _mainSkills.sorted((a, b) => a.type.compareTo(b.type));
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    final screenSize = MediaQuery.of(context).size;
    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;

    _itemWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: 200,
      containerWidth: mainWidth,
      spacing: _itemSpacing,
    );

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_main_skills'.xTr,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          MySubHeader(
            titleText: '說明'.xTr,
          ),
          ListItems(
            children: [
              Text('主技能上限為 Lv 6'),
              Text('主技能提升等級方式'),
              ListItems(
                decoration: ListItemsDecoration.number,
                children: [
                  Text('使用主技能種子升級'.xTr),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '副技能: ${[SubSkill.skillLevelS, SubSkill.skillLevelM].map((subSkill) => subSkill.nameI18nKey.xTr).join('t_separator'.xTr)}',
                        ),
                      ),
                      Tooltip(
                        message: [SubSkill.skillLevelS, SubSkill.skillLevelM].map((subSkill) => '${subSkill.nameI18nKey.xTr}: ${subSkill.intro.xTr}').join('\n'),
                        child: Icon(
                          Icons.info_outline,
                          size: 14,
                          color: greyColor3,
                        ),
                      ),
                    ],
                  ),
                  Text('使用糖果進化後，等級提升一等'.xTr),
                ],
              ),
            ],
          ),
          MySubHeader(
            titleText: '列表'.xTr,
          ),
          Gap.sm,
          Wrap(
            spacing: _itemSpacing,
            runSpacing: _itemSpacing,
            children: _wrapItems(
              children: _mainSkills.map(_buildItem).toList(),
            ),
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildItem(MainSkill mainSkill) {
    return InkWell(
      onTap: () {
        MainSkillPage.go(context, mainSkill);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: mainSkill.color.withOpacity(.1),
          border: Border.all(
            color: mainSkill.color.withOpacity(.7),
            width: 2
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              mainSkill.nameI18nKey.xTr,
              style: _theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              children: [
                const Text('\n'),
                Text(
                  mainSkill.description,
                  style: _theme.textTheme.bodySmall?.copyWith(
                    color: greyColor3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _wrapItems({ required List<Widget> children }) {
    return children
        .map((e) => _wrapItemContainer(child: e))
        .toList();
  }

  Widget _wrapItemContainer({ required Widget child }) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: _itemWidth,
      ),
      child: child,
    );
  }
}


