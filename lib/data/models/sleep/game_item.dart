// "1": "專注薰香",
// "2": "幸運薰香",
// "3": "成長薰香",
// "4": "回復薰香",
// "5": "活力枕頭",
// "6": "幫手哨子",
// "7": "營地移動券",
// "8": "好露營券",
// "9": "寶可沙布蕾",
// "10": "超級沙布蕾",
// "11": "大師沙布蕾",
// "12": "萬能糖果S",
// "13": "萬能糖果M",
// "14": "萬能糖果L",
// "15": "食材券S",
// "16": "食材券M",
// "17": "食材券L",
// "18": "夢之塊S",
// "19": "夢之塊M",
// "20": "夢之塊L",
// "21": "聯繫繩",
// "22": "火之石",
// "23": "水之石",
// "24": "雷之石",
// "25": "葉之石",
// "26": "冰之石",
// "27": "月之石",
// "28": "光之石",
// "29": "金屬膜",
// "30": "渾圓之石",
// "31": "王者之證",
// "32": "主技能種子",
// "33": "副技能種子",
// "34": "友好薰香"

enum GameItem {
  i1(1, '專注薰香'),
  i2(2, '幸運薰香'),
  i3(3, '成長薰香'),
  i4(4, '回復薰香'),
  i5(5, '活力枕頭'),
  i6(6, '幫手哨子'),
  i7(7, '營地移動券'),
  i8(8, '好露營券'),
  i9(9, '寶可沙布蕾'),
  i10(10, '超級沙布蕾'),
  i11(11, '大師沙布蕾'),
  i12(12, '萬能糖果S'),
  i13(13, '萬能糖果M'),
  i14(14, '萬能糖果L'),
  i15(15, '食材券S'),
  i16(16, '食材券M'),
  i17(17, '食材券L'),
  i18(18, '夢之塊S'),
  i19(19, '夢之塊M'),
  i20(20, '夢之塊L'),
  i21(21, '聯繫繩'),
  i22(22, '火之石'),
  i23(23, '水之石'),
  i24(24, '雷之石'),
  i25(25, '葉之石'),
  i26(26, '冰之石'),
  i27(27, '月之石'),
  i28(28, '光之石'),
  i29(29, '金屬膜'),
  i30(30, '渾圓之石'),
  i31(31, '王者之證'),
  i32(32, '主技能種子'),
  i33(33, '副技能種子'),
  i34(34, '友好薰香');

  const GameItem(this.id, this.nameI18nKey);

  final int id;
  final String nameI18nKey;
}
