
class PokemonType {
  PokemonType({
    required this.id,
    required this.nameI18nKey,
  });

  /// Custom id from this app
  final int id;

  /// ex: 惡、一般
  final String nameI18nKey;
}

class PokemonBasicProfile {
  PokemonBasicProfile({
    required this.id,
    required this.boxNo,
    required this.nameI18nKey,
    this.customName,
    this.subnameI18nKey,
    this.styles,
    this.types = const [],
    this.assetPath,
    this.evolutionId,
    required this.helpInterval,
    required this.fruit,
    required this.sleepType,
    required this.mainSkill,
  });

  /// Custom id from this app
  final int id;

  /// 圖鑑編號, ex: 20
  final int boxNo;

  /// ex: 拉達
  final String nameI18nKey;

  /// ex: 拉達, 勞贖
  final String? customName;

  /// ex: 阿羅拉的樣子
  final String? subnameI18nKey;

  /// [PokemonBasicProfile.id], include self id
  /// ex: [拉達, 拉達（阿羅拉的樣子）]
  final List<int>? styles;

  /// [PokemonType.id]
  final List<int> types;

  /// ...?
  final String? assetPath;

  /// [PokemonEvolution.id]
  final int? evolutionId;

  /// Pokemon Sleep, 最終幫忙間隔(秒)
  final int helpInterval;

  /// Pokemon Sleep, 樹果
  final Fruit fruit;

  /// Pokemon Sleep, type
  final PokemonSleepType sleepType;

  /// Pokemon Sleep, 主技能
  final MainSkill mainSkill;
}

class PokemonProfile {
  PokemonProfile({
    required this.basicProfile,
    required this.character,
    required this.subSkillLv10,
    required this.subSkillLv25,
    required this.subSkillLv50,
    required this.subSkillLv75,
    required this.subSkillLv100,
    required this.ingredient1,
    required this.ingredientCount1,
    required this.ingredient2,
    required this.ingredientCount2,
    required this.ingredient3,
    required this.ingredientCount3,
  });

  final PokemonBasicProfile basicProfile;
  final PokemonCharacter character;

  final SubSkill subSkillLv10;
  final SubSkill subSkillLv25;
  final SubSkill subSkillLv50;
  final SubSkill subSkillLv75;
  final SubSkill subSkillLv100;

  final Ingredient ingredient1;
  final int ingredientCount1;
  final Ingredient ingredient2;
  final int ingredientCount2;
  final Ingredient ingredient3;
  final int ingredientCount3;

  String info() {
    var result = '性格: ${character.name}\n'
        '副技能:\n'
        '    Lv 10: ${subSkillLv10.name}\n'
        '    Lv 25: ${subSkillLv25.name}\n'
        '    Lv 50: ${subSkillLv50.name}\n'
        '    Lv 75: ${subSkillLv75.name}\n'
        '    Lv 100: ${subSkillLv100.name} \n'
        '食材:\n'
        '    ${ingredient1.nameI18nKey} (${ingredientCount1})\n'
        '    ${ingredient2.nameI18nKey} (${ingredientCount2})\n'
        '    ${ingredient3.nameI18nKey} (${ingredientCount3})\n'
        '幫忙均能: TBD\n'
        '類型: ${basicProfile.sleepType.name} (${basicProfile.fruit.nameI18nKey})';


    return result;
  }
}

class PokemonEvolution {
  PokemonEvolution({
    required this.id,
    required this.pokemonIdList,
  });

  /// Custom id from this app
  final int id;

  /// [PokemonBasicProfile.id] list
  final List<int> pokemonIdList;
}

