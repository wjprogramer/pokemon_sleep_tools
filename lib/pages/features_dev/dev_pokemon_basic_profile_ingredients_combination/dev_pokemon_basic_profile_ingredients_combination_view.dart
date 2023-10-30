part of 'dev_pokemon_basic_profile_ingredients_combination_page.dart';

class _DevPokemonBasicProfileIngredientsCombinationView extends WidgetView<DevPokemonBasicProfileIngredientsCombinationPage, _DevPokemonBasicProfileIngredientsCombinationLogic> {
  const _DevPokemonBasicProfileIngredientsCombinationView(_DevPokemonBasicProfileIngredientsCombinationLogic state) : super(state);

  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '食材組合',
      ),
    );
  }
}
