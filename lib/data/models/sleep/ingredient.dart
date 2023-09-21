/// 食材
enum Ingredient {
  i1('粗枝大蔥', 185),
  i2('品鮮蘑菇', 167),
  i3('特選蛋', 115),
  i4('窩心洋芋', 124),
  i5('特選蘋果', 90),
  i6('火辣香草', 130),
  i7('豆製肉', 103),
  i8('哞哞鮮奶', 98),
  i9('甜甜蜜', 101),
  i10('純粹油', 121),
  i11('暖暖薑', 109),
  i12('好眠番茄', 110),
  i13('放鬆可可', 151),
  i14('美味尾巴', 342),
  i15('萌綠大豆', 100);

  const Ingredient(this.nameI18nKey, this.energy);

  final String nameI18nKey;

  /// 能量
  final int energy;
}