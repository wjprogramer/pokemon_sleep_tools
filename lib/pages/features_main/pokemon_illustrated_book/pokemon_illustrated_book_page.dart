import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/sleep_face_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';
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

  /// [PokemonBasicProfile.id] to [PokemonProfile]
  final _profileOf = <int, PokemonProfile>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();
      final profiles = await mainViewModel.loadProfiles();
      for (final profile in profiles) {
        _profileOf[profile.basicProfileId] = profile;
      }

      _basicProfiles = await _basicProfileRepo.findAll();
      _sleepFacesOf = await _sleepFaceRepo.findAllNames();

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
      body: Consumer<MainViewModel>(
        builder: (context, mainViewModel, child) {
          final profiles = mainViewModel.profiles;

          return buildListView(
            children: [
              ..._basicProfiles.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: Gap.xsV),
                child: _buildBasicProfile(e),
              )),
              Gap.trailing,
            ],
          );
        },
      ),
    );
  }

  Widget _buildBasicProfile(PokemonBasicProfile basicProfile) {
    return InkWell(
      onTap: () {
        PokemonBasicProfilePage.go(context, basicProfile);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
          vertical: 8,
        ),
        child: Row(
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
                  Text.rich(
                    TextSpan(
                      text: '#${basicProfile.boxNo} ${basicProfile.nameI18nKey.xTr}  ',
                      style: _theme.textTheme.bodyLarge,
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: PokemonTypeIcon(
                              type: basicProfile.pokemonType,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


