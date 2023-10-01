import 'package:collection/collection.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonBasicProfileRepository implements MyInjectable {
  PokemonBasicProfileRepository() {
    for (final entry in _allPokemonMapping.entries) {
      final pokemonId = entry.key;
      final basicProfile = entry.value;

      basicProfile.ingredientChain = _ingredientChainMap[basicProfile.ingredientChainId]!;
    }
  }

  Future<Map<int, PokemonBasicProfile>> findAllMapping() async {
    return _allPokemonMapping;
  }

  Future<List<PokemonBasicProfile>> findAll() async {
    final x = [..._allPokemonMapping.entries.map((e) => e.value)];
    x.sort((a, b) => a.id - b.id);
    return x;
  }

  Future<List<PokemonBasicProfile>> findInIdList({
    required List<int> idList,
  }) async {
    final tmp = await Future.wait(idList.map((e) => getBasicProfile(e)));
    final profiles = tmp.whereNotNull().toList();
    return profiles;
  }

  Future<PokemonBasicProfile?> getBasicProfile(int basicProfileId) async {
    return _allPokemonMapping[basicProfileId];
  }

  /// - 幫忙間隔都是以最高階計算
  final _allPokemonMapping = {
    1: PokemonBasicProfile.from(1, 1, '妙蛙種子', 2800, Fruit.f5, PokemonSleepType.t2, MainSkill.ingredientS, 3, 27, Ingredient.i9, 2, 3),
    2: PokemonBasicProfile.from(2, 2, '妙蛙草', 2800, Fruit.f5, PokemonSleepType.t2, MainSkill.ingredientS, 3, 27, Ingredient.i9, 2, 3),
    3: PokemonBasicProfile.from(3, 3, '妙蛙花', 2800, Fruit.f5, PokemonSleepType.t2, MainSkill.ingredientS, 3, 27, Ingredient.i9, 2, 3),
    4: PokemonBasicProfile.from(4, 4, '小火龍', 2400, Fruit.f2, PokemonSleepType.t2, MainSkill.ingredientS, 3, 29, Ingredient.i7, 2, 6),
    5: PokemonBasicProfile.from(5, 5, '火恐龍', 2400, Fruit.f2, PokemonSleepType.t2, MainSkill.ingredientS, 3, 29, Ingredient.i7, 2, 6),
    6: PokemonBasicProfile.from(6, 6, '噴火龍', 2400, Fruit.f2, PokemonSleepType.t2, MainSkill.ingredientS, 3, 29, Ingredient.i7, 2, 6),
    7: PokemonBasicProfile.from(7, 7, '傑尼龜', 2800, Fruit.f3, PokemonSleepType.t2, MainSkill.ingredientS, 3, 27, Ingredient.i8, 2, 9),
    8: PokemonBasicProfile.from(8, 8, '卡咪龜', 2800, Fruit.f3, PokemonSleepType.t2, MainSkill.ingredientS, 3, 27, Ingredient.i8, 2, 9),
    9: PokemonBasicProfile.from(9, 9, '水箭龜', 2800, Fruit.f3, PokemonSleepType.t2, MainSkill.ingredientS, 3, 27, Ingredient.i8, 2, 9),
    10: PokemonBasicProfile.from(10, 10, '綠毛蟲', 2600, Fruit.f12, PokemonSleepType.t3, MainSkill.ingredientS, 3, 31, Ingredient.i9, 1, 12),
    11: PokemonBasicProfile.from(11, 11, '鐵甲蛹', 2600, Fruit.f12, PokemonSleepType.t3, MainSkill.ingredientS, 3, 31, Ingredient.i9, 1, 12),
    12: PokemonBasicProfile.from(12, 12, '巴大蝶', 2600, Fruit.f12, PokemonSleepType.t3, MainSkill.ingredientS, 3, 31, Ingredient.i9, 1, 12),
    13: PokemonBasicProfile.from(13, 19, '小拉達', 3200, Fruit.f1, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 21, Ingredient.i5, 1, 20),
    14: PokemonBasicProfile.from(14, 20, '拉達', 3200, Fruit.f1, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 21, Ingredient.i5, 1, 20),
    15: PokemonBasicProfile.from(15, 23, '阿柏蛇', 3700, Fruit.f8, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 19, Ingredient.i7, 1, 24),
    16: PokemonBasicProfile.from(16, 24, '阿柏怪', 3700, Fruit.f8, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 19, Ingredient.i7, 1, 24),
    17: PokemonBasicProfile.from(17, 172, '皮丘', 2200, Fruit.f4, PokemonSleepType.t3, MainSkill.energyFillS, 3, 31, Ingredient.i5, 1, 26),
    18: PokemonBasicProfile.from(18, 25, '皮卡丘', 2200, Fruit.f4, PokemonSleepType.t3, MainSkill.energyFillS, 3, 31, Ingredient.i5, 1, 26),
    19: PokemonBasicProfile.from(19, 26, '雷丘', 2200, Fruit.f4, PokemonSleepType.t3, MainSkill.energyFillS, 3, 31, Ingredient.i5, 1, 26),
    20: PokemonBasicProfile.from(20, 174, '寶寶丁', 2900, Fruit.f18, PokemonSleepType.t1, MainSkill.vitalityAllS, 3, 23, Ingredient.i9, 1, 40),
    21: PokemonBasicProfile.from(21, 39, '胖丁', 2900, Fruit.f18, PokemonSleepType.t1, MainSkill.vitalityAllS, 3, 23, Ingredient.i9, 1, 40),
    22: PokemonBasicProfile.from(22, 40, '胖可丁', 2900, Fruit.f18, PokemonSleepType.t1, MainSkill.vitalityAllS, 3, 23, Ingredient.i9, 1, 40),
    23: PokemonBasicProfile.from(23, 50, '地鼠', 2800, Fruit.f9, PokemonSleepType.t2, MainSkill.energyFillS, 2, 21, Ingredient.i12, 2, 51),
    24: PokemonBasicProfile.from(24, 51, '三地鼠', 2800, Fruit.f9, PokemonSleepType.t2, MainSkill.energyFillS, 2, 21, Ingredient.i12, 2, 51),
    25: PokemonBasicProfile.from(25, 52, '喵喵', 3000, Fruit.f1, PokemonSleepType.t1, MainSkill.dreamChipS, 2, 17, Ingredient.i8, 1, 53),
    26: PokemonBasicProfile.from(26, 53, '貓老大', 3000, Fruit.f1, PokemonSleepType.t1, MainSkill.dreamChipS, 2, 17, Ingredient.i8, 1, 53),
    27: PokemonBasicProfile.from(27, 54, '可達鴨', 3400, Fruit.f3, PokemonSleepType.t1, MainSkill.energyFillSn, 2, 16, Ingredient.i13, 1, 55),
    28: PokemonBasicProfile.from(28, 55, '哥達鴨', 3400, Fruit.f3, PokemonSleepType.t1, MainSkill.energyFillSn, 2, 16, Ingredient.i13, 1, 55),
    29: PokemonBasicProfile.from(29, 56, '猴怪', 2800, Fruit.f7, PokemonSleepType.t3, MainSkill.energyFillSn, 2, 22, Ingredient.i7, 1, 57),
    30: PokemonBasicProfile.from(30, 57, '火爆猴', 2800, Fruit.f7, PokemonSleepType.t3, MainSkill.energyFillSn, 2, 22, Ingredient.i7, 1, 57),
    31: PokemonBasicProfile.from(31, 58, '卡蒂狗', 2500, Fruit.f2, PokemonSleepType.t1, MainSkill.helpSupportS, 2, 21, Ingredient.i6, 1, 59),
    32: PokemonBasicProfile.from(32, 59, '風速狗', 2500, Fruit.f2, PokemonSleepType.t1, MainSkill.helpSupportS, 2, 21, Ingredient.i6, 1, 59),
    33: PokemonBasicProfile.from(33, 69, '喇叭芽', 2800, Fruit.f5, PokemonSleepType.t2, MainSkill.vitalityFillS, 3, 27, Ingredient.i12, 2, 71),
    34: PokemonBasicProfile.from(34, 70, '口呆花', 2800, Fruit.f5, PokemonSleepType.t2, MainSkill.vitalityFillS, 3, 27, Ingredient.i12, 2, 71),
    35: PokemonBasicProfile.from(35, 71, '大食花', 2800, Fruit.f5, PokemonSleepType.t2, MainSkill.vitalityFillS, 3, 27, Ingredient.i12, 2, 71),
    36: PokemonBasicProfile.from(36, 74, '小拳石', 3100, Fruit.f13, PokemonSleepType.t2, MainSkill.energyFillSn, 3, 26, Ingredient.i15, 2, 76),
    37: PokemonBasicProfile.from(37, 75, '隆隆石', 3100, Fruit.f13, PokemonSleepType.t2, MainSkill.energyFillSn, 3, 26, Ingredient.i15, 2, 76),
    38: PokemonBasicProfile.from(38, 76, '隆隆岩', 3100, Fruit.f13, PokemonSleepType.t2, MainSkill.energyFillSn, 3, 26, Ingredient.i15, 2, 76),
    39: PokemonBasicProfile.from(39, 79, '呆呆獸', 3400, Fruit.f3, PokemonSleepType.t1, MainSkill.vitalityS, 2, 16, Ingredient.i13, 1, 80),
    40: PokemonBasicProfile.from(40, 80, '呆殼獸', 3800, Fruit.f3, PokemonSleepType.t1, MainSkill.vitalityS, 2, 15, Ingredient.i13, 1, 80),
    41: PokemonBasicProfile.from(41, 199, '呆呆王', 3400, Fruit.f3, PokemonSleepType.t1, MainSkill.vitalityS, 2, 16, Ingredient.i13, 1, 199),
    42: PokemonBasicProfile.from(42, 81, '小磁怪', 3100, Fruit.f17, PokemonSleepType.t1, MainSkill.cuisineS, 3, 23, Ingredient.i10, 1, 462),
    43: PokemonBasicProfile.from(43, 82, '三合一磁怪', 3100, Fruit.f17, PokemonSleepType.t1, MainSkill.cuisineS, 3, 23, Ingredient.i10, 1, 462),
    44: PokemonBasicProfile.from(44, 462, '自爆磁怪', 3100, Fruit.f17, PokemonSleepType.t1, MainSkill.cuisineS, 3, 23, Ingredient.i10, 1, 462),
    45: PokemonBasicProfile.from(45, 84, '嘟嘟', 2400, Fruit.f10, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 26, Ingredient.i15, 1, 85),
    46: PokemonBasicProfile.from(46, 85, '嘟嘟利', 2400, Fruit.f10, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 26, Ingredient.i15, 1, 85),
    47: PokemonBasicProfile.from(47, 92, '鬼斯', 2200, Fruit.f14, PokemonSleepType.t2, MainSkill.energyFillSn, 3, 28, Ingredient.i6, 2, 94),
    48: PokemonBasicProfile.from(48, 93, '鬼斯通', 2200, Fruit.f14, PokemonSleepType.t2, MainSkill.energyFillSn, 3, 28, Ingredient.i6, 2, 94),
    49: PokemonBasicProfile.from(49, 94, '耿鬼', 2200, Fruit.f14, PokemonSleepType.t2, MainSkill.energyFillSn, 3, 28, Ingredient.i6, 2, 94),
    50: PokemonBasicProfile.from(50, 104, '卡拉卡拉', 3500, Fruit.f9, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 20, Ingredient.i11, 1, 105),
    51: PokemonBasicProfile.from(51, 105, '嘎啦嘎啦', 3500, Fruit.f9, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 20, Ingredient.i11, 1, 105),
    52: PokemonBasicProfile.from(52, 115, '袋獸', 2800, Fruit.f1, PokemonSleepType.t2, MainSkill.ingredientS, 1, 16, Ingredient.i11, 2, 115),
    53: PokemonBasicProfile.from(53, 127, '凱羅斯', 2400, Fruit.f12, PokemonSleepType.t2, MainSkill.energyFillS, 1, 19, Ingredient.i9, 2, 127),
    54: PokemonBasicProfile.from(54, 132, '百變怪', 3500, Fruit.f1, PokemonSleepType.t2, MainSkill.energyFillSn, 1, 13, Ingredient.i10, 2, 132),
    55: PokemonBasicProfile.from(55, 133, '伊布', 2600, Fruit.f18, PokemonSleepType.t1, MainSkill.vitalityAllS, 2, 20, Ingredient.i8, 1, 133),
    56: PokemonBasicProfile.from(56, 700, '仙子伊布', 2600, Fruit.f18, PokemonSleepType.t1, MainSkill.vitalityAllS, 2, 20, Ingredient.i8, 1, 700),
    57: PokemonBasicProfile.from(57, 134, '水伊布', 3100, Fruit.f3, PokemonSleepType.t1, MainSkill.ingredientS, 2, 18, Ingredient.i8, 1, 134),
    58: PokemonBasicProfile.from(58, 135, '雷伊布', 2200, Fruit.f4, PokemonSleepType.t1, MainSkill.helpSupportS, 2, 22, Ingredient.i8, 1, 135),
    59: PokemonBasicProfile.from(59, 136, '火伊布', 2700, Fruit.f2, PokemonSleepType.t1, MainSkill.cuisineS, 2, 19, Ingredient.i8, 1, 136),
    60: PokemonBasicProfile.from(60, 196, '太陽伊布', 2400, Fruit.f11, PokemonSleepType.t1, MainSkill.energyFillM, 2, 21, Ingredient.i8, 1, 196),
    61: PokemonBasicProfile.from(61, 197, '月亮伊布', 3200, Fruit.f16, PokemonSleepType.t1, MainSkill.vitalityFillS, 2, 19, Ingredient.i8, 1, 197),
    62: PokemonBasicProfile.from(62, 470, '葉伊布', 3000, Fruit.f5, PokemonSleepType.t1, MainSkill.vitalityS, 2, 18, Ingredient.i8, 1, 470),
    63: PokemonBasicProfile.from(63, 471, '冰伊布', 3200, Fruit.f6, PokemonSleepType.t1, MainSkill.cuisineS, 2, 17, Ingredient.i8, 1, 471),
    64: PokemonBasicProfile.from(64, 152, '菊草葉', 2800, Fruit.f5, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 30, Ingredient.i13, 1, 154),
    65: PokemonBasicProfile.from(65, 153, '月桂葉', 2800, Fruit.f5, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 30, Ingredient.i13, 1, 154),
    66: PokemonBasicProfile.from(66, 154, '大竺葵', 2800, Fruit.f5, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 30, Ingredient.i13, 1, 154),
    67: PokemonBasicProfile.from(67, 155, '火球鼠', 2400, Fruit.f2, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 33, Ingredient.i11, 1, 157),
    68: PokemonBasicProfile.from(68, 156, '火岩鼠', 2400, Fruit.f2, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 33, Ingredient.i11, 1, 157),
    69: PokemonBasicProfile.from(69, 157, '火爆獸', 2400, Fruit.f2, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 33, Ingredient.i11, 1, 157),
    70: PokemonBasicProfile.from(70, 158, '小鋸鱷', 2800, Fruit.f3, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 29, Ingredient.i7, 1, 160),
    71: PokemonBasicProfile.from(71, 159, '藍鱷', 2800, Fruit.f3, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 29, Ingredient.i7, 1, 160),
    72: PokemonBasicProfile.from(72, 160, '大力鱷', 2800, Fruit.f3, PokemonSleepType.t3, MainSkill.energyFillSn, 3, 29, Ingredient.i7, 1, 160),
    73: PokemonBasicProfile.from(73, 175, '波克比', 2600, Fruit.f18, PokemonSleepType.t1, MainSkill.finger, 3, 26, Ingredient.i3, 1, 468),
    74: PokemonBasicProfile.from(74, 176, '波克基古', 2600, Fruit.f18, PokemonSleepType.t1, MainSkill.finger, 3, 26, Ingredient.i3, 1, 468),
    75: PokemonBasicProfile.from(75, 468, '波克基斯', 2600, Fruit.f18, PokemonSleepType.t1, MainSkill.finger, 3, 26, Ingredient.i3, 1, 468),
    76: PokemonBasicProfile.from(76, 179, '咩利羊', 2500, Fruit.f4, PokemonSleepType.t1, MainSkill.energyFillM, 3, 25, Ingredient.i6, 1, 181),
    77: PokemonBasicProfile.from(77, 180, '茸茸羊', 2500, Fruit.f4, PokemonSleepType.t1, MainSkill.energyFillM, 3, 25, Ingredient.i6, 1, 181),
    78: PokemonBasicProfile.from(78, 181, '電龍', 2500, Fruit.f4, PokemonSleepType.t1, MainSkill.energyFillM, 3, 25, Ingredient.i6, 1, 181),
    79: PokemonBasicProfile.from(79, 438, '盆才怪', 4000, Fruit.f13, PokemonSleepType.t1, MainSkill.energyFillM, 2, 15, Ingredient.i12, 1, 185),
    80: PokemonBasicProfile.from(80, 185, '樹才怪', 4000, Fruit.f13, PokemonSleepType.t1, MainSkill.energyFillM, 2, 15, Ingredient.i12, 1, 185),
    81: PokemonBasicProfile.from(81, 360, '小果然', 3500, Fruit.f11, PokemonSleepType.t1, MainSkill.vitalityS, 2, 15, Ingredient.i5, 1, 202),
    82: PokemonBasicProfile.from(82, 202, '果然翁', 3500, Fruit.f11, PokemonSleepType.t1, MainSkill.vitalityS, 2, 15, Ingredient.i5, 1, 202),
    83: PokemonBasicProfile.from(83, 214, '赫拉克羅斯', 2500, Fruit.f12, PokemonSleepType.t1, MainSkill.ingredientS, 1, 15, Ingredient.i9, 1, 214),
    84: PokemonBasicProfile.from(84, 228, '戴魯比', 3300, Fruit.f16, PokemonSleepType.t3, MainSkill.energyFillS, 2, 21, Ingredient.i6, 1, 229),
    85: PokemonBasicProfile.from(85, 229, '黑魯加', 3300, Fruit.f16, PokemonSleepType.t3, MainSkill.energyFillS, 2, 21, Ingredient.i6, 1, 229),
    86: PokemonBasicProfile.from(86, 246, '幼基拉斯', 2700, Fruit.f16, PokemonSleepType.t2, MainSkill.vitalityFillS, 3, 29, Ingredient.i11, 2, 248),
    87: PokemonBasicProfile.from(87, 247, '沙基拉斯', 2700, Fruit.f16, PokemonSleepType.t2, MainSkill.vitalityFillS, 3, 29, Ingredient.i11, 2, 248),
    88: PokemonBasicProfile.from(88, 248, '班基拉斯', 2700, Fruit.f16, PokemonSleepType.t2, MainSkill.vitalityFillS, 3, 29, Ingredient.i11, 2, 248),
    89: PokemonBasicProfile.from(89, 287, '懶人獺', 3200, Fruit.f1, PokemonSleepType.t3, MainSkill.ingredientS, 3, 17, Ingredient.i12, 1, 289),
    90: PokemonBasicProfile.from(90, 288, '過動猿', 3200, Fruit.f1, PokemonSleepType.t3, MainSkill.ingredientS, 3, 17, Ingredient.i12, 1, 289),
    91: PokemonBasicProfile.from(91, 289, '請假王', 3200, Fruit.f1, PokemonSleepType.t3, MainSkill.ingredientS, 3, 22, Ingredient.i12, 1, 289),
    92: PokemonBasicProfile.from(92, 302, '勾魂眼', 3600, Fruit.f16, PokemonSleepType.t1, MainSkill.dreamChipSn, 1, 10, Ingredient.i10, 1, 302),
    93: PokemonBasicProfile.from(93, 316, '溶食獸', 3500, Fruit.f8, PokemonSleepType.t1, MainSkill.dreamChipSn, 2, 18, Ingredient.i15, 1, 317),
    94: PokemonBasicProfile.from(94, 317, '吞食獸', 3500, Fruit.f8, PokemonSleepType.t1, MainSkill.dreamChipSn, 2, 18, Ingredient.i15, 1, 317),
    95: PokemonBasicProfile.from(95, 333, '青綿鳥', 3700, Fruit.f15, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 19, Ingredient.i3, 1, 334),
    96: PokemonBasicProfile.from(96, 334, '七夕青鳥', 3700, Fruit.f15, PokemonSleepType.t3, MainSkill.vitalityFillS, 2, 19, Ingredient.i3, 1, 334),
    97: PokemonBasicProfile.from(97, 359, '阿勃梭魯', 3100, Fruit.f16, PokemonSleepType.t2, MainSkill.energyFillS, 1, 14, Ingredient.i13, 2, 359),
    98: PokemonBasicProfile.from(98, 363, '海豹球', 3000, Fruit.f6, PokemonSleepType.t3, MainSkill.ingredientS, 3, 28, Ingredient.i10, 1, 365),
    99: PokemonBasicProfile.from(99, 364, '海魔獅', 3000, Fruit.f6, PokemonSleepType.t3, MainSkill.ingredientS, 3, 28, Ingredient.i10, 1, 365),
    100: PokemonBasicProfile.from(100, 365, '帝牙海獅', 3000, Fruit.f6, PokemonSleepType.t3, MainSkill.ingredientS, 3, 28, Ingredient.i10, 1, 365),
    101: PokemonBasicProfile.from(101, 447, '利歐路', 2700, Fruit.f7, PokemonSleepType.t1, MainSkill.dreamChipS, 2, 19, Ingredient.i10, 1, 448),
    102: PokemonBasicProfile.from(102, 448, '路卡利歐', 2700, Fruit.f7, PokemonSleepType.t1, MainSkill.dreamChipS, 2, 19, Ingredient.i10, 1, 448),
    103: PokemonBasicProfile.from(103, 453, '不良蛙', 3400, Fruit.f8, PokemonSleepType.t2, MainSkill.energyFillS, 2, 19, Ingredient.i10, 2, 454),
    104: PokemonBasicProfile.from(104, 454, '毒骷蛙', 3400, Fruit.f8, PokemonSleepType.t2, MainSkill.energyFillS, 2, 19, Ingredient.i10, 2, 454),
    105: PokemonBasicProfile.from(105, 439, '魔尼尼', 2800, Fruit.f11, PokemonSleepType.t2, MainSkill.energyFillS, 2, 22, Ingredient.i12, 2, 439),
    106: PokemonBasicProfile.from(106, 122, '魔牆人偶', 2800, Fruit.f11, PokemonSleepType.t2, MainSkill.energyFillS, 2, 22, Ingredient.i12, 2, 439),
    107: PokemonBasicProfile.from(107, 35, '皮皮', 2800, Fruit.f18, PokemonSleepType.t3, MainSkill.finger, 3, 24, Ingredient.i5, 1, 36),
    108: PokemonBasicProfile.from(108, 36, '皮可西', 2800, Fruit.f18, PokemonSleepType.t3, MainSkill.finger, 3, 24, Ingredient.i5, 1, 36),
    109: PokemonBasicProfile.from(109, 173, '皮寶寶', 2800, Fruit.f18, PokemonSleepType.t3, MainSkill.finger, 3, 24, Ingredient.i5, 1, 36),
  };

  final _ingredientChainMap = <int, IngredientChain>{
    3: IngredientChain(3, [(Ingredient.i9, 5),(Ingredient.i12, 4)], [(Ingredient.i4, 6),(Ingredient.i9, 7),(Ingredient.i12, 7)]),
    6: IngredientChain(6, [(Ingredient.i7, 5),(Ingredient.i11, 4)], [(Ingredient.i6, 6),(Ingredient.i7, 7),(Ingredient.i11, 7)]),
    9: IngredientChain(9, [(Ingredient.i8, 5),(Ingredient.i13, 3)], [(Ingredient.i7, 7),(Ingredient.i8, 7),(Ingredient.i13, 5)]),
    12: IngredientChain(12, [(Ingredient.i9, 2),(Ingredient.i12, 2)], [(Ingredient.i9, 4),(Ingredient.i12, 3),(Ingredient.i15, 4)]),
    20: IngredientChain(20, [(Ingredient.i5, 2),(Ingredient.i15, 2)], [(Ingredient.i5, 4),(Ingredient.i7, 3),(Ingredient.i15, 3)]),
    24: IngredientChain(24, [(Ingredient.i3, 2),(Ingredient.i7, 2)], [(Ingredient.i3, 3),(Ingredient.i6, 3),(Ingredient.i7, 4)]),
    26: IngredientChain(26, [(Ingredient.i5, 2),(Ingredient.i11, 2)], [(Ingredient.i3, 3),(Ingredient.i5, 4),(Ingredient.i11, 3)]),
    36: IngredientChain(36, [(Ingredient.i5, 2),(Ingredient.i9, 2)], [(Ingredient.i5, 4),(Ingredient.i9, 3),(Ingredient.i15, 3)]),
    40: IngredientChain(40, [(Ingredient.i9, 2),(Ingredient.i10, 2)], [(Ingredient.i9, 4),(Ingredient.i10, 3),(Ingredient.i13, 2)]),
    51: IngredientChain(51, [(Ingredient.i1, 3),(Ingredient.i12, 5)], [(Ingredient.i1, 4),(Ingredient.i12, 7),(Ingredient.i15, 8)]),
    53: IngredientChain(53, [(Ingredient.i7, 2),(Ingredient.i8, 2)], [(Ingredient.i7, 3),(Ingredient.i8, 4)]),
    55: IngredientChain(55, [(Ingredient.i5, 4),(Ingredient.i13, 2)], [(Ingredient.i5, 6),(Ingredient.i7, 5),(Ingredient.i13, 4)]),
    57: IngredientChain(57, [(Ingredient.i2, 1),(Ingredient.i7, 2)], [(Ingredient.i2, 2),(Ingredient.i7, 4),(Ingredient.i9, 4)]),
    59: IngredientChain(59, [(Ingredient.i6, 2),(Ingredient.i7, 3)], [(Ingredient.i6, 4),(Ingredient.i7, 5),(Ingredient.i8, 5)]),
    71: IngredientChain(71, [(Ingredient.i4, 4),(Ingredient.i12, 5)], [(Ingredient.i1, 4),(Ingredient.i4, 6),(Ingredient.i12, 7)]),
    76: IngredientChain(76, [(Ingredient.i4, 4),(Ingredient.i15, 5)], [(Ingredient.i2, 4),(Ingredient.i4, 6),(Ingredient.i15, 7)]),
    80: IngredientChain(80, [(Ingredient.i13, 2),(Ingredient.i14, 1)], [(Ingredient.i12, 5),(Ingredient.i13, 4),(Ingredient.i14, 2)]),
    85: IngredientChain(85, [(Ingredient.i13, 1),(Ingredient.i15, 2)], [(Ingredient.i7, 3),(Ingredient.i13, 2),(Ingredient.i15, 4)]),
    94: IngredientChain(94, [(Ingredient.i2, 4),(Ingredient.i6, 5)], [(Ingredient.i2, 6),(Ingredient.i6, 7),(Ingredient.i10, 8)]),
    105: IngredientChain(105, [(Ingredient.i11, 2),(Ingredient.i13, 2)], [(Ingredient.i11, 4),(Ingredient.i13, 3)]),
    115: IngredientChain(115, [(Ingredient.i4, 4),(Ingredient.i11, 5)], [(Ingredient.i4, 6),(Ingredient.i11, 7),(Ingredient.i15, 8)]),
    127: IngredientChain(127, [(Ingredient.i5, 5),(Ingredient.i9, 5)], [(Ingredient.i5, 8),(Ingredient.i7, 7),(Ingredient.i9, 7)]),
    132: IngredientChain(132, [(Ingredient.i1, 3),(Ingredient.i10, 5)], [(Ingredient.i1, 5),(Ingredient.i10, 7),(Ingredient.i14, 3)]),
    133: IngredientChain(133, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    134: IngredientChain(134, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    135: IngredientChain(135, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    136: IngredientChain(136, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    154: IngredientChain(154, [(Ingredient.i9, 3),(Ingredient.i13, 2)], [(Ingredient.i1, 3),(Ingredient.i9, 5),(Ingredient.i13, 4)]),
    157: IngredientChain(157, [(Ingredient.i6, 2),(Ingredient.i11, 2)], [(Ingredient.i6, 3),(Ingredient.i10, 3),(Ingredient.i11, 4)]),
    160: IngredientChain(160, [(Ingredient.i7, 2),(Ingredient.i10, 2)], [(Ingredient.i7, 4),(Ingredient.i10, 3)]),
    173: IngredientChain(173, [(Ingredient.i1, 1)], [(Ingredient.i1, 1)]),
    181: IngredientChain(181, [(Ingredient.i3, 3),(Ingredient.i6, 2)], [(Ingredient.i3, 4),(Ingredient.i6, 4)]),
    185: IngredientChain(185, [(Ingredient.i12, 2),(Ingredient.i15, 2)], [(Ingredient.i2, 2),(Ingredient.i12, 4),(Ingredient.i15, 4)]),
    196: IngredientChain(196, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    197: IngredientChain(197, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    199: IngredientChain(199, [(Ingredient.i13, 2),(Ingredient.i14, 1)], [(Ingredient.i12, 5),(Ingredient.i13, 4),(Ingredient.i14, 2)]),
    202: IngredientChain(202, [(Ingredient.i2, 1),(Ingredient.i5, 2)], [(Ingredient.i2, 2),(Ingredient.i5, 4),(Ingredient.i10, 3)]),
    214: IngredientChain(214, [(Ingredient.i2, 1),(Ingredient.i9, 2)], [(Ingredient.i2, 2),(Ingredient.i7, 4),(Ingredient.i9, 4)]),
    229: IngredientChain(229, [(Ingredient.i6, 2),(Ingredient.i11, 3)], [(Ingredient.i1, 3),(Ingredient.i6, 4),(Ingredient.i11, 4)]),
    248: IngredientChain(248, [(Ingredient.i11, 5),(Ingredient.i15, 5)], [(Ingredient.i7, 8),(Ingredient.i11, 7),(Ingredient.i15, 8)]),
    289: IngredientChain(289, [(Ingredient.i9, 2),(Ingredient.i12, 2)], [(Ingredient.i5, 4),(Ingredient.i9, 4),(Ingredient.i12, 4)]),
    302: IngredientChain(302, [(Ingredient.i2, 2),(Ingredient.i10, 2)], [(Ingredient.i2, 3),(Ingredient.i10, 4),(Ingredient.i13, 3)]),
    317: IngredientChain(317, [(Ingredient.i2, 1),(Ingredient.i15, 2)], [(Ingredient.i2, 2),(Ingredient.i9, 4),(Ingredient.i15, 4)]),
    334: IngredientChain(334, [(Ingredient.i3, 2),(Ingredient.i15, 3)], [(Ingredient.i3, 4),(Ingredient.i5, 5),(Ingredient.i15, 4)]),
    359: IngredientChain(359, [(Ingredient.i5, 8),(Ingredient.i13, 5)], [(Ingredient.i2, 7),(Ingredient.i5, 12),(Ingredient.i13, 7)]),
    365: IngredientChain(365, [(Ingredient.i7, 3),(Ingredient.i10, 2)], [(Ingredient.i7, 4),(Ingredient.i10, 4),(Ingredient.i11, 4)]),
    439: IngredientChain(439, [(Ingredient.i4, 4),(Ingredient.i12, 5)], [(Ingredient.i1, 4),(Ingredient.i4, 6),(Ingredient.i12, 7)]),
    448: IngredientChain(448, [(Ingredient.i4, 2),(Ingredient.i10, 2)], [(Ingredient.i3, 4),(Ingredient.i4, 4),(Ingredient.i10, 4)]),
    454: IngredientChain(454, [(Ingredient.i7, 5),(Ingredient.i10, 5)], [(Ingredient.i7, 8),(Ingredient.i10, 7)]),
    462: IngredientChain(462, [(Ingredient.i6, 2),(Ingredient.i10, 2)], [(Ingredient.i6, 3),(Ingredient.i10, 4)]),
    468: IngredientChain(468, [(Ingredient.i3, 2),(Ingredient.i11, 2)], [(Ingredient.i3, 4),(Ingredient.i11, 4),(Ingredient.i13, 3)]),
    470: IngredientChain(470, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    471: IngredientChain(471, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)]),
    700: IngredientChain(700, [(Ingredient.i8, 2),(Ingredient.i13, 1)], [(Ingredient.i7, 3),(Ingredient.i8, 4),(Ingredient.i13, 2)])
  };
}
