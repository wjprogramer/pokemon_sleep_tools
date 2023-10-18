import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruit/fruit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/view_models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/dish_list_tile.dart';
import 'package:provider/provider.dart';

import '../../../widgets/sleep/images/images.dart';

class _PageArgs {
  _PageArgs({
    required this.teamIndex,
  });

  final int teamIndex;
}

class TeamAnalysisPage extends StatefulWidget {
  const TeamAnalysisPage._(this._args);

  static const MyPageRoute route = ('/TeamAnalysisPage', _builder);
  static Widget _builder(dynamic args) {
    return TeamAnalysisPage._(args);
  }

  static void go(BuildContext context, int teamIndex) {
    context.nav.push(
      route,
      arguments: _PageArgs(teamIndex: teamIndex),
    );
  }

  final _PageArgs _args;

  @override
  State<TeamAnalysisPage> createState() => _TeamAnalysisPageState();
}

class _TeamAnalysisPageState extends State<TeamAnalysisPage> {
  int get _teamIndex => widget._args.teamIndex;

  // UI
  late ThemeData _theme;

  // Page status
  final _disposers = <MyDisposable>[];
  var _isInitialized = false;

  // Data
  var _profileOf = <int, PokemonProfile>{};
  PokemonTeam? _team;

  // Data (Calculated)
  final _ingredientsMapLv1 = <Ingredient, int>{};
  final _ingredientsMapLv30 = <Ingredient, int>{};
  final _ingredientsMapLv60 = <Ingredient, int>{};

  final _ingredientsAccumulateMapLv30 = <Ingredient, int>{};
  final _ingredientsAccumulateMapLv60 = <Ingredient, int>{};

  var _dishesLv1 = <Dish>{};
  var _dishesLv30 = <Dish>{};
  var _dishesLv60 = <Dish>{};

  var _fruitMapping = <Fruit, (int, List<PokemonBasicProfile>)>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mainViewModel = context.read<MainViewModel>();
      final teamViewModel = context.read<TeamViewModel>();

      _disposers.addAll([
        mainViewModel.xAddListener(_listenMainViewModel),
        teamViewModel.xAddListener(_listenTeamViewModel)
      ]);

      await Future.wait([
        mainViewModel.loadProfiles(),
        teamViewModel.loadTeams(),
      ]);

