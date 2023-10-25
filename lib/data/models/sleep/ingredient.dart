/// 食材
///
/// 在遊戲中，官方定義為 Food
enum Ingredient {
  /// 粗枝大蔥
  i1(1, 't_food_1', 185, 7, true),
  /// 品鮮蘑菇
  i2(2, 't_food_2', 167, 7, true),
  /// 特選蛋
  i3(3, 't_food_3', 115, 5, false),
  /// 窩心洋芋
  i4(4, 't_food_4', 124, 5, true),
  /// 特選蘋果
  i5(5, 't_food_5', 90, 4, false),
  /// 火辣香草
  i6(6, 't_food_6', 130, 5, false),
  /// 豆製肉
  i7(7, 't_food_7', 103, 4, false),
  /// 哞哞鮮奶
  i8(8, 't_food_8', 98, 4, false),
  /// 甜甜蜜
  i9(9, 't_food_9', 101, 4, false),
  /// 純粹油
  i10(10, 't_food_10', 121, 5, false),
  /// 暖暖薑
  i11(11, 't_food_11', 109, 4, false),
  /// 好眠番茄
  i12(12, 't_food_12', 110, 4, false),
  /// 放鬆可可
  i13(13, 't_food_13', 151, 6, false),
  /// 美味尾巴
  i14(14, 't_food_14', 342, 4, true),
  /// 萌綠大豆
  i15(15, 't_food_15', 100, 4, false);

  const Ingredient(this.id, this.nameI18nKey, this.energy, this.dreamChips, this.disableLv1);

  final int id;

  final String nameI18nKey;

  /// 能量
  final int energy;

  final int dreamChips;

  /// 沒有任何寶可夢在一等的時候具有的食材
  final bool disableLv1;
}