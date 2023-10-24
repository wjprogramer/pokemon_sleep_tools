import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';

class IngredientListRarityPage extends StatefulWidget {
  const IngredientListRarityPage._();

  static const MyPageRoute route = ('/IngredientListRarityPage', _builder);
  static Widget _builder(dynamic args) {
    return const IngredientListRarityPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<IngredientListRarityPage> createState() => _IngredientListRarityPageState();
}

class _IngredientListRarityPageState extends State<IngredientListRarityPage> {

  ///
  /// Filter 選項作用到全域 （只考慮一等、考慮 1 到 30 等、只考慮 30 等、....）
  ///
  /// 圖表
  /// 1. 具有該食材的寶可夢 / 全部寶可夢
  ///
  /// - 做各個食材 Lv1、Lv30、Lv60 所具有最「多」（要考慮數量）該樣食材的寶可夢排行榜；
  ///   顯示這些篩選出來的寶可夢，平均產量
  /// - 各食材
  ///

  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  // Page status
  var _isInitialized = false;

  // Base data (不會變動)
  /// [PokemonBasicProfile.id] to [PokemonBasicProfile]
  var _basicProfileOf = <int, PokemonBasicProfile>{};

  // Result data
  final _ingredientDataOf = <Ingredient, _IngredientData>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      for (final ingredient in Ingredient.values) {
        _ingredientDataOf[ingredient] = _IngredientData(ingredient);
      }

      _basicProfileOf = await _basicProfileRepo.findAllMapping();
      for (final basicProfileEntry in _basicProfileOf.entries) {
        final basicProfile = basicProfileEntry.value;

        // Lv 1
        _ingredientDataOf[basicProfile.ingredient1]!
            .basicProfilesLv1.add(basicProfile);

        // Lv 30
        final tmpIngredients = <Ingredient>{};
        for (final option in basicProfile.ingredientOptions2) {
          tmpIngredients.add(option.$1);
        }
        for (final ingredient in tmpIngredients) {
          _ingredientDataOf[ingredient]!.basicProfilesLv30.add(basicProfile);
        }

        // Lv 60
        tmpIngredients.clear();
        for (final option in basicProfile.ingredientOptions3) {
          tmpIngredients.add(option.$1);
        }
        for (final ingredient in tmpIngredients) {
          _ingredientDataOf[ingredient]!.basicProfilesLv60.add(basicProfile);
        }
      }

      for (final ingredient in Ingredient.values) {
        _ingredientDataOf[ingredient]!.refresh();
      }

      _isInitialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const LoadingView();
    }

    final ingredientList = _ingredientDataOf.entries.map((e) => e.value).sorted((a, b) {
      return a.basicProfilesRegardlessLevel.length - b.basicProfilesRegardlessLevel.length;
    });

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_ingredient_rarity'.xTr,
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          ...ingredientList.map((e) => _buildItem(e)),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildItem(_IngredientData data) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 8
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: greyColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (MyEnv.USE_DEBUG_IMAGE)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IngredientImage(
                    ingredient: data.ingredient,
                    width: 32,
                    disableTooltip: true,
                  ),
                ),
              Expanded(child: Text(data.ingredient.nameI18nKey.xTr)),
              Text.rich(
                TextSpan(
                  text: '${data.basicProfilesRegardlessLevel.length}',
                  children: [
                    TextSpan(
                      text: ' / ${_basicProfileOf.length}',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap.sm,
          _progressBar(
            data.basicProfilesRegardlessLevel.length,
            _basicProfileOf.length,
          ),
          Gap.sm,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (MyEnv.USE_DEBUG_IMAGE)
                  ...data.basicProfilesRegardlessLevel.take(10).map((basicProfile) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => PokemonBasicProfilePage.go(context, basicProfile),
                      child: PokemonIconBorderedImage(
                        basicProfile: basicProfile,
                        width: 48,
                      ),
                    ),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar(int value, int maxValue) {
    final borderRadius = BorderRadius.circular(6);

    return Container(
      width: double.infinity,
      height: 6,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: greyColor,
      ),
      child: Row(
        children: [
          Expanded(
            flex: value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: borderRadius,
              ),
            ),
          ),
          Expanded(
            flex: (maxValue - value).clamp(0, maxValue),
            child: Container(),
          ),
        ],
      ),
    );
  }

}

class _IngredientData {
  _IngredientData(this.ingredient);

  Ingredient ingredient;

  /// Lv 1 具有該食材的寶可夢
  /// sort by ingredient count, boxNo
  List<PokemonBasicProfile> basicProfilesLv1 = [];

  /// Lv 30 具有該食材的寶可夢
  /// sort by ingredient count, boxNo
  List<PokemonBasicProfile> basicProfilesLv30 = [];

  /// Lv 60 具有該食材的寶可夢
  /// sort by ingredient count, boxNo
  List<PokemonBasicProfile> basicProfilesLv60 = [];

  /// 不限等級，具有該食材的寶可夢
  /// TODO: sort?
  /// sort by ingredient count, boxNo
  List<PokemonBasicProfile> _basicProfilesRegardlessLevel = [];
  List<PokemonBasicProfile> get basicProfilesRegardlessLevel => _basicProfilesRegardlessLevel;
  List<PokemonBasicProfile> _getBasicProfilesRegardlessLevel() {
    final basicProfiles = [
      ...basicProfilesLv1,
      ...basicProfilesLv30,
      ...basicProfilesLv60,
    ];
    final mapping = <int, PokemonBasicProfile>{};
    for (final basicProfile in basicProfiles) {
      mapping[basicProfile.id] = basicProfile;
    }
    return mapping.entries.map((e) => e.value).toList()
      ..sort((a, b) => _compareBasicProfile(a, b, _SortType.regardlessLevel));
  }

  void refresh() {
    _basicProfilesRegardlessLevel = _getBasicProfilesRegardlessLevel();
    basicProfilesLv1.sort((a, b) => _compareBasicProfile(a, b, _SortType.lv1));
    basicProfilesLv30.sort((a, b) => _compareBasicProfile(a, b, _SortType.lv30));
    basicProfilesLv60.sort((a, b) => _compareBasicProfile(a, b, _SortType.lv60));
  }

  int _compareBasicProfile(PokemonBasicProfile a, PokemonBasicProfile b, _SortType sortType) {
    // Lv 1, 30, 60
    var aCounts = List.generate(3, (index) => 0);
    var bCounts = List.generate(3, (index) => 0);

    void process(bool isA, PokemonBasicProfile profile) {
      final counts = isA ? aCounts : bCounts;
      if (profile.ingredient1 == ingredient) {
        counts[0] = profile.ingredientCount1;
      }
      for (final option in profile.ingredientOptions2) {
        if (option.$1 == ingredient && option.$2 > counts[1]) {
          counts[1] = option.$2;
        }
      }
      for (final option in profile.ingredientOptions3) {
        if (option.$1 == ingredient && option.$2 > counts[2]) {
          counts[2] = option.$2;
        }
      }
    }

    process(true, a);
    process(false, b);

    var compareCountRes = switch (sortType) {
      _SortType.lv1 => bCounts[0] - aCounts[0],
      _SortType.lv30 => bCounts[1] - aCounts[1],
      _SortType.lv60 => bCounts[2] - aCounts[2],
      _SortType.regardlessLevel => bCounts.xSum() - aCounts.xSum()
    };

    if (compareCountRes != 0) {
      return compareCountRes;
    }

    return a.boxNo - b.boxNo;
  }

}

enum _SortType {
  lv1,
  lv30,
  lv60,
  regardlessLevel,
}