      _team = teamViewModel.teams[_teamIndex];
      _analysis();
      _isInitialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    super.dispose();
  }

  void _listenTeamViewModel() {
    final teamViewModel = context.read<TeamViewModel>();
    _team = teamViewModel.teams[_teamIndex]!;

    _analysis();
    setState(() { });
  }

  void _listenMainViewModel() {
    final mainViewModel = context.read<MainViewModel>();
    _profileOf = mainViewModel.profiles
        .toMap((profile) => profile.id, (profile) => profile);

    _analysis();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;
    final team = _team;

    if (team == null) {
      return Scaffold(
        body: Center(child: Text('t_none'.xTr)),
      );
    }

    if (!_isInitialized) {
      return LoadingView();
    }

    final profileIdList = team.profileIdList;
    final profiles = profileIdList.map((e) => _profileOf[e]).toList();
    final profilesNotNull = profiles.whereNotNull().toList();

    final dishLv30 = _dishesLv30
        .where((dish) => !_dishesLv1.contains(dish));
    final dishLv60 = _dishesLv60
        .where((dish) => !_dishesLv30.contains(dish) && !_dishesLv1.contains(dish));

    return Scaffold(
      appBar: buildAppBar(
        titleText: _getCurrTeamName(),
      ),
      body: buildListView(
        children: [
          ...Hp.list(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ...profiles.mapIndexed((index, profile) {
                    Widget child;
                    final basicProfile = profile?.basicProfile;

                    if (profile == null) {
                      child = Container();
                    } else if (MyEnv.USE_DEBUG_IMAGE) {
                      child = ClipRect(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Transform(
                            transform: Matrix4.identity()
                              ..scale(1.5),
                            child: Image.asset(
                              AssetsPath.pokemonPortrait(profile.basicProfile.boxNo),
                              errorBuilder: (context, error, stackTrace) => Container(),
                            ),
                          ),
                        ),
                      );
                    } else {
                      child = Center(child: Text(profile.basicProfile.nameI18nKey.xTr));
                    }

                    return <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 100,
                              child: InkWell(
                                onTap: () {
                                  final profile = profiles[index];
                                  if (profile == null) {
                                    return;
                                  }

                                  PokemonSliderDetailsPage.go(
                                    context,
                                    initialProfileId: profile.id,
                                    initialProfileIds: profilesNotNull.map((e) => e.id).toList(),
                                  );
                                },
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                  ),
                                  child: child,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                profile?.basicProfile.nameI18nKey.xTr ?? '',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (basicProfile != null) ...[
                              Text(
                                basicProfile.specialty.nameI18nKey.xTr,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (index != profiles.lastIndex)
                        Gap.md,
                    ];
                  }).expand((e) => e),
                ],
              ),
              MySubHeader(
                titleText: 't_fruits'.xTr,
              ),
            ],
          ),
          ..._fruitMapping.entries.map((e) {
            final fruit = e.key;
            final data = e.value;
            final fruitCount = data.$1;
            final basicProfiles = data.$2;

            return InkWell(
              onTap: () {
                FruitPage.go(context, fruit);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Gap.h,
                    if (MyEnv.USE_DEBUG_IMAGE)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FruitImage(
                          fruit: fruit,
                          width: 32,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        '${fruit.nameI18nKey.xTr} x$fruitCount: ${basicProfiles.map((e) => e.nameI18nKey.xTr).join('t_separator'.xTr)}',
                      ),
                    ),
                    Gap.h,
                  ],
                ),
              ),
            );
          }),
          ...Hp.list(
            children: [
              // TODO:
              // MySubHeader(
              //   titleText: '樹果 & 適合島嶼'.xTr,
              // ),
              MySubHeader(
                titleText: 't_ingredients'.xTr,
              ),
              ..._buildIngredient(1, _ingredientsMapLv1),
              ..._buildIngredient(30, _ingredientsMapLv30),
              ..._buildIngredient(60, _ingredientsMapLv60),
              MySubHeader(
                titleText: '食材（累計）'.xTr,
              ),
              ..._buildIngredient(1, _ingredientsAccumulateMapLv30, endLevel: 30),
              ..._buildIngredient(1, _ingredientsAccumulateMapLv60, endLevel: 60),
              MySubHeader(
                titleText: '可作料理'.xTr,
              ),
              Text('僅列出完全符合所需食材的料理'),
            ],
          ),
          Gap.xl,
          Hp(
            child: _buildTextWithComment(
              'Lv 1 可作料理',
              comment: ' (假設隊伍寶可夢都介於 Lv 1 ~ 29)',
            ),
          ),
          if (_dishesLv1.isEmpty)
            Hp(child: Text('t_none'.xTr))
          else ..._dishesLv1.map((dish) => _buildDishListTile(
            dish: dish,
          )),
          Gap.xl,
          Hp(
            child: _buildTextWithComment(
              'Lv 30 可作料理',
              comment: ' (假設隊伍寶可夢都介於 Lv 30 ~ 59)',
            ),
          ),
          if (dishLv30.isEmpty)
            Hp(child: Text('t_none'.xTr))
          else ...dishLv30.map((dish) => _buildDishListTile(
            dish: dish,
          )),
          Gap.xl,
          Hp(
            child: _buildTextWithComment(
              'Lv 60 可作料理',
              comment: ' (假設全寶可夢 Lv 60 以上)',
            ),
          ),
          if (dishLv60.isEmpty)
            Hp(child: Text('t_none'.xTr))
          else ...dishLv60.map((dish) => _buildDishListTile(
            dish: dish,
          )),
          Gap.trailing,
        ]
      ),
    );
  }

  Widget _buildDishListTile({
    required Dish dish,
  }) {
    return InkWell(
      onTap: () {
        DishPage.go(context, dish);
      },
      child: DishListTile(
        dish: dish,
        ingredients: dish.getIngredients(),
      ),
    );
  }

  Widget _buildTextWithComment(String title, {
    String? comment
  }) {
    return Text.rich(
      TextSpan(
        text: '',
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
            ),
          ),
          TextSpan(
            text: comment,
            style: _theme.textTheme.bodySmall?.copyWith(
              color: greyColor2,
            ),
          ),
        ],
      ),
    );
  }

  void _analysis() {
    final team = _team;
    if (team == null) {
      return;
    }
    
    final profileIdList = team.profileIdList;
    final profiles = profileIdList.map((e) => _profileOf[e]).toList();
    final profilesNotNull = profiles.whereNotNull().toList();

    addIngredientCount(Map<Ingredient, int> mapping, Ingredient ingredient, int count) {
      mapping[ingredient] = (mapping[ingredient] ?? 0) + count;
    }
    _fruitMapping = {};
    _ingredientsMapLv1.clear();
    _ingredientsMapLv30.clear();
    _ingredientsMapLv60.clear();
    _ingredientsAccumulateMapLv30.clear();
    _ingredientsAccumulateMapLv60.clear();

    for (final profile in profilesNotNull) {
      final fruit = profile.basicProfile.fruit;
      final fruitData = _fruitMapping[fruit] ?? (0, []);
      _fruitMapping[fruit] = (fruitData.$1 + 1, [...fruitData.$2, profile.basicProfile]);

      addIngredientCount(_ingredientsMapLv1, profile.ingredient1, profile.ingredientCount1);
      addIngredientCount(_ingredientsMapLv30, profile.ingredient2, profile.ingredientCount2);
      addIngredientCount(_ingredientsMapLv60, profile.ingredient3, profile.ingredientCount3);

      addIngredientCount(_ingredientsAccumulateMapLv30, profile.ingredient1, profile.ingredientCount1);
      addIngredientCount(_ingredientsAccumulateMapLv30, profile.ingredient2, profile.ingredientCount2);

      addIngredientCount(_ingredientsAccumulateMapLv60, profile.ingredient1, profile.ingredientCount1);
      addIngredientCount(_ingredientsAccumulateMapLv60, profile.ingredient2, profile.ingredientCount2);
      addIngredientCount(_ingredientsAccumulateMapLv60, profile.ingredient3, profile.ingredientCount3);
    }

    Map<Dish, List<Ingredient>> initDishAndRemainIngredients(List<Dish> dishes) {
      return dishes.toMap(
            (dish) => dish,
            (dish) => dish.getIngredients().map((e) => e.$1).toList(),
      );
    }

    getAvaiableCookDishes(
      Iterable<Ingredient> ingredients,
      List<Dish> allDishes,
    ) {
      final dishAndRemainIngredients = initDishAndRemainIngredients(allDishes);

      for (final ingredient in ingredients) {
        for (final dish in dishAndRemainIngredients.keys) {
          final remainIngredients = dishAndRemainIngredients[dish]!;
          if (remainIngredients.contains(ingredient)) {
            remainIngredients.remove(ingredient);
          }
        }
      }
      return dishAndRemainIngredients.entries
          .where((e) => e.value.isEmpty)
          .map((e) => e.key)
          .toList();
    }

    // Find can cook dishes
    final dishesLv60 = getAvaiableCookDishes(
      _ingredientsAccumulateMapLv60.entries.map((e) => e.key),
      Dish.values.where((e) => e.getIngredients().isNotEmpty).toList(),
    );
    _dishesLv60 = { ...dishesLv60 };

    final dishesLv30 = getAvaiableCookDishes(
        _ingredientsAccumulateMapLv30.entries.map((e) => e.key), dishesLv60);
    _dishesLv30 = { ...dishesLv30 };

    _dishesLv1 = {
      ...getAvaiableCookDishes(
          _ingredientsMapLv1.entries.map((e) => e.key), dishesLv30)
    };
  }

  List<Widget> _buildIngredient(int level, Map<Ingredient, int> ingredientMapping, {
    int? endLevel,
  }) {
    var title = 'Lv. $level';
    if (endLevel != null) {
      title += ' - $endLevel';
    }

    wrapLabel({
      required Widget child,
      required Ingredient ingredient,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          IngredientPage.go(context, ingredient);
        },
        child: child,
      );
    }

    return [
      Text(title),
      Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          if (!MyEnv.USE_DEBUG_IMAGE) ...ingredientMapping.entries.map((e) =>
              wrapLabel(
                child: Text('${e.key.nameI18nKey.xTr} x${e.value}'),
                ingredient: e.key,
              )
          ) else ...ingredientMapping.entries.map((ingredientCount) => wrapLabel(
            ingredient: ingredientCount.key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IngredientImage(
                    ingredient: ingredientCount.key,
                    width: 32,
                  ),
                  Text('${ingredientCount.key.nameI18nKey.xTr} x${ingredientCount.value}'),
                ],
              ),
            ),
          )),
        ],
      ),
      Gap.xl,
    ];
  }

  String _getCurrTeamName() {
    return _team?.getDisplayText(index: _teamIndex)
        ?? PokemonTeam.getDefaultName(index: _teamIndex);
  }

}


