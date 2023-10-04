import 'package:flutter/material.dart';

// "PokemonType": {
// "1": "一般",
// "2": "火",
// "3": "水",
// "4": "電",
// "5": "草",
// "6": "冰",
// "7": "格鬥",
// "8": "毒",
// "9": "地面",
// "10": "飛行",
// "11": "超能力",
// "12": "蟲",
// "13": "岩石",
// "14": "幽靈",
// "15": "龍",
// "16": "惡",
// "17": "鋼",
// "18": "妖精"
// }

enum PokemonType {
  t1(1, '一般', Color(0xFFC4C4C4)),
  t2(2, '火', Color(0xFFEF8D5A)),
  t3(3, '水', Color(0xFF72A5EE)),
  t4(4, '電', Color(0xFFF6DE6D)),
  t5(5, '草', Color(0xFF91CF66)),
  t6(6, '冰', Color(0xFF8DD5F8)),
  t7(7, '格鬥', Color(0xFFD9A453)),
  t8(8, '毒', Color(0xFF8766B4)),
  t9(9, '地面', Color(0xFFB6955D)),
  t10(10, '飛行', Color(0xFFBAD8FB)),
  t11(11, '超能力', Color(0xFFE4808B)),
  t12(12, '蟲', Color(0xFFC8CD67)),
  t13(13, '岩石', Color(0xFFC2BB93)),
  t14(14, '幽靈', Color(0xFF84628F)),
  t15(15, '龍', Color(0xFF6872CA)),
  t16(16, '惡', Color(0xFF686664)),
  t17(17, '鋼', Color(0xFF85B8DC)),
  t18(18, '妖精', Color(0xFFDFBEDD));

  const PokemonType(this.id, this.nameI18nKey, this.color);

  final int id;

  final String nameI18nKey;

  final Color color;

}

