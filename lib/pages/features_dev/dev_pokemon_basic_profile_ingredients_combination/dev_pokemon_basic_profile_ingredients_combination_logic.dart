part of 'dev_pokemon_basic_profile_ingredients_combination_page.dart';

class _DevPokemonBasicProfileIngredientsCombinationLogic extends State<DevPokemonBasicProfileIngredientsCombinationPage> {
  var _theme = ThemeData();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return _DevPokemonBasicProfileIngredientsCombinationView(this);
  }
}
