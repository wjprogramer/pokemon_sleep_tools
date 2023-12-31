import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// 說明
/// - 副技能種子是從已開放的技能（等級提升後開放）中隨機挑一個提升
///
/// TODO:
///   可以修改分區標準
///   1. 使用 [SubSkill.rarity]，例如稀有度高的為一區
///   2. 使用種類，例如：持有上限L、M、S 可以分在一區
class SubSkillsCharacterIllustratedBookPage extends StatefulWidget {
  const SubSkillsCharacterIllustratedBookPage._();

  static const MyPageRoute route = ('/SubSkillsCharacterIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const SubSkillsCharacterIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<SubSkillsCharacterIllustratedBookPage> createState() => _SubSkillsCharacterIllustratedBookPageState();
}

class _SubSkillsCharacterIllustratedBookPageState extends State<SubSkillsCharacterIllustratedBookPage> {

  // UI
  late ThemeData _theme;
  double _itemWidth = 200;
  static const double _itemSpacing = 12;

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
        titleText: 't_sub_skills'.xTr,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          Gap.sm,
          MySubHeader(titleText: '說明'.xTr,),
          ListItems(
            children: [
              // ref: https://forum.gamer.com.tw/Co.php?bsn=36685&sn=6715
              Text('副技能可以升級'.xTr),
              Text('最高級別的副技能只能同時有一個'.xTr),
            ],
          ),
          MySubHeader(titleText: '列表',),
          Wrap(
            spacing: _itemSpacing,
            runSpacing: _itemSpacing,
            children: _wrapItems(
              children: SubSkill.values.map(_buildItem).toList(),
            ),
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildItem(SubSkill subSkill) {
    return InkWell(
      onTap: () {
        // TODO: 查詢寶可夢盒裡的寶可夢是否有該副技能
        // .go(context, mainSkill);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: subSkill.bgColor,
            width: 2,
          ),
          color: subSkill.bgColor.withOpacity(.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              subSkill.nameI18nKey.xTr,
              style: _theme.textTheme.bodyLarge,
            ),
            Stack(
              children: [
                Text('\n', style: _theme.textTheme.bodySmall),
                Text(
                  subSkill.intro,
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


