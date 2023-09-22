import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonProfile {
  PokemonProfile({
    required this.basicProfileId,
    required this.character,
    required this.subSkillLv10,
    required this.subSkillLv25,
    required this.subSkillLv50,
    required this.subSkillLv75,
    required this.subSkillLv100,
    required this.ingredient2,
    required this.ingredientCount2,
    required this.ingredient3,
    required this.ingredientCount3,
  });

  final int basicProfileId;
  late PokemonBasicProfile basicProfile;
  final PokemonCharacter character;

  final SubSkill subSkillLv10;
  final SubSkill subSkillLv25;
  final SubSkill subSkillLv50;
  final SubSkill subSkillLv75;
  final SubSkill subSkillLv100;

  Ingredient get ingredient1 => basicProfile.ingredient1;
  int get ingredientCount1 => basicProfile.ingredientCount1;
  final Ingredient ingredient2;
  final int ingredientCount2;
  final Ingredient ingredient3;
  final int ingredientCount3;

  List<SubSkill> get subSkills => [
    subSkillLv10,
    subSkillLv25,
    subSkillLv50,
    subSkillLv75,
    subSkillLv100,
  ];

  String info() {
    final fruitCount = calcFruitCount();
    final fruitEnergy = fruitCount * basicProfile.fruit.energyIn60;

    final ingredientEnergy1 = ingredient1.energy * ingredientCount1;
    final ingredientEnergy2 = ingredient2.energy * ingredientCount2;
    final ingredientEnergy3 = ingredient3.energy * ingredientCount3;
    final ingredientEnergyAvg = ((ingredientEnergy1 + ingredientEnergy2 + ingredientEnergy3) / 3).round();

    var result = '${basicProfile.nameI18nKey}\n'
        '性格: ${character.name}\n'
        // '副技能:\n'
        // '    Lv 10: ${subSkillLv10.name}\n'
        // '    Lv 25: ${subSkillLv25.name}\n'
        // '    Lv 50: ${subSkillLv50.name}\n'
        // '    Lv 75: ${subSkillLv75.name}\n'
        // '    Lv 100: ${subSkillLv100.name} \n'
        // '食材:\n'
        // '    ${ingredient1.nameI18nKey} (${ingredientCount1})\n'
        // '    ${ingredient2.nameI18nKey} (${ingredientCount2})\n'
        // '    ${ingredient3.nameI18nKey} (${ingredientCount3})\n'
        '幫忙均能: TBD\n'
        '類型: ${basicProfile.sleepType.name} (${basicProfile.fruit.nameI18nKey}) \n'
        '數量: ${fruitCount}\n'
        '幫忙間隔: TBD\n'
        '幫忙均能/次: TBD\n'
        // '類型: ${basicProfile.sleepType.name}\n'
        // '樹果: ${basicProfile.fruit.nameI18nKey}\n'
        '數量: ${fruitCount}\n'
        '幫忙間隔: TBD\n'
        // '樹果能量: $fruitEnergy\n'
        // '食材1能量: $ingredientEnergy1\n'
        // '食材2能量: $ingredientEnergy2\n'
        // '食材3能量: $ingredientEnergy3\n'
        // '食材均能: $ingredientEnergyAvg\n'
        '幫手獎勵: ${calcHelperBonus()}\n'
        '幫忙速度S: TBD\n'
        '幫忙速度M: TBD\n'
        '食材機率: TBD\n'
        '技能等級: TBD\n'
        '主技能速度參數: TBD\n'
        '持有上限溢出數: TBD\n'
        '持有上限溢出能量: TBD\n'
        '性格速度: TBD\n'
        '活力加速: TBD\n'
        '睡眠EXP獎勵: TBD\n'
        '夢之碎片獎勵: TBD\n'
        '主技能: TBD\n'
        '主技能能量: TBD\n'
        '主技活力加速: TBD\n'
    ;


    return result;
  }

  int calcHelperBonus() {
    var res = 0;

    for (final subSkill in subSkills) {
      if (subSkill == SubSkill.s2) {
        res += 15;
      }
    }

    return res;
  }

  int calcFruitCount() {
    var res = 1;

    if (basicProfile.sleepType == PokemonSleepType.t3) {
      res++;
    }

    for (final subSkill in subSkills) {
      if (subSkill == SubSkill.s1) {
        res++;
      }
    }

    return res;
  }

}