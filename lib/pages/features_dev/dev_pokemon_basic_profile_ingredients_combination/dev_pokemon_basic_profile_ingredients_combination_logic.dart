part of 'dev_pokemon_basic_profile_ingredients_combination_page.dart';

class _DevPokemonBasicProfileIngredientsCombinationLogic extends State<DevPokemonBasicProfileIngredientsCombinationPage> {
  var _theme = ThemeData();
  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;

  // Data
  var _profiles = <PokemonProfile>[];
  var _level = 1;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _basicProfile.ingredientOptions2;
      // _profiles = ;
    });
  }



  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return _DevPokemonBasicProfileIngredientsCombinationView(this);
  }
}

class _IngredientOptions {

}
