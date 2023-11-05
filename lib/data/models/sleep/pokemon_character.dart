import 'dart:ui';

import 'package:pokemon_sleep_tools/data/models/sleep/character_effect.dart';
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
  afraidLoneliness(1, 't_nature_1', CharacterEffect.helpSpeed, CharacterEffect.energyRecovery, PokemonCharacterType.negative),
  stubborn(2, 't_nature_2', CharacterEffect.helpSpeed, CharacterEffect.ingredientDiscovery, PokemonCharacterType.negative),
  mischievous(3, 't_nature_3', CharacterEffect.helpSpeed, CharacterEffect.mainSkill, PokemonCharacterType.neutral),
  brave(4, 't_nature_4', CharacterEffect.helpSpeed, CharacterEffect.exp, PokemonCharacterType.positive),
  bold(5, 't_nature_5', CharacterEffect.energyRecovery, CharacterEffect.helpSpeed, PokemonCharacterType.positive),
  naughty(6, 't_nature_6', CharacterEffect.energyRecovery, CharacterEffect.ingredientDiscovery, PokemonCharacterType.neutral),
  optimism(7, 't_nature_7', CharacterEffect.energyRecovery, CharacterEffect.mainSkill, PokemonCharacterType.positive),
  laidBack(8, 't_nature_8', CharacterEffect.energyRecovery, CharacterEffect.exp, PokemonCharacterType.positive),
  restrained(9, 't_nature_9', CharacterEffect.ingredientDiscovery, CharacterEffect.helpSpeed, PokemonCharacterType.neutral),
  c10(10, 't_nature_10', CharacterEffect.ingredientDiscovery, CharacterEffect.energyRecovery, PokemonCharacterType.negative),
  c11(11, 't_nature_11', CharacterEffect.ingredientDiscovery, CharacterEffect.mainSkill, PokemonCharacterType.negative),
  c12(12, 't_nature_12', CharacterEffect.ingredientDiscovery, CharacterEffect.exp, PokemonCharacterType.neutral),
  c13(13, 't_nature_13', CharacterEffect.mainSkill, CharacterEffect.helpSpeed, PokemonCharacterType.neutral),
  c14(14, 't_nature_14', CharacterEffect.mainSkill, CharacterEffect.energyRecovery, PokemonCharacterType.neutral),
  c15(15, 't_nature_15', CharacterEffect.mainSkill, CharacterEffect.ingredientDiscovery, PokemonCharacterType.neutral),
  c16(16, 't_nature_16', CharacterEffect.mainSkill, CharacterEffect.exp, PokemonCharacterType.negative),
  c17(17, 't_nature_17', CharacterEffect.exp, CharacterEffect.helpSpeed, PokemonCharacterType.negative),
  c18(18, 't_nature_18', CharacterEffect.exp, CharacterEffect.energyRecovery, PokemonCharacterType.negative),
  c19(19, 't_nature_19', CharacterEffect.exp, CharacterEffect.ingredientDiscovery, PokemonCharacterType.positive),
  c20(20, 't_nature_20', CharacterEffect.exp, CharacterEffect.mainSkill, PokemonCharacterType.neutral),
  c21(21, 't_nature_21', CharacterEffect.none, CharacterEffect.none, PokemonCharacterType.neutral),
  c22(22, 't_nature_22', CharacterEffect.none, CharacterEffect.none, PokemonCharacterType.positive),
  c23(23, 't_nature_23', CharacterEffect.none, CharacterEffect.none, PokemonCharacterType.positive),
  c24(24, 't_nature_24', CharacterEffect.none, CharacterEffect.none, PokemonCharacterType.negative),
  c25(25, 't_nature_25', CharacterEffect.none, CharacterEffect.none, PokemonCharacterType.neutral);

  const PokemonCharacter(this.id, this.nameI18nKey, this.positiveEffect, this.negativeEffect, this.type);

  final int id;
  final String nameI18nKey;
  final CharacterEffect positiveEffect;
  final CharacterEffect negativeEffect;

  /// 自訂的分類 for UI
  final PokemonCharacterType type;
}
