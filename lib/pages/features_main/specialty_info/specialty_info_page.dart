import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/search_list_tile.dart';

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
              MySubHeader(
                titleText: '資料來源'.xTr,
              ),
            ],
          ),
          ...ListTile.divideTiles(
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


