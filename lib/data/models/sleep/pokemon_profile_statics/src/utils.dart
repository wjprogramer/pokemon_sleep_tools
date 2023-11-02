part of 'statics.dart';

extension _MainSkillX on MainSkill {
  bool get calculateWithHelperScore {
    return switch (this) {
      MainSkill.energyFillS => false,
      MainSkill.energyFillM => false,
      MainSkill.energyFillSn => false,
      MainSkill.dreamChipS => false,
      MainSkill.dreamChipSn => false,
      MainSkill.vitalityFillS => false,
      MainSkill.helpSupportS => false,
      MainSkill.ingredientS => false,
      MainSkill.cuisineS => false,
      MainSkill.vitalityS => true,
      MainSkill.vitalityAllS => true,
      MainSkill.finger => true,
    };
  }
}