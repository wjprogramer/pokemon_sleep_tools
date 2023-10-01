/// 食材
///
/// 在遊戲中，官方定義為 Food
enum Ingredient {
  i1(1, '粗枝大蔥', 185, 7),
  i2(2, '品鮮蘑菇', 167, 7),
  i3(3, '特選蛋', 115, 5),
  i4(4, '窩心洋芋', 124, 5),
  i5(5, '特選蘋果', 90, 4),
  i6(6, '火辣香草', 130, 5),
  i7(7, '豆製肉', 103, 4),
  i8(8, '哞哞鮮奶', 98, 4),
  i9(9, '甜甜蜜', 101, 4),
  i10(10, '純粹油', 121, 5),
  i11(11, '暖暖薑', 109, 4),
  i12(12, '好眠番茄', 110, 4),
  i13(13, '放鬆可可', 151, 6),
  i14(14, '美味尾巴', 342, 4),
  i15(15, '萌綠大豆', 100, 4);

  const Ingredient(this.id, this.nameI18nKey, this.energy, this.dreamChips);

  final int id;

  final String nameI18nKey;

  /// 能量
  final int energy;

  final int dreamChips;
}