/// 樹果
enum Fruit {
  f1(1, '柿仔果', 120, '一般'),
  f2(2, '蘋野果', 116, '火'),
  f3(3, '橙橙果', 133, '水'),
  f4(4, '萄葡果', 107, '電'),
  f5(5, '金枕果', 129, '草'),
  f6(6, '莓莓果', 137, '冰'),
  f7(7, '櫻子果', 116, '格鬥'),
  f8(8, '零餘果', 137, '毒'),
  f9(9, '勿花果', 124, '地面'),
  f10(10, '椰木果', 103, '飛行'),
  f11(11, '芒芒果', 112, '超能'),
  f12(12, '木子果', 103, '蟲'),
  f13(13, '文柚果', 129, '岩石'),
  f14(14, '墨莓果', 112, '幽靈'),
  f15(15, '番荔果', 150, '龍'),
  f16(16, '異奇果', 133, '惡'),
  f17(17, '靛莓果', 142, '鋼'),
  f18(18, '桃桃果', 112, '妖精');

  const Fruit(this.id, this.nameI18nKey, this.energyIn60, this.attr);

  /// Custom id from this app
  final int id;

  /// ex: 金枕果 (translated)
  final String nameI18nKey;

  /// 能量
  final int energyIn60;

  /// 屬性
  final String attr;
}

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

enum MainSkill {
  m1(1, '能量填充S', '使卡比獸的能量增加400'),
  m2(2, '能量填充M', '使卡比獸的能量增加880'),
  m3(3, '夢之碎片獲取S', '獲得88個夢之碎片'),
  m4(4, '活力療癒S', '隨機讓1隻自己以外的寶可夢回復活力14點'),
  m5(5, '能量填充Sn', '使卡比獸的能量增加200 到 800'),
  m6(6, '夢之碎片獲取Sn', '獲得 44 到 176 個夢想碎片'),
  m7(7, '活力填充S', '讓自己恢復12點活力'),
  m8(8, '活力全體療癒S', '讓幫手隊伍的寶可夢回復活力5點'),
  m9(9, '幫手支援S', '幫手寶可夢中的某1隻會立刻完成 4 次幫忙'),
  m10(10, '食材獲取S', '隨機獲得食材6個'),
  m11(11, '料理強化S', '增加下一次料理時的鍋子容量，讓鍋子能多放7個食材'),
  m12(12, '揮指', '從全部的主技能中隨機發動1種');

  const MainSkill(this.id, this.name, this.subName);

  final int id;
  final String name;
  final String subName;
}

extension MainSkillX on MainSkill {
  List<double> get values {
    switch (this) {
      case MainSkill.m1: return [400, 569, 785, 1083, 1496, 2066, ];
      case MainSkill.m2: return [880, 1251, 1726, 2383, 3290, 4546, ];
      case MainSkill.m3: return [88, 125, 173, 274, 395, 568, ];
      case MainSkill.m4: return [14, 17, 23, 29, 38, 51, ];
      case MainSkill.m5: return [500, 711.5, 981.5, 1354, 1870, 2582.5, ];
      case MainSkill.m6: return [110, 156.5, 216.5, 342.5, 494, 710, ];
      case MainSkill.m7: return [12, 16, 21, 27, 34, 43, ];
      case MainSkill.m8: return [5, 7, 9, 11, 15, 18, ];
      case MainSkill.m9: return [4, 5, 6, 7, 8, 9, ];
      case MainSkill.m10: return [6, 8, 11, 14, 17, 21, ];
      case MainSkill.m11: return [7, 10, 12, 17, 22, 27, ];
      case MainSkill.m12: return [0, 0, 0, 0, 0, 0, ];
    }
  }
}

enum PokemonSleepType {
  t1(1, '技能型'),
  t2(2, '食材型'),
  t3(3, '樹果型');

  const PokemonSleepType(this.id, this.name);

  final int id;

  final String name;
}

