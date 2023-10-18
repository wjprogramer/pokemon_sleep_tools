import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish/dish_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/view_models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
import 'package:provider/provider.dart';

class _IngredientPageArgs {
  _IngredientPageArgs(this.ingredient);

  final Ingredient ingredient;
}

class IngredientPage extends StatefulWidget {
  const IngredientPage._(this._args);

  static const MyPageRoute route = ('/IngredientPage', _builder);
  static Widget _builder(dynamic args) {
    return IngredientPage._(args);
  }

  static void go(BuildContext context, Ingredient ingredient) {
    context.nav.push(
      route,
      arguments: _IngredientPageArgs(ingredient),
    );
  }

  final _IngredientPageArgs _args;

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  Ingredient get _ingredient => widget._args.ingredient;
  String get _titleText => _ingredient.nameI18nKey.xTr;

  // UI
  late ThemeData _theme;

  // Page
  var _initialized = false;
  final _disposers = <MyDisposable>[];

  // Data
  final _dishList = <Dish>[];
  final _dishIngredientsOf = <Dish, List<(Ingredient, int)>>{};
  var _basicProfiles = <PokemonBasicProfile>[];

  /// [PokemonBasicProfile.id] to [PokemonProfile]
  var _profileOf = <int, PokemonProfile>{};

  var _currPokemonLevel = 1;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();

      _disposers.addAll([
        mainViewModel.xAddListener(_listenMainViewModel),
      ]);

      final profiles = await mainViewModel.loadProfiles();
      _profileOf = {};
      for (final profile in profiles) {
        _profileOf[profile.basicProfileId] = profile;
      }

      _basicProfiles = (await _basicProfileRepo.findAll()).where((basicProfile) {
        return basicProfile.ingredient1 == _ingredient ||
            [
              ...basicProfile.ingredientOptions2.map((e) => e.$1),
              ...basicProfile.ingredientOptions3.map((e) => e.$1),
            ].contains(_ingredient);
      }).toList()..sort((a, b) {
        if (a.ingredient1 == b.ingredient1) { return 0; }
        return a.ingredient1 == _ingredient ? -1 : 1;
      });

      for (final dish in Dish.values) {
        final ingredients = dish.getIngredients();
        final dishContainsTargetIngredient = ingredients.any((pair) => pair.$1 == _ingredient);
        if (!dishContainsTargetIngredient) {
          continue;
        }

        _dishList.add(dish);
        _dishIngredientsOf[dish] = ingredients;
      }

      _initialized = true;
      print(12);
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

  void _listenMainViewModel() {
    final mainViewModel = context.read<MainViewModel>();
    _profileOf = mainViewModel.profiles
        .toMap((profile) => profile.basicProfileId, (profile) => profile);

    if (mounted) {
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;

    if (!_initialized) {
      return LoadingView(titleText: _titleText);
    }

    return Scaffold(
      appBar: buildAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (MyEnv.USE_DEBUG_IMAGE)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IngredientImage(
                  ingredient: _ingredient,
                  width: 25,
                ),
              ),
            Text(_titleText),
          ],
        )
      ),
      body: buildListView(
        children: [
          ...Hp.list(
            children: [
              Row(
                children: [
                  EnergyIcon(),
                  Gap.xl,
                  Text(
                    Display.numInt(_ingredient.energy),
                  ),
                ],
              ),
              Gap.md,
              Row(
                children: [
                  DreamChipIcon(),
                  Gap.xl,
                  Text(
                    Display.numInt(_ingredient.dreamChips),
                  ),
                ],
              ),
              MySubHeader(
                titleText: 't_food'.xTr,
              ),
            ],
          ),
          if (_dishList.isEmpty)
            Hp(child: Text('t_none'.xTr),)
          else ..._dishList.map((dish) => InkWell(
            onTap: () {
              DishPage.go(context, dish);
            },
            child: DishListTile(
              dish: dish,
              ingredients: _dishIngredientsOf[dish] ?? [],
            )
          )),
          ...Hp.list(
            children: [
              MySubHeader(
                titleText: 't_set_pokemon_level'.xTr,
              ),
              SliderWithButtons(
                value: _currPokemonLevel.toDouble(),
                onChanged: (v) {
                  _currPokemonLevel = v.toInt();
                  setState(() { });
                },
                max: 60,
                min: 1,
                divisions: 59,
              ),
              Gap.md,
              Row(
                children: [
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 1;
                        setState(() { });
                      },
                      child: Text('Lv 1'),
                    ),
                  ),
                  Gap.md,
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 30;
                        setState(() { });
                      },
                      child: Text('Lv 30'),
                    ),
                  ),
                  Gap.md,
                  Expanded(
                    child: MyElevatedButton(
                      onPressed: () {
                        _currPokemonLevel = 60;
                        setState(() { });
                      },
                      child: Text('Lv 60'),
                    ),
                  ),
                ],
              ),
              Gap.sm,
              Divider(),
              Gap.sm,
              MySubHeader(
                titleText: 't_hold_someone_pokemon'.trParams({
                  'someone': _ingredient.nameI18nKey.xTr,
                }),
              ),
            ],
          ),
          ..._basicProfiles
              .map((e) => _buildBasicProfile(e)),
          Gap.trailing,
        ],
      ),
    );
  }

  /// TODO: 需要計算各種組合的能量
  ///     例如
  ///     [PokemonBasicProfile.ingredientOptions2] 的第一個，配上 [PokemonBasicProfile.ingredientOptions3] 第一個
  ///     [PokemonBasicProfile.ingredientOptions2] 的第一個，配上 [PokemonBasicProfile.ingredientOptions3] 第二個
  ///     然後各種組合的差異數值 （攻略網站：同一種寶可夢不同組合，會有不同的間隔時間、能量）
  ///     https://pks.raenonx.cc/ingredient/3
  ///
  Widget _buildBasicProfile(PokemonBasicProfile basicProfile) {
    return Hp(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Opacity(
            opacity: _profileOf[basicProfile.id] != null ? 1 : 0,
            child: const Padding(
              padding: EdgeInsets.only(right: Gap.mdV),
              child: PokemonRecordedIcon(),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap.sm,
                Text(basicProfile.nameI18nKey.xTr),
                Row(
                  children: [
                    const Text('Lv 1.'),
                    _buildIngredientLabel(basicProfile.ingredient1),
                  ],
                ),
                if (_currPokemonLevel >= 30)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      children: [
                        const Text('Lv 30.'),
                        ...basicProfile.ingredientOptions2.map((e) => _buildIngredientLabel(e.$1)),
                      ],
                    ),
                  ),
                if (_currPokemonLevel >= 60)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Text('Lv 60.'),
                        Expanded(
                          child: Wrap(
                            spacing: 4,
                            children: basicProfile.ingredientOptions3.map((e) => _buildIngredientLabel(e.$1)).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                Gap.md
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              PokemonBasicProfilePage.go(context, basicProfile);
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientLabel(Ingredient ingredient) {
    final sameIngredient = _ingredient == ingredient;

    return IngredientLabel(
      sameIngredient: sameIngredient,
      ingredient: ingredient,
      onTap: sameIngredient ? null : () {
        IngredientPage.go(context, ingredient);
      },
    );
  }
}


