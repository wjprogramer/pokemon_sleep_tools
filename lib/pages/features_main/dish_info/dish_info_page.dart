import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dish_card.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:url_launcher/url_launcher.dart';

class DishInfoPage extends StatefulWidget {
  const DishInfoPage._();

  static const MyPageRoute route = ('/DishInfoPage', _builder);
  static Widget _builder(dynamic args) {
    return const DishInfoPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DishInfoPage> createState() => _DishInfoPageState();
}

class _DishInfoPageState extends State<DishInfoPage> {
  final _dish = Dish.d1003;

  @override
  Widget build(BuildContext context) {
    final requiredIngredients = _dish.getIngredients();

    return Scaffold(
      appBar: buildAppBar(
        titleText: '料理知識'.xTr,
      ),
      body: ListView(
        children: [
          ...Hp.list(
            children: [
              LicenseSourceCard.t1(),
              Gap.sm,
              MySubHeader(
                titleText: '懶人包'.xTr,
              ),
              Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: '用盡可能數量多的'.xTr,
                    ),
                    TextSpan(
                      text: '主要食材'.xTr,
                      style: const TextStyle(
                        color: color1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '製作料理'.xTr,
                    )
                  ],
                ),
              ),
              MySubHeader(
                titleText: '用語解釋',
              ),
              Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: '1. 主要食材：',
                      style: TextStyle(
                        color: color1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '食譜上要求的，構成主要料理的最基本食材，例如：',
                    )
                  ],
                ),
              ),
              Gap.sm,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Gap.lgV,),
                child: DishCard(
                  dish: _dish,
                  level: 1,
                ),
              ),
              Gap.md,
              Text(
                '${_dish.nameI18nKey.xTr}的主要食材有「${requiredIngredients.map((e) => e.$1.nameI18nKey.xTr).join('t_separator'.xTr)}」'
              ),
              Gap.sm,
              Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: '2. 額外食材：',
                      style: TextStyle(
                        color: color1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '在構成一道料理當中主要食材之外的食材，在玩家口中又被稱為「邊角料」',
                    )
                  ],
                ),
              ),
              MySubHeader(
                titleText: '資料來源',
              ),
            ],
          ),
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