/// 性格
enum PokemonCharacter {
  c1(1, '怕寂寞', '幫忙速度', '活力回復'),
  c2(2, '固執', '幫忙速度', '食材發現'),
  c3(3, '頑皮', '幫忙速度', '主技能'),
  c4(4, '勇敢', '幫忙速度', 'EXP'),
  c5(5, '大膽', '活力回復', '幫忙速度'),
  c6(6, '淘氣', '活力回復', '食材發現'),
  c7(7, '樂天', '活力回復', '主技能'),
  c8(8, '悠閒', '活力回復', 'EXP'),
  c9(9, '內斂', '食材發現', '幫忙速度'),
  c10(10, '慢吞吞', '食材發現', '活力回復'),
  c11(11, '馬虎', '食材發現', '主技能'),
  c12(12, '冷靜', '食材發現', 'EXP'),
  c13(13, '溫和', '主技能', '幫忙速度'),
  c14(14, '溫順', '主技能', '活力回復'),
  c15(15, '慎重', '主技能', '食材發現'),
  c16(16, '自大', '主技能', 'EXP'),
  c17(17, '膽小', 'EXP', '幫忙速度'),
  c18(18, '急躁', 'EXP', '活力回復'),
  c19(19, '爽朗', 'EXP', '食材發現'),
  c20(20, '天真', 'EXP', '主技能'),
  c21(21, '害羞', null, null),
  c22(22, '勤奮', null, null),
  c23(23, '坦率', null, null),
  c24(24, '浮躁', null, null),
  c25(25, '認真', null, null);

  const PokemonCharacter(this.id, this.name, this.positive, this.negative);

  final int id;
  final String name;
  final String? positive;
  final String? negative;
}

enum SubSkill {
  s1(1, '樹果s', '一次撿來的樹果數量會增加1個'),
  s2(2, '幫手獎勵', '全隊成員的幫忙間隔都會縮短5%'),
  s3(3, '幫忙速度M', '幫忙間隔會縮短14%'),
  s4(4, '幫忙速度S', '幫忙間隔會縮短7%'),
  s5(5, '食材機率M', '帶回食材的機率會提升36%'),
  s6(6, '食材機率S', '帶回食材的機率會提升18%'),
  s7(7, '技能等級M', '主技能等級會提升2'),
  s8(8, '技能等級S', '主技能等級會提升1'),
  s9(9, '技能機率M', '發動主技能的機率會提升36%'),
  s10(10, '技能機率S', '發動主技能的機率會提升18%'),
  s11(11, '持有上限L', '樹果、食材的持有上限會增加18個'),
  s12(12, '持有上限M', '樹果、食材的持有上限會增加12個'),
  s13(13, '持有上限S', '樹果、食材的持有上限會增加6個'),
  s14(14, '活力回復獎勵', '全隊成員透過睡眠回復的活力都會變成1.12倍'),
  s15(15, '睡眠EXP獎勵', '全隊成員透過睡眠獲得的EXP都會增加14%'),
  s16(16, '研究EXP獎勵', '透過睡眠研究獲得的研究EXP都會增加6%'),
  s17(17, '夢之碎片獎勵', '透過睡眠研究獲得的夢之碎片會增加6%');

  const SubSkill(this.id, this.name, this.intro);

  final int id;
  final String name;
  final String intro;
}

void main() {
  final pokemon1 = PokemonBasicProfile(
    id: 9487,
    boxNo: 25,
    nameI18nKey: '皮卡丘',
    helpInterval: 2200,
    fruit: Fruit.f4,
    sleepType: PokemonSleepType.t3,
    mainSkill: MainSkill.m1,
  );

  final profile = PokemonProfile(
    basicProfile: pokemon1,
    character: PokemonCharacter.c9,
    subSkillLv10: SubSkill.s6,
    subSkillLv25: SubSkill.s4,
    subSkillLv50: SubSkill.s13,
    subSkillLv75: SubSkill.s17,
    subSkillLv100: SubSkill.s12,
    ingredient1: Ingredient.i5,
    ingredientCount1: 1,
    ingredient2: Ingredient.i11,
    ingredientCount2: 2,
    ingredient3: Ingredient.i11,
    ingredientCount3: 3,
  );

  print(profile.info());
}

