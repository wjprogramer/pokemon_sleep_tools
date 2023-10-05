import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/main/pokemon_basic_profile_repository.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class _MainSkillPageArgs {
  _MainSkillPageArgs(this.mainSkill);

  final MainSkill mainSkill;
}

class MainSkillPage extends StatefulWidget {
  const MainSkillPage._(_MainSkillPageArgs args): _args = args;

  static const MyPageRoute route = ('/MainSkillPage', _builder);
  static Widget _builder(dynamic args) {
    return MainSkillPage._(args);
  }

  static void go(BuildContext context, MainSkill mainSkill) {
    context.nav.push(
      route,
      arguments: _MainSkillPageArgs(
        mainSkill,
      ),
    );
  }

  final _MainSkillPageArgs _args;

  @override
  State<MainSkillPage> createState() => _MainSkillPageState();
}

class _MainSkillPageState extends State<MainSkillPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  _MainSkillPageArgs get _args => widget._args;

  String get _titleText => _args.mainSkill.nameI18nKey.xTr;

  // Page status
  bool _initialized = false;

  // Data
  late List<PokemonBasicProfile> _basicProfiles;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();

      _initialized = true;
      _basicProfiles = (await _basicProfileRepo.findAll())
          .where((basicProfile) => basicProfile.mainSkill == _args.mainSkill)
          .toList();

      await mainViewModel.loadProfiles();

      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return LoadingView(titleText: _titleText);
    }

    return Consumer<MainViewModel>(
      builder: (context, mainViewModel, child) {
        final profiles = mainViewModel.profiles
            .where((profile) => profile.basicProfile.mainSkill == _args.mainSkill)
            .toList();

        return Scaffold(
          appBar: buildAppBar(
            titleText: _titleText,
          ),
          body: buildListView(
            children: [
              Hp(
                child: MySubHeader(
                  titleText: 't_pokemon_illustrated_book'.xTr,
                ),
              ),
              if (_basicProfiles.isEmpty)
                Hp(child: Text('t_none'.xTr))
              else
                ..._basicProfiles.map((basicProfile) => _buildPokemonCard(
                  basicProfile: basicProfile,
                  profile: null,
                )),
              Hp(
                child: MySubHeader(
                  titleText: 't_pokemon_box'.xTr,
                ),
              ),
              if (profiles.isEmpty)
                Hp(child: Text('t_none'.xTr))
              else
                ...profiles.map((profile) => _buildPokemonCard(
                  basicProfile: profile.basicProfile,
                  profile: profile,
                )),
              Gap.trailing,
            ],
          ),
        );
      },
    );
  }

  Widget _buildPokemonCard({
    required PokemonProfile? profile,
    required PokemonBasicProfile basicProfile,
  }) {
    return InkWell(
      onTap: () {
        if (profile != null) {
          PokemonSliderDetailsPage.go(context, initialProfileId: profile.id);
        } else {
          PokemonBasicProfilePage.go(context, basicProfile);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
          vertical: 6,
        ),
        child: Text(
          basicProfile.nameI18nKey.xTr,
        ),
      ),
    );
  }

}


