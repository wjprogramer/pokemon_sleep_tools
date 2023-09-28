import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

class _PokemonSliderDetailsPageArgs {
  _PokemonSliderDetailsPageArgs({
    this.initialProfileId,
  });

  final int? initialProfileId;
}

class PokemonSliderDetailsPage extends StatefulWidget {
  const PokemonSliderDetailsPage._({
    required _PokemonSliderDetailsPageArgs args,
  }) : _args = args;

  static MyPageRoute<void> route = ('/PokemonSliderDetailsPage', (dynamic args) => PokemonSliderDetailsPage._(
    args: args as _PokemonSliderDetailsPageArgs,
  ));

  static go(BuildContext context, {
    int? initialProfileId,
  }) {
    context.nav.push(
      PokemonSliderDetailsPage.route,
      arguments: _PokemonSliderDetailsPageArgs(
        initialProfileId: initialProfileId,
      ),
    );
  }

  final _PokemonSliderDetailsPageArgs _args;

  @override
  State<PokemonSliderDetailsPage> createState() => _PokemonSliderDetailsPageState();
}

class _PokemonSliderDetailsPageState extends State<PokemonSliderDetailsPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    scheduleMicrotask(() {
      final mainViewModel = context.read<MainViewModel>();
      mainViewModel.loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          final profiles = viewModel.profiles;

          return PageView(
            controller: _pageController,
            children: profiles.map((profile) => _PokemonDetailsView(
              profile: profile,
            )).toList(),
          );
        }
      ),
    );
  }
}

class _PokemonDetailsView extends StatelessWidget {
  const _PokemonDetailsView({
    super.key,
    required this.profile
  });

  final PokemonProfile profile;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}




