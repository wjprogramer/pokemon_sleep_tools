part of 'dev_pokemon_basic_profile_ingredients_combination_page.dart';

class _DevPokemonBasicProfileIngredientsCombinationLogic extends State<DevPokemonBasicProfileIngredientsCombinationPage> {
  var _theme = ThemeData();
  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;

  // Data
  var _profileResults = <StatisticsResults?>[];
  var _level = 60;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      final ingredientsOptions = _getIngredientsOptions();
      final newProfilesStaticsResults = <StatisticsResults?>[];

      for (final ingredientsOption in ingredientsOptions) {
        final ingredient2 = ingredientsOption.length >= 2 ? ingredientsOption[1] : null;
        final ingredient3 = ingredientsOption.length >= 3 ? ingredientsOption[2] : null;

        final profile = PokemonProfile(
          basicProfileId: _basicProfile.id,
          character: PokemonCharacter.c25, // 隨便挑一個無特色的性格
          subSkillLv10: null,
          subSkillLv25: null,
          subSkillLv50: null,
          subSkillLv75: null,
          subSkillLv100: null,
          ingredient2: ingredient2?.$1,
          ingredientCount2: ingredient2?.$2 ?? 0,
          ingredient3: ingredient3?.$1,
          ingredientCount3: ingredient3?.$2 ?? 0,
        )..basicProfile = _basicProfile;

        newProfilesStaticsResults.add(
          PokemonProfileStatistics(
            [ profile ],
            level: _level,
          ).calc()[0],
        );
      }

      newProfilesStaticsResults.sort((a, b) {
        final totalA = (a?.baseResult?.totalIngredientEnergyPerHour ?? 0.0) + (a?.baseResult?.fruitEnergyPerHour ?? 0.0);
        final totalB = (b?.baseResult?.totalIngredientEnergyPerHour ?? 0.0) + (b?.baseResult?.fruitEnergyPerHour ?? 0.0);
        return totalA - totalB > 0 ? -1 : 1;
      });

      _profileResults = newProfilesStaticsResults;
      if (mounted) {
        setState(() { });
      }
    });
  }

  List<List<(Ingredient, int)>> _getIngredientsOptions() {
    final options = <List<(Ingredient, int)>>[];

    final ingredientOptions2 = _level >= 30
        ? _basicProfile.ingredientOptions2
        : <(Ingredient, int)>[];
    final ingredientOptions3 = _level >= 60
        ? _basicProfile.ingredientOptions3
        : <(Ingredient, int)>[];

    if (ingredientOptions2.isEmpty) {
      return [
        [(_basicProfile.ingredient1, _basicProfile.ingredientCount1)],
      ];
    }

    for (final ingredient2 in ingredientOptions2) {
      final tmpOptions = [
        (_basicProfile.ingredient1, _basicProfile.ingredientCount1),
        ingredient2,
      ];

      if (ingredientOptions3.isNotEmpty) {
        for (final ingredient3 in ingredientOptions3) {
          print(ingredient3.$1.nameI18nKey.xTr);
          options.add([ ...tmpOptions, ingredient3 ]);
        }
      } else {
        options.add([ ...tmpOptions ]);
      }
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return _DevPokemonBasicProfileIngredientsCombinationView(this);
  }
}

