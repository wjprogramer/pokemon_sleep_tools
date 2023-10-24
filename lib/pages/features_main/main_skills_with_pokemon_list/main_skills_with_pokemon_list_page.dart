import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';

class MainSkillsWithPokemonListPage extends StatefulWidget {
  const MainSkillsWithPokemonListPage._();

  static const MyPageRoute route = ('/MainSkillsWithPokemonListPage', _builder);
  static Widget _builder(dynamic args) {
    return const MainSkillsWithPokemonListPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<MainSkillsWithPokemonListPage> createState() => _MainSkillsWithPokemonListPageState();
}

class _MainSkillsWithPokemonListPageState extends State<MainSkillsWithPokemonListPage> {
  PokemonBasicProfileRepository get _pokemonBasicProfileRepo => getIt();

  // Page
  var _isInitialized = false;

  // Data
  var _mainSkills = MainSkill.values;
  var _mainSkillToPokemonMap = <MainSkill, List<PokemonBasicProfile>>{};

  @override
  void initState() {
    super.initState();
    _mainSkills = _mainSkills.sorted((a, b) => a.type.compareTo(b.type));
    _mainSkillToPokemonMap = MainSkill.values.toMap(
          (mainSkill) =>
          mainSkill, (mainSkill) => [],
    );

    scheduleMicrotask(() async {
      final basicProfiles = await _pokemonBasicProfileRepo.findAll();
      for (final basicProfile in basicProfiles) {
        _mainSkillToPokemonMap[basicProfile.mainSkill]!.add(basicProfile);
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const LoadingView();
    }

    const pokemonSize = 36.0;

    return Scaffold(
      appBar: buildAppBar(
        titleText: '主技能與寶可夢列表'.xTr,
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.hV,
        ),
        children: [
          ..._mainSkills.map((mainSkill) {
            final basicProfiles = _mainSkillToPokemonMap[mainSkill]!;

            return <Widget>[
              MySubHeader(
                titleText: mainSkill.nameI18nKey.xTr,
                color: mainSkill.color,
              ),
              Gap.sm,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: basicProfiles.map((basicProfile) => SizedBox(
                  width: pokemonSize,
                  height: pokemonSize,
                  child: InkWell(
                    onTap: () {
                      PokemonBasicProfilePage.go(context, basicProfile);
                    },
                    child: PokemonIconBorderedImage(
                      basicProfile: basicProfile,
                      width: pokemonSize,
                    ),
                  ),
                )).toList(),
              ),
              Gap.md,
            ];
          }).expand((e) => e),
        ],
      ),
    );
  }
}


