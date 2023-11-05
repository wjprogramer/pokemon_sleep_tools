part of 'dev_pokemon_basic_profile_ingredients_combination_page.dart';

class _DevPokemonBasicProfileIngredientsCombinationView extends WidgetView<DevPokemonBasicProfileIngredientsCombinationPage, _DevPokemonBasicProfileIngredientsCombinationLogic> {
  const _DevPokemonBasicProfileIngredientsCombinationView(_DevPokemonBasicProfileIngredientsCombinationLogic state) : super(state);

  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;
  List<StatisticsResults?> get _profileResults => s._profileResults;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '食材組合',
      ),
      body: buildListView(
        children: [
          ..._profileResults.whereNotNull().map((e) => _buildStatisticsResults(e))
              .map((e) => Hp(child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: e,
              ))),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildStatisticsResults(StatisticsResults results) {
    final ingredient1 = results.profile.ingredient1;
    final ingredient2 = results.profile.ingredient2;
    final ingredient3 = results.profile.ingredient3;

    final totalIngredientEnergyPerHour = results.baseResult?.totalIngredientEnergyPerHour ?? 0;

    final totalEnergyPerHour = totalIngredientEnergyPerHour
        + (results.baseResult?.fruitEnergyPerHour ?? 0);

    final totalIngredientEnergyFlex = (totalIngredientEnergyPerHour / totalEnergyPerHour * 1000).toInt();
    final totalFruitEnergyFlex = 1000 - totalIngredientEnergyFlex;

    final totalIngredientEnergyPerHourPercentage = 100 - totalIngredientEnergyPerHour / totalEnergyPerHour * 100;
    final longestText = _Label.values.map((e) => e.text.xTr).compareWhere((a, b) {
      return a.length > b.length;
    }) ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: greyColor2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildIngredient(ingredient1, results.profile.ingredientCount1),
              if (ingredient2 != null)
                _buildIngredient(ingredient2, results.profile.ingredientCount2),
              if (ingredient3 != null)
                _buildIngredient(ingredient3, results.profile.ingredientCount3),
              const Spacer(),
              Text.rich(
                TextSpan(
                  text: '',
                  children: [
                    TextSpan(
                      text: '能量 ',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    TextSpan(
                      text: Display.numInt(totalEnergyPerHour),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    TextSpan(
                      text: ' /小時',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap.md,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: FruitMenuIcon(
                  size: 16,
                ),
              ),
              Gap.md,
              _buildLabel(_Label.fruit, longestText: longestText),
              Gap.md,
              Expanded(
                flex: totalFruitEnergyFlex,
                child: Tooltip(
                  message: '${results.baseResult?.fruitEnergyPerHour.toStringAsFixed(2)} (${totalIngredientEnergyPerHourPercentage.toStringAsFixed(2)}%)',
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: totalIngredientEnergyFlex,
                child: Container(),
              ),
            ],
          ),
          Gap.sm,
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: IngredientMenuIcon(
                  size: 16,
                ),
              ),
              Gap.md,
              _buildLabel(_Label.ingredient, longestText: longestText),
              Gap.md,
              Expanded(
                flex: totalIngredientEnergyFlex,
                child: Tooltip(
                  message: '${results.baseResult?.totalIngredientEnergyPerHour.toStringAsFixed(2)} (${((results.baseResult?.totalIngredientEnergyPerHour ?? 0.0) / totalEnergyPerHour * 100).toStringAsFixed(2)}%)',
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: orangeColor,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: totalFruitEnergyFlex,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredient(Ingredient ingredient, int count) {
    if (MyEnv.USE_DEBUG_IMAGE) {
      return InkWell(
        onTap: () {
          IngredientPage.go(context, ingredient);
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: IngredientImage(
                ingredient: ingredient,
                size: 40,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                'x$count',
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget _buildLabel(_Label label, {
    required String longestText,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ),
          child: Opacity(
            opacity: 0,
            child: Text(longestText),
          ),
        ),
        Positioned.fill(child: Text(label.text.xTr)),
      ],
    );
  }

}

enum _Label {
  fruit('樹果'),
  ingredient('食材');

  const _Label(this.text);

  final String text;
}
