import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonProfile {
  PokemonProfile({
    this.id = -1,
    required this.basicProfileId,
    required this.character,
    this.customName,
    this.customNote,
    this.isFavorite = false,
    this.isShiny = false,
    this.customDate,
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

  // TODO:
  int id = -1;
  final int basicProfileId;
  late PokemonBasicProfile basicProfile;
  final PokemonCharacter character;
  final String? customName;
  /// 收藏
  final bool isFavorite;
  /// 是否為異色
  final bool isShiny;
  /// 使用者自訂的登錄日期 (遊戲內日期)
  final DateTime? customDate;

  /// 使用者可以填寫個人筆記
  final String? customNote;

  final SubSkill? subSkillLv10;
  final SubSkill? subSkillLv25;
  final SubSkill? subSkillLv50;
  final SubSkill? subSkillLv75;
  final SubSkill? subSkillLv100;

  Ingredient get ingredient1 => basicProfile.ingredient1;
  int get ingredientCount1 => basicProfile.ingredientCount1;
  final Ingredient? ingredient2;
  final int ingredientCount2;
  final Ingredient? ingredient3;
  final int ingredientCount3;

  List<SubSkill?> get subSkills => [
    subSkillLv10,
    subSkillLv25,
    subSkillLv50,
    subSkillLv75,
    subSkillLv100,
  ];

  // BasicProfile properties
  Fruit get fruit => basicProfile.fruit;
  PokemonSpecialty get specialty => basicProfile.specialty;
  bool get isBerrySpecialty => specialty == PokemonSpecialty.t3;
  bool get isSkillSpecialty => specialty == PokemonSpecialty.t1;
  bool get isIngredientSpecialty => specialty == PokemonSpecialty.t2;
  int get helpInterval => basicProfile.helpInterval;
  int get helpIntervalAtMaxStage => basicProfile.maxHelpInterval;

  factory PokemonProfile.fromJson(Map<String, dynamic> json) {
    final subSkillMapping = SubSkill.values.toMap(
        (e) => e.id, (e) => e,
    );

    getIngredientById(int id) {
      return Ingredient.values.firstWhere((ingredient) => ingredient.id == id);
    }

    return PokemonProfile(
      id: json['id'],
      basicProfileId: json['basicProfileId'],
      character: PokemonCharacter.values
          .firstWhere((e) => e.id == json['characterId']),
      customName: json['customName'],
      customNote: json['customNote'],
      isFavorite: json['isFavorite'] ?? false,
      isShiny: json['isShiny'] ?? false,
      customDate: json['customDate'] == null ? null : MyTimezone.tryParseZero(json['customDate']),
      subSkillLv10: subSkillMapping[json['subSkillIds'][0]]!,
      subSkillLv25: subSkillMapping[json['subSkillIds'][1]]!,
      subSkillLv50: subSkillMapping[json['subSkillIds'][2]]!,
      subSkillLv75: subSkillMapping[json['subSkillIds'][3]]!,
      subSkillLv100: subSkillMapping[json['subSkillIds'][4]]!,
      ingredient2: getIngredientById(json['ingredient2Id']),
      ingredientCount2: json['ingredientCount2'],
      ingredient3: getIngredientById(json['ingredient3Id']),
      ingredientCount3: json['ingredientCount3'],
    );
  }

  PokemonProfile clone() {
    return PokemonProfile(
      id: id,
      basicProfileId: basicProfileId,
      character: character,
      customName: customName,
      customNote: customNote,
      isFavorite: isFavorite,
      isShiny: isShiny,
      customDate: customDate,
      subSkillLv10: subSkillLv10,
      subSkillLv25: subSkillLv25,
      subSkillLv50: subSkillLv50,
      subSkillLv75: subSkillLv75,
      subSkillLv100: subSkillLv100,
      ingredient2: ingredient2,
      ingredientCount2: ingredientCount2,
      ingredient3: ingredient3,
      ingredientCount3: ingredientCount3,
    );
  }

  PokemonProfile copyWith({
    PokemonCharacter? character,
    String? customName,
    String? customNote,
    bool? isFavorite,
    bool? isShiny,
    DateTime? customDate,
    SubSkill? subSkillLv10,
    SubSkill? subSkillLv25,
    SubSkill? subSkillLv50,
    SubSkill? subSkillLv75,
    SubSkill? subSkillLv100,
    Ingredient? ingredient2,
    int? ingredientCount2,
    Ingredient? ingredient3,
    int? ingredientCount3,
  }) {
    return PokemonProfile(
      id: id,
      basicProfileId: basicProfileId,
      character: character ?? this.character,
      customName: customName ?? this.customName,
      customNote: customNote ?? this.customNote,
      isFavorite: isFavorite ?? this.isFavorite,
      isShiny: isShiny ?? this.isShiny,
      customDate: customDate ?? this.customDate,
      subSkillLv10: subSkillLv10 ?? this.subSkillLv10,
      subSkillLv25: subSkillLv25 ?? this.subSkillLv25,
      subSkillLv50: subSkillLv50 ?? this.subSkillLv50,
      subSkillLv75: subSkillLv75 ?? this.subSkillLv75,
      subSkillLv100: subSkillLv100 ?? this.subSkillLv100,
      ingredient2: ingredient2 ?? this.ingredient2,
      ingredientCount2: ingredientCount2 ?? this.ingredientCount2,
      ingredient3: ingredient3 ?? this.ingredient3,
      ingredientCount3: ingredientCount3 ?? this.ingredientCount3,
    )..basicProfile = basicProfile;
  }

  Map<String, dynamic> toJson() {
    return {
      'basicProfileId': basicProfileId,
      'characterId': character.id,
      'customName': customName,
      'customNote': customNote,
      'isFavorite': isFavorite,
      'isShiny': isShiny,
      'customDate': customDate == null ? null : MyFormatter.date(customDate!),
      'id': id,
      'subSkillIds': subSkills.map((e) => e?.id).toList(),
      'ingredient2Id': ingredient2?.id,
      'ingredientCount2': ingredientCount2,
      'ingredient3Id': ingredient3?.id,
      'ingredientCount3': ingredientCount3,
    };
  }

  String getConstructorCode() {
    return
      'PokemonProfile(\n'
          '   id: -1,\n'
          '   basicProfileId: $basicProfileId,\n'
          '   character: $character,\n'
          '   customName: $customName,\n'
          '   customNote: $customNote,\n'
          '   isFavorite: $isFavorite, \n'
          '   isShiny: $isShiny, \n'
          '   customDate: $customDate, \n'
          '   subSkillLv10: $subSkillLv10,\n'
          '   subSkillLv25: $subSkillLv25,\n'
          '   subSkillLv50: $subSkillLv50,\n'
          '   subSkillLv75: $subSkillLv75,\n'
          '   subSkillLv100: $subSkillLv100,\n'
          '   ingredient2: $ingredient2,\n'
          '   ingredientCount2: $ingredientCount2,\n'
          '   ingredient3: $ingredient3,\n'
          '   ingredientCount3: $ingredientCount3,\n'
          ')';
  }

  String getDisplayText() {
    return customName ?? basicProfile.nameI18nKey.xTr;
  }

  String info() {
    return '';
  }

  bool get isLarvitarChain => basicProfile.isLarvitarChain;

  List<SubSkill?> getSubSkillsByLevel(int level) {
    final count = level >= 100 ? 5
        : level >= 75 ? 4
        : level >= 50 ? 3
        : level >= 25 ? 2
        : level >= 10 ? 1
        : 0;
    return subSkills.take(count).toList();
  }

  bool hasSubSkillAtLevel(SubSkill subSkill, int level) {
    return getSubSkillsByLevel(level).contains(subSkill);
  }

}