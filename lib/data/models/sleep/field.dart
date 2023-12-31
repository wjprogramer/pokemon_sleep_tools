import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 地圖 (場所)
enum PokemonField {
  f1(1, 't_field_1', [], 0, fieldColor1),
  f2(2, 't_field_2', [ Fruit.f3, Fruit.f10, Fruit.f18 ], 20, fieldColor2),
  f3(3, 't_field_3', [ Fruit.f2, Fruit.f9, Fruit.f13, ], 70, fieldColor3),
  f4(4, 't_field_4', [ Fruit.f1, Fruit.f6, Fruit.f16, ], 150, fieldColor4);
  // f6(6, 't_field_6'),
  // f7(7, 't_field_7');

  const PokemonField(this.id, this.nameI18nKey, this.fruits, this.unlockCount, this.color);

  final int id;
  final String nameI18nKey;
  final Color color;

  // region Map Meta
  final List<Fruit> fruits;
  final int unlockCount;
  // endregion
}

extension FieldX on PokemonField {
  List<SnorlaxReward> getSnorlaxRewardList() {
    return switch (this) {
      PokemonField.f1 => [
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 1), 0, 0),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 2), 117, 3118),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 3), 151, 7171),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 4), 169, 11693),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 5), 204, 17149),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 1), 233, 23385),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 2), 303, 31492),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 3), 367, 41314),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 4), 437, 53006),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 5), 472, 65634),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 1), 507, 79197),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 2), 536, 93540),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 3), 583, 109130),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 4), 641, 125032),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 5), 705, 156121),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 1), 775, 187832),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 2), 853, 220177),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 3), 938, 253169),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 4), 1032, 286821),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 5), 1135, 321146),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 6), 1249, 356158),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 7), 1374, 391870),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 8), 1511, 428296),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 9), 1662, 465451),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 10), 1828, 532707),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 11), 2011, 601308),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 12), 2212, 742056),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 13), 2433, 885619),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 14), 2677, 1029700),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 15), 2944, 1199506),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 16), 3239, 1486800),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 17), 3563, 1795052),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 18), 3919, 2165541),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 19), 4311, 2604280),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 20), 7202, 3245795),
      ],
      PokemonField.f2 => [
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 1), 0, 0),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 2), 117, 4822),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 3), 151, 11090),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 4), 169, 18082),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 5), 204, 26520),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 1), 233, 36164),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 2), 303, 48700),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 3), 367, 63889),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 4), 437, 81971),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 5), 472, 101499),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 1), 507, 122474),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 2), 536, 144654),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 3), 583, 168763),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 4), 641, 195283),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 5), 705, 224455),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 1), 775, 256544),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 2), 853, 291842),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 3), 938, 330670),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 4), 1032, 373381),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 5), 1135, 420363),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 6), 1249, 472043),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 7), 1374, 528891),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 8), 1511, 591424),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 9), 1662, 660210),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 10), 1828, 735875),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 11), 2011, 819107),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 12), 2212, 910662),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 13), 2433, 1018462),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 14), 2677, 1184155),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 15), 2944, 1379432),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 16), 3239, 1709820),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 17), 3563, 2064310),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 18), 3919, 2490372),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 19), 4311, 2994922),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 20), 7202, 3732664),
      ],
      PokemonField.f3 => [
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 1), 0, 0),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 2), 117, 6885),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 3), 151, 15835),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 4), 169, 25817),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 5), 204, 37865),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 1), 233, 51635),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 2), 303, 69534),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 3), 367, 91221),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 4), 437, 117038),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 5), 472, 144921),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 1), 507, 174869),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 2), 536, 206538),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 3), 583, 240961),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 4), 641, 278826),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 5), 705, 320478),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 1), 775, 366295),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 2), 853, 416694),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 3), 938, 472133),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 4), 1032, 533116),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 5), 1135, 600197),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 6), 1249, 673986),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 7), 1374, 755154),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 8), 1511, 844439),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 9), 1662, 942653),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 10), 1828, 1050688),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 11), 2011, 1169527),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 12), 2212, 1300250),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 13), 2433, 1444045),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 14), 2677, 1602220),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 15), 2944, 1776213),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 16), 3239, 1967605),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 17), 3563, 2333568),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 18), 3919, 2815203),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 19), 4311, 3385564),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 20), 7202, 4219534),
      ],
      PokemonField.f4 => [
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 1), 0, 0),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 2), 117, 10486),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 3), 151, 24118),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 4), 169, 39323),
        SnorlaxReward(const SnorlaxRank(RankTitle.t1, 5), 204, 57673),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 1), 233, 78645),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 2), 303, 105909),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 3), 367, 138940),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 4), 437, 178262),
        SnorlaxReward(const SnorlaxRank(RankTitle.t2, 5), 472, 220730),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 1), 507, 266344),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 2), 536, 314580),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 3), 583, 367010),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 4), 641, 424683),
        SnorlaxReward(const SnorlaxRank(RankTitle.t3, 5), 705, 488123),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 1), 775, 557907),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 2), 853, 634669),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 3), 938, 719107),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 4), 1032, 811989),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 5), 1135, 914159),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 6), 1249, 1026546),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 7), 1374, 1150172),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 8), 1511, 1286161),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 9), 1662, 1435749),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 10), 1828, 1600296),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 11), 2011, 1781298),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 12), 2212, 1980400),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 13), 2433, 2199412),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 14), 2677, 2440325),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 15), 2944, 2705329),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 16), 3239, 2996833),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 17), 3563, 3317487),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 18), 3919, 3670206),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 19), 4311, 4058197),
        SnorlaxReward(const SnorlaxRank(RankTitle.t4, 20), 7202, 4706403),
      ],
    };
  }
}

// "1": "萌綠之島",
// "2": "天青沙灘",
// "3": "灰褐洞窟",
// "4": "白花雪原",
// "6": "脂紅火山",
// "7": "寶藍湖畔",

// "2": {
//     "mapId": 2,
//     "berry": [
//         3,
//         10,
//         18
//     ],
//     "unlock": {
//         "type": "sleepStyle",
//         "count": 20
//     }
// },
