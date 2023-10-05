import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

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

  Widget _buildItem(SubSkill mainSkill) {
    return InkWell(
      onTap: () {
        // TODO: 查詢寶可夢盒裡的寶可夢是否有該副技能
        // .go(context, mainSkill);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              mainSkill.nameI18nKey.xTr,
              style: _theme.textTheme.bodyLarge,
            ),
            Text(
              mainSkill.intro,
              style: _theme.textTheme.bodySmall?.copyWith(
                color: greyColor3,
              ),
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


