import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/list_tiles.dart';

class VitalityInfoPage extends StatefulWidget {
  const VitalityInfoPage._();

  static const MyPageRoute route = ('/VitalityInfoPage', _builder);
  static Widget _builder(dynamic args) {
    return const VitalityInfoPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<VitalityInfoPage> createState() => _VitalityInfoPageState();
}

class _VitalityInfoPageState extends State<VitalityInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
      body: buildListView(
        children: [
          ...Hp.list(
            children: [
              MySubHeader(
                titleText: '說明'.xTr,
              ),
              ListItems(
                children: [
                  Text('活力 100 以上，2.2 倍幫忙效率（0.45 倍的幫忙時間）'.xTr),
                  Text('活力 0，帳面上的幫忙時間就是實際幫忙時間'.xTr),
                  Text('睡眠分數 = ((睡的時間 / 510) * 100).clamp(0, 100)'.xTr),

                  // 2. 每日最多可進行2次的睡眠紀錄。遊戲以每日04:00為換日線，在此時間點之前"開始"的睡眠紀錄，都會被算在前一日的睡眠紀錄額度內 (睡眠"結束"時間不限，可超過04:00)。
                  Text(''.xTr),
                  Text(''.xTr),
                ],
              ),
              MySubHeader2(
                titleText: '減少'.xTr,
              ),
              ListItems(
                children: [
                  Text('幫手隊伍中的寶可夢會隨時間消耗活力'.xTr),
                  Text('每十分鐘減少一點'.xTr),
                  Text('睡覺時，不會減少'.xTr),
                ],
              ),
              MySubHeader2(
                titleText: '回復'.xTr,
              ),
              ListItems(
                children: [
                  Text('寶可夢主技能「活力療癒、活力填充、活力全體療癒」'.xTr),
                  Text('透過睡覺'.xTr),
                ],
              ),
              MySubHeader(
                titleText: 't_source'.xTr,
                color: dataSourceSubHeaderColor,
              ),
            ],
          ),
          const SearchListTile(
            titleText: '(日本語) げんき',
            url: 'https://wikiwiki.jp/poke_sleep/%E3%81%92%E3%82%93%E3%81%8D',
          ),
          Gap.trailing,
        ],
      ),
    );
  }
}

/*

需詢問
------

# 來源一
https://forum.gamer.com.tw/C.php?bsn=36685&snA=89

1. 需要完成至少1.5小時的睡眠紀錄，才能進行睡眠研究
  => 是代表「二睡也需要睡滿一小時半？」還是一睡加二睡要滿一小時半？
2. 1分睡眠分數 = 1%活力 + 1點EXP

# 來源二
https://www.serebii.net/pokemonsleep/sleeptracking.shtml

1. If you reach 8 and a half hours of sleep, then you will hit 100 Points.
  => 睡眠時間達 8 小時半，睡眠分數為 100

# 來源三: 活力與寶可夢EXP機制相關研究（不定期更新）(2023-08-09 12:10:29 編輯)
https://forum.gamer.com.tw/C.php?bsn=36685&snA=612

活力恢復的規則：
寶可夢睡眠恢復活力 = 基礎睡眠分數 * (100% + 增益1 + 增益2 ... + 增益N - 減益1 - 減益2 ... - 減益K )

意思是說會優先以加減法來計算所有讓睡眠經驗增加或減少的數值再與基礎睡眠分數進行運算
目前觀測到結果會無條件進位

所有會影響活力恢復的主技能、副技能、性格

活力充填S（主技能）：讓自身回復12/16/21/27/34/43點活力
活力療癒S（主技能）：隨機讓隊友寶可夢回復14/17/23/29/38/51點活力
活力全體療癒S（主技能）：讓全部隊友寶可夢回復5/79/11/15/18點活力
活力恢復獎勵（副技能）：寶可夢團隊從睡眠中恢復的能量提高12%
活力回復量（性格）：該寶可夢獲得的活力提高或降低20%

舉例：
玩家A有以下陣容
皮卡丘（無個性）
三地鼠（個性帶有活力恢復減少）
果然翁（個性帶有經驗減少）

A晚上睡了一覺，睡眠分數為83分
皮卡丘得到的睡眠經驗為83，活力恢復為83
三地鼠得到的睡眠經驗為83，活力恢復為83 * 80% = 67
果然翁得到的睡眠經驗為83 * 0.8 = 67，活力恢復為83

進階題：
玩家B有以下陣容
小火龍（個性帶有經驗減少，副技能帶有活力恢復獎勵的金技能）
地鼠（個性帶有經驗增加，副技能帶有睡眠EXP獎勵的金技能）

B晚上睡了一覺，睡眠分數為83分
小火龍得到的睡眠經驗為83 * 94% = 79，活力恢復為83 * 112% = 93
說明：所有的睡眠經驗會進行加減運算之後作用在基礎睡眠分數上：100% + 14% - 20% = 94%

地鼠得到的睡眠經驗為83 * 134% =112，活力恢復為83 * 112% = 93
說明：所有的經驗會進行加減運算之後作用在基礎睡眠分數上：100% + 20% + 14% = 134%

# 來源 自己的數據














 */


