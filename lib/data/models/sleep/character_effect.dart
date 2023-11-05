enum CharacterEffect {
  /// 幫忙速度
  helpSpeed,
  /// 活力回復
  energyRecovery,
  /// 食材發現
  ingredientDiscovery,
  /// 主技能
  mainSkill,
  /// EXP
  exp,
  /// 無
  none,
}

extension CharacterEffectX on CharacterEffect {
  String get nameI18nKey {
    return switch (this) {
      CharacterEffect.mainSkill => '主技能',
      CharacterEffect.helpSpeed => '幫忙速度',
      CharacterEffect.ingredientDiscovery => '食材發現',
      CharacterEffect.exp => 'EXP',
      CharacterEffect.energyRecovery => '活力回復',
      CharacterEffect.none => '無',
    };
  }
}
