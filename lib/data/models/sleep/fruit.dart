/// 樹果
///
/// 樹果收集攸關卡比獸升級的速度，每星期卡比獸想吃的樹果都會更新，依據箱子給的提示，提供卡比獸要
/// 的樹果可以獲得2倍的能量，這樣卡比獸升級的速度就可以加快，卡比獸的等級越高就可以遇到不容易出
/// 現的寶可夢。
enum Fruit {
  f1(1, '柿仔果', 28, 120, '一般'),
  f2(2, '蘋野果', 27, 116, '火'),
  f3(3, '橙橙果', 31, 133, '水'),
  f4(4, '萄葡果', 25, 107, '電'),
  f5(5, '金枕果', 30, 129, '草'),
  f6(6, '莓莓果', 32, 137, '冰'),
  f7(7, '櫻子果', 27, 116, '格鬥'),
  f8(8, '零餘果', 32, 137, '毒'),
  f9(9, '勿花果', 29, 124, '地面'),
  f10(10, '椰木果', 24, 103, '飛行'),
  f11(11, '芒芒果', 26, 112, '超能'),
  f12(12, '木子果', 24, 103, '蟲'),
  f13(13, '文柚果', 30, 129, '岩石'),
  f14(14, '墨莓果', 26, 112, '幽靈'),
  f15(15, '番荔果', 35, 150, '龍'),
  f16(16, '異奇果', 31, 133, '惡'),
  f17(17, '靛莓果', 33, 142, '鋼'),
  f18(18, '桃桃果', 26, 112, '妖精');

  const Fruit(this.id, this.nameI18nKey, this.energyIn1, this.energyIn60, this.attr);

  /// Custom id from this app
  final int id;

  /// ex: 金枕果 (translated)
  final String nameI18nKey;

  /// 能量（初始）
  final int energyIn1;

  /// 能量
  final int energyIn60;

  /// 屬性
  final String attr;
}