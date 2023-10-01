import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/sleep_face_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class PokemonIllustratedBookPage extends StatefulWidget {
  const PokemonIllustratedBookPage._();

  static const MyPageRoute route = ('/PokemonIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const PokemonIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PokemonIllustratedBookPage> createState() => _PokemonIllustratedBookPageState();
}

class _PokemonIllustratedBookPageState extends State<PokemonIllustratedBookPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();
  SleepFaceRepository get _sleepFaceRepo => getIt();

  // UI
  late ThemeData _theme;

  // Data
  var _basicProfiles = <PokemonBasicProfile>[];
  var _sleepFacesOf = <int, Map<int, String>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _basicProfiles = await _basicProfileRepo.findAll();
      _sleepFacesOf = await _sleepFaceRepo.findAll();

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_pokemon_illustrated_book'.xTr,
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          ..._basicProfiles.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: Gap.lgV),
            child: _buildBasicProfile(e),
          )),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildBasicProfile(PokemonBasicProfile basicProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '#${basicProfile.boxNo} ${basicProfile.nameI18nKey.xTr}',
          style: _theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}


