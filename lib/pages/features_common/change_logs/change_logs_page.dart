import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/bag/bag_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruits_energy/fruits_energy_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient_list_rarity/ingredient_list_rarity_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skills_with_pokemon_list/main_skills_with_pokemon_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/map/map_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_evolution_illustrated_book/pokemon_evolution_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_illustrated_book/pokemon_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sleep_faces_illustrated_book/sleep_faces_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeLogsPage extends StatefulWidget {
  const ChangeLogsPage._();

  static const MyPageRoute route = ('/ChangeLogsPage', _builder);
  static Widget _builder(dynamic args) {
    return const ChangeLogsPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<ChangeLogsPage> createState() => _ChangeLogsPageState();
}

class _ChangeLogsPageState extends State<ChangeLogsPage> {

  // UI
  late ThemeData _theme;

  // Data
  late List<_Version> _versions;
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _versions = [
      _Version(
        name: '1.0.6',
        date: DateTime(2023, 10, 27),
        description: null,
        items: [
          _NormalVersionItem('[Feature] 建立寶可夢時，可以篩選'),
          _NormalVersionItem('[Feature] 寶可夢可自訂登陸日期'),
          _NormalVersionItem('[Feature] 全面採用新方法計算，參考來源: ', onTap: () {
            launchUrl(Uri.parse('https://bbs.nga.cn/read.php?tid=37305277&rand=768'));
          }),
          _NormalVersionItem('[INFO] 新增詛咒娃娃、怨影娃娃、皮卡丘(萬聖節)'),
        ],
      ),
      _Version(
        name: '1.0.5',
        date: DateTime(2023, 10, 24),
        description: null,
        items: [
          _VersionSubTitleItem('一般'),
          _NormalVersionItem('[INFO] 修正主技能資訊'),
          _NormalVersionItem('[WIP/Feature] 開始進行多國化作業', onTap: () {
            ChangeLogsPage.go(context);
          }),
          _NormalVersionItem('[INFO] 新增食材稀有度頁面', onTap: () {
            IngredientListRarityPage.go(context);
          }),
          _NormalVersionItem('[INFO] 新增主技能與寶可夢列表頁面', onTap: () {
            MainSkillsWithPokemonListPage.go(context);
          }),
          _NormalVersionItem('[Bug] 寶可夢圖鑑內可以正常搜尋了', onTap: () {
            PokemonIllustratedBookPage.go(context);
          }),
          _VersionSubTitleItem('寶可夢盒'),
          _NormalVersionItem('[Feature] 寶可夢可以新增自訂筆記'),
          _NormalVersionItem('[Feature] 寶可夢可以收藏、變更為異色（顯示上也會調整）'),
          _NormalVersionItem('[Feature] 可以用島嶼、目前/最終進化階段搜尋，關鍵字也可以搜尋自訂筆記、自訂名稱 (不分大小寫)'),
        ],
      ),
      _Version(
        name: '1.0.4',
        date: DateTime(2023, 10, 22),
        description: null,
        items: [
          _NormalVersionItem('[Feature] 可設定各島營地獎勵 (但目前還不會參與計算)'),
          _NormalVersionItem('[Change] 寶可夢隊伍: 編輯時，可以刪除已加入隊伍的寶可夢、可以新增完全空的隊伍'),
          _NormalVersionItem('[UI] 改善睡姿圖鑑畫面，顯示寶可夢圖鑑、照睡眠類型區分', onTap: () {
            SleepFacesIllustratedBookPage.go(context);
          }),
          _NormalVersionItem('[UI/INFO] 樹果頁面: 增加寶可夢圖片、新增屬性資訊、新增適合島嶼'),
          _NormalVersionItem('[Feature/Info] 增加所有樹果能量列表', onTap: () {
            FruitsEnergyPage.go(context);
          }),
          _NormalVersionItem('[UX] 寶可夢搜尋對話框的關鍵字欄位可以清除'),
          _NormalVersionItem('[Feature] 圖鑑可以反查寶可夢盒'),
          _NormalVersionItem('[Info] 顯示詳細計算過程'),
        ],
      ),
      _Version(
        name: '1.0.3',
        date: DateTime(2023, 10, 21),
        description: '',
        items: [
          _NormalVersionItem('[FatalBug/Windows] 修正無法匯出'),
          _NormalVersionItem('[UI/UX] 根據「積極、中立、消極」區分性格類別(ChatGPT 初步區分和個人主觀區分)、改善性格和性格選擇畫面'),
          _NormalVersionItem('[UI/UX] 改善地圖與睡姿畫面', onTap: () {
            MapPage.go(context, PokemonField.f1);
          }),
        ],
      ),
      _Version(
        name: '1.0.2',
        date: DateTime(2023, 10, 20),
        description: '修正錯誤',
        items: [
          _NormalVersionItem('[Bug] 主技能等級加太多，導致溢出'),
        ],
      ),
      _Version(
        name: '1.0.1',
        date: DateTime(2023, 10, 20),
        description: '更新畫面',
        items: [
          _VersionSubTitleItem('主要內容'),
          _NormalVersionItem(
            '[Feature] 寶可夢進化圖鑑',
            onTap: () {
              PokemonEvolutionIllustratedBookPage.go(context);
            },
          ),
          _NormalVersionItem(
            '[UI] 改善背包進化道具畫面樣式',
            onTap: () {
              BagPage.go(context);
            },
          ),
          _NormalVersionItem('[Feature] 寶可夢可自訂名稱'),
          _NormalVersionItem('[FatalBug] 沒辦法更新既有寶可夢資訊'),
          _NormalVersionItem('[Bug] 修正新增後，返回不會馬上出現'),
          _NormalVersionItem('[UX] 建立寶可夢，可選擇繼續建立，或返回'),
          _NormalVersionItem('[WIP] 單一寶可夢的分析資料驗算'),
          _NormalVersionItem('[UI] 數果列表頁面更新'),
          _VersionSubTitleItem('細節'),
          _NormalVersionItem('[UI] 其他細微樣式改變不列（背景色等微調）'),
          _NormalVersionItem('[INFO] 新增一些資訊（副技能、專長技能型補充）'),
        ],
      ),
      _Version(
        name: '1.0.0',
        date: DateTime(2023, 10, 19),
        description: '第一次上版',
        items: [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    final responsive = ResponsiveBreakpoints.of(context);
    _isMobile = responsive.isMobile;

    return Scaffold(
      appBar: buildAppBar(
        titleText: '更新紀錄'.xTr,
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.hV,
        ),
        children: [
          ..._buildListItems(),
          Gap.trailing,
        ],
      ),
    );
  }

  List<Widget> _buildListItems() {
    return [
      ..._versions.mapIndexed((versionIndex, e) =>
          _buildVersion(e, isFirst: versionIndex == 0)).expand((e) => e),
      Gap.trailing,
    ];
  }

  List<Widget> _buildVersion(_Version version, {
    bool isFirst = false,
  }) {
    final versionWidget = Row(
      children: [
        const Iconify(
          Fa6Solid.tag,
          color: gitColor,
          size: 12,
        ),
        Gap.sm,
        Text(
          version.name,
          style: _theme.textTheme.bodySmall?.copyWith(
            color: greyColor3,
          ),
        ),
      ],
    );

    final content = Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: _theme.dividerColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Gap.smV,
        vertical: Gap.mdV,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildVersionHeader(
                  version, isFirst: isFirst,
                ),
              ),
            ],
          ),
          if (version.description != null)
            Text(version.description!),
          if (version.items.isNotEmpty)
            Gap.md,
          ...version.items
              .map((e) => _buildVersionItem(e)),
        ],
      ),
    );

    if (!_isMobile) {
      return [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.md,
                Text(Display.date(version.date)),
                versionWidget,
              ],
            ),
            Gap.xl,
            Expanded(child: content),
          ],
        ),
      ];
    }

    return [
      Gap.sm,
      Text(
        Display.date(version.date),
        style: _theme.textTheme.bodyMedium,
      ),
      Gap.xs,
      versionWidget,
      Gap.xs,
      content,
    ];
  }

  Widget _buildVersionItem(_VersionItem item) {
    switch (item) {
      case _NormalVersionItem():
        return _buildNormalVersionItem(item);
      case _VersionSubTitleItem():
        return _buildVersionSubTitleItem(item);
    }
  }

  Widget _buildNormalVersionItem(_NormalVersionItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('・', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: item.description,
              children: [
                if (item.onTap != null) ...[
                  TextSpan(
                    text: ' Go ',
                    style: TextStyle(
                      color: positiveColor,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = item.onTap,
                  ),
                  // placeholder: 避免前者的 recognizer 導致剩餘的 space 也會觸發 onTap
                  TextSpan(
                    text: ' ',
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionSubTitleItem(_VersionSubTitleItem titleItem) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Text(
        titleItem.text,
        style: _theme.textTheme.titleMedium,
      ),
    );
  }

  Widget _buildVersionHeader(_Version version, {
    bool isFirst = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          text: version.name,
          children: [
            if (isFirst)
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _latestLabel(),
                ),
              ),
          ],
        ),
        style: _theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _latestLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: greenColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Latest',
        style: _theme.textTheme.bodySmall?.copyWith(
          color: greenColor,
        ),
      ),
    );
  }

}

class _Version {
  _Version({
    required this.name,
    this.description,
    required this.items,
    required this.date,
  });

  final String name;
  final String? description;
  final List<_VersionItem> items;
  final DateTime date;

}

sealed class _VersionItem {}

class _NormalVersionItem extends _VersionItem {
  _NormalVersionItem(this.description, {
    this.onTap,
  });

  final String description;
  final VoidCallback? onTap;
}

class _VersionSubTitleItem extends _VersionItem {
  _VersionSubTitleItem(this.text);

  final String text;
}



