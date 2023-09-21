import 'package:pokemon_sleep_tools/data/models/models.dart';

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
    required this.evolutionMaxCount,
    required this.helpInterval,
    required this.fruit,
    required this.sleepType,
    required this.mainSkill,
    required this.boxCount,
    required this.ingredient1,
    required this.ingredientCount1,
  });

  factory PokemonBasicProfile.from(
      int id,
      int boxNo,
      String nameI18nKey,
      int helpInterval,
      Fruit fruit,
      PokemonSleepType sleepType,
      MainSkill mainSkill,
      int evolutionMaxCount, // 最終進化階段
      int boxCount,
      Ingredient ingredient1,
      int ingredientCount1,
      ) {
    return PokemonBasicProfile(
      id: id,
      boxNo: boxNo,
      nameI18nKey: nameI18nKey,
      helpInterval: helpInterval,
      fruit: fruit,
      sleepType: sleepType,
      mainSkill: mainSkill,
      evolutionMaxCount: evolutionMaxCount,
      boxCount: boxCount,
      ingredient1: ingredient1,
      ingredientCount1: ingredientCount1,
    );
  }

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

  /// 先暫時不用 [evolutionId]
  final int evolutionMaxCount;

  /// Pokemon Sleep, 最終幫忙間隔(秒)
  final int helpInterval;

  /// Pokemon Sleep, 樹果
  final Fruit fruit;

  /// Pokemon Sleep, type
  final PokemonSleepType sleepType;

  /// Pokemon Sleep, 主技能
  final MainSkill mainSkill;

  /// Pokemon Sleep, 格子
  final int boxCount;

  /// Pokemon Sleep, 食材一
  final Ingredient ingredient1;

  /// Pokemon Sleep, 食材一數量
  final int ingredientCount1;
}