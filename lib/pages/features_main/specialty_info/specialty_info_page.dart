import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_info/dish_info_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/search_list_tile.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';

/// [PokemonSpecialty]
class SpecialtyInfoPage extends StatefulWidget {
  const SpecialtyInfoPage._();

  static const MyPageRoute route = ('/SpecialtyInfoPage', _builder);
  static Widget _builder(dynamic args) {
    return const SpecialtyInfoPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<SpecialtyInfoPage> createState() => _SpecialtyInfoPageState();
}

class _SpecialtyInfoPageState extends State<SpecialtyInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '特長'.xTr,
      ),
      body: ListView(
        children: [
          ...Hp.list(
            children: [
              LicenseSourceCard.t1(),
              MySubHeader(
                titleText: '懶人包'.xTr,
              ),
              Gap.xl,
              Text(
                '1. 卡比獸不同偏好的料理週：\n針對不同的料理週準備不同的隊伍，盡可能做出卡比獸喜好的高階料理\n'
                    '2. 玩家鍋子的大小：\n太小的鍋子也無法製作高階料理，我們應該盡可能的蒐集更多睡姿打開圖鑑、以解鎖更大的鍋子，讓隊伍能放入更多食材寵來製作更高階料理\n'
                    '3. 料理等級：\n太低的料理等級無法提供更多加成，我們應該盡可能的針對自己隊伍擅長的料理進行常態的每日製作，迅速拉高料理等級，讓等級加成能夠更多（最高能超越兩倍！）\n'
                    '4. 食譜的食材組合：\n隊伍中放置不對的食材寵，將無法正確製作高級料理，我們應該在捕捉寶可夢時，就優先考慮他的1等/30等/60等食材，讓隊伍的配置盡可能靈活，以便應付多種料理\n'
                    '5. 食材寵的持有上限：\n'
                    '持有上限太小的食材寵將會很容易超出持有上限而無法發現食材，這是一件非常損害隊伍效率的事情，在食材寵的健檢和培養上我們會有以下兩點建議：\n'
                    '(1) 50等之前建議有一個持有上限提升S/M/L的副技能，以應付60等的食材爆炸\n'
                    '(2) 從初階寶可夢開始培養，而不要捕捉2階或是3階的，如此一來當他進化時能有額外增加5持有上限的獎勵，若為3階進化則總共可以拿到10持有上限的獎勵\n'
                    '6. 食材包包大小：\n'
                    '過小的包包將讓玩家難以預先儲存需要的食材以應付突發狀況，或是湊成高階料理，更大的食材包包有助於玩家跨週囤積食材或是應付週日的大鍋炒，因此玩家應當努力地解週任務以及遵守睡眠約定來獲得鑽石，並用鑽石來擴增食材包包的大小\n'
                    '',
              ),
              MySubHeader(
                titleText: '說明'.xTr,
              ),
              Gap.xl,
              MySubHeader2(
                titleText: '專長 & 樹果/食材產量倍數關係'.xTr,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('種類')),
                    DataColumn(label: Text('樹果產量')),
                    DataColumn(label: Text('食材產量')),
                    DataColumn(label: Text('擅長上場的時刻')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(PokemonSpecialty.t2.nameI18nKey.xTr)),
                        DataCell(Text('一倍')),
                        DataCell(
                          Text(
                            '兩倍',
                            style: TextStyle(
                              color: color1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(Text('卡比獸喜歡該食材寵能製作的料理的時候')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(PokemonSpecialty.t3.nameI18nKey.xTr)),
                        DataCell(
                          Text(
                            '兩倍',
                            style: TextStyle(
                              color: color1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(Text('一倍')),
                        DataCell(Text('卡比獸喜歡該樹果寵能提果的樹果時候')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(PokemonSpecialty.t1.nameI18nKey.xTr)),
                        DataCell(Text('一倍')),
                        DataCell(Text('一倍')),
                        DataCell(Text('通用、與某些陣容搭配的時候')),
                      ],
                    ),
                  ],
                ),
              ),
              Gap.xl,
              MySubHeader2(
                titleText: '卡比獸喜好'.xTr,
              ),
              Gap.sm,
              Text(
                '1. 樹果：如果卡比獸喜歡該樹果，樹果能量會變為兩倍',
              ),
              Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                        text: '2. 食材 & 料理：用盡可能數量多的'
                    ),
                    TextSpan(
                      text: '主要食材',
                      style: TextStyle(
                        color: color1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '製作卡比獸喜愛的料理',
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  DishInfoPage.go(context);
                },
                child: Text('料理知識'),
              ),
              MySubHeader(
                titleText: '進階說明'.xTr,
              ),
              Gap.xl,
              Text(
                '1. 「逆屬」：\n'
                    '(1) 食材寵：如果遇到了自己的食材不適合的料理週，又或是食材無法與其他食材搭配去做出高階料理，稱為逆屬\n'
                    '(2) 數果寵：如果生產的數果，卡比獸不喜歡，稱為逆屬',
              ),
              Gap.md,
              MySubHeader(
                titleText: '資料來源'.xTr,
              ),
            ],
          ),
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              SearchListTile(
                titleText: '【攻略】食材寵認知革命(二) - 食材寵進階觀念篇',
                url: 'https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14344',
              ),
            ],
          ),
          Gap.trailing,
        ],
      ),
    );
  }
}


