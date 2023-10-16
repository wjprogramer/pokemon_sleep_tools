import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:url_launcher/url_launcher.dart';

class DataSourcesPage extends StatefulWidget {
  const DataSourcesPage._();

  static const MyPageRoute route = ('/DataSourcesPage', _builder);
  static Widget _builder(dynamic args) {
    return const DataSourcesPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DataSourcesPage> createState() => _DataSourcesPageState();
}

class _DataSourcesPageState extends State<DataSourcesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '資料來源'.xTr,
      ),
      body: buildListView(
        children: [
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              _buildListTile(
                titleText: '【攻略】使用能量計算!!更科學的『寶可夢Sleep潛力計算機v4.0』五段評價系統!!',
                url: 'https://forum.gamer.com.tw/C.php?bsn=36685&snA=913',
                subTitleText: '主要參考計算方式',
              ),
              _buildListTile(
                titleText: '資料攻略站',
                url: 'https://pks.raenonx.cc',
                subTitleText: '蒐集資料',
              ),
              _buildListTile(
                titleText: '資料攻略站 / 巴哈文章',
                url: 'https://forum.gamer.com.tw/C.php?bsn=36685&snA=130&tnum=58',
                subTitleText: '蒐集資料',
              ),
              _buildListTile(
                titleText: '【心得】活力與寶可夢EXP機制相關研究（不定期更新）',
                url: 'https://forum.gamer.com.tw/C.php?bsn=36685&snA=612',
                subTitleText: '餵食糖果給EXP下降的寶可夢得到80% 的經驗值\n餵食糖果給EXP上升的寶可夢得到120%的經驗值'
              ),
              _buildListTile(
                titleText: '【攻略】糖果計算機，自動算升級要準備幾顆糖',
                url: 'https://forum.gamer.com.tw/C.php?bsn=36685&snA=1045',
                subTitleText: '萬能糖果S = 3顆、萬能糖果M = 20顆、萬能糖果L = 100顆',
              ),
              // _buildListTile(
              //   titleText: '',
              //   url: '',
              // ),
              // _buildListTile(
              //   titleText: '',
              //   url: '',
              // ),
            ],
          ),
          Gap.xl,
          Hp(child: Text('「漂流食神」策略系列文章')),
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              _buildListTile(
                titleText: '【攻略】食材寵認知革命 - 食譜進階觀念篇',
                url: 'https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14342',
              ),
              _buildListTile(
                titleText: '【攻略】食材寵認知革命(二) - 食材寵進階觀念篇',
                url: 'https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14344',
              ),
              _buildListTile(
                titleText: '【攻略】食材寵認知革命(三) - 組隊思維進階觀念篇',
                url: 'https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14347',
              ),
              _buildListTile(
                titleText: '【攻略】平衡隊伍「漂流食神」攻略詳解',
                url: 'https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14459',
              ),
              _buildListTile(
                titleText: '【攻略】平衡隊伍「漂流食神」 - 新手版本+好友募集文',
                url: 'https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14472',
              ),
            ],
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String titleText,
    required String url,
    String? subTitleText,
  }) {
    return ListTile(
      onTap: () {
        launchUrl(Uri.parse(url));
      },
      title: Text(titleText),
      subtitle: subTitleText == null ? null
          : Text(subTitleText, maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: const Icon(
        Icons.open_in_new,
      ),
    );
  }
}


