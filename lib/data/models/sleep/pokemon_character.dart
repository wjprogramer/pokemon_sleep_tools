import 'dart:ui';

import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

/// 這是根據 ChatGPT + 個人主觀分類的 (消極、積極、中立)
enum PokemonCharacterType {
  /// 積極
  positive(positiveColor, 1),
  /// 中立或中性
  neutral(orangeColor, 2),
  /// 消極
  negative(dangerColor, 3);

  const PokemonCharacterType(this.color, this.sort);

  final Color color;
  final int sort;
}

/// 性格
///
/// IMPORTANT:
/// 目前都是將 [PokemonCharacter.positive], [PokemonCharacter.negative]
/// 作為判斷依據，因此改動要注意
///
/// TODO: 需要實際將版本切換至英文確認翻譯文本
///
/// '主技能' => '主技能發動機率'
/// '食材發現' => '食材發現率'
/// 'EXP' => 'EXP獲得量'
/// '活力回復' => '活力回復量'
/// '幫忙速度'
///
/// 性格 = nature
enum PokemonCharacter {
  afraidLoneliness(1, 't_nature_1', '幫忙速度', '活力回復', PokemonCharacterType.negative),
  stubborn(2, 't_nature_2', '幫忙速度', '食材發現', PokemonCharacterType.negative),
  mischievous(3, 't_nature_3', '幫忙速度', '主技能', PokemonCharacterType.neutral),
  brave(4, 't_nature_4', '幫忙速度', 'EXP', PokemonCharacterType.positive),
  bold(5, 't_nature_5', '活力回復', '幫忙速度', PokemonCharacterType.positive),
  naughty(6, 't_nature_6', '活力回復', '食材發現', PokemonCharacterType.neutral),
  optimism(7, 't_nature_7', '活力回復', '主技能', PokemonCharacterType.positive),
  laidBack(8, 't_nature_8', '活力回復', 'EXP', PokemonCharacterType.positive),
  restrained(9, 't_nature_9', '食材發現', '幫忙速度', PokemonCharacterType.neutral),
  c10(10, 't_nature_10', '食材發現', '活力回復', PokemonCharacterType.negative),
  c11(11, 't_nature_11', '食材發現', '主技能', PokemonCharacterType.negative),
  c12(12, 't_nature_12', '食材發現', 'EXP', PokemonCharacterType.neutral),
  c13(13, 't_nature_13', '主技能', '幫忙速度', PokemonCharacterType.neutral),
  c14(14, 't_nature_14', '主技能', '活力回復', PokemonCharacterType.neutral),
  c15(15, 't_nature_15', '主技能', '食材發現', PokemonCharacterType.neutral),
  c16(16, 't_nature_16', '主技能', 'EXP', PokemonCharacterType.negative),
  c17(17, 't_nature_17', 'EXP', '幫忙速度', PokemonCharacterType.negative),
  c18(18, 't_nature_18', 'EXP', '活力回復', PokemonCharacterType.negative),
  c19(19, 't_nature_19', 'EXP', '食材發現', PokemonCharacterType.positive),
  c20(20, 't_nature_20', 'EXP', '主技能', PokemonCharacterType.neutral),
  c21(21, 't_nature_21', null, null, PokemonCharacterType.neutral),
  c22(22, 't_nature_22', null, null, PokemonCharacterType.positive),
  c23(23, 't_nature_23', null, null, PokemonCharacterType.positive),
  c24(24, 't_nature_24', null, null, PokemonCharacterType.negative),
  c25(25, 't_nature_25', null, null, PokemonCharacterType.neutral);

  const PokemonCharacter(this.id, this.nameI18nKey, this.positive, this.negative, this.type);

  final int id;
  final String nameI18nKey;
  final String? positive;
  final String? negative;

  /// 自訂的分類 for UI
  final PokemonCharacterType type;
}