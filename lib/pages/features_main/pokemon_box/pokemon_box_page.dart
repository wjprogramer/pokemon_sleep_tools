import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

class PokemonBoxPageArgs {
}

class PokemonBoxPage extends StatefulWidget {
  const PokemonBoxPage({super.key});

  static const MyPageRoute<PokemonBoxPageArgs> route = ('/PokemonBoxPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as PokemonBoxPageArgs?;
    return const PokemonBoxPage();
  }

  @override
  State<PokemonBoxPage> createState() => _PokemonBoxPageState();
}

class _PokemonBoxPageState extends State<PokemonBoxPage> {
  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      final mainViewModel = context.read<MainViewModel>();
      mainViewModel.loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;
    const pokemonCardSpacing = 12.0;

    final pokemonCardWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: 70,
      containerWidth: mainWidth,
      spacing: pokemonCardSpacing,
    );
    final pokemonCardHeight = pokemonCardWidth * 1.318;

    return Scaffold(
      appBar: buildAppBar(
        actions: [
          IconButton(
            onPressed: () {
              PokemonMaintainProfilePage.goCreate(context);
            },
            icon: const AddIcon(),
          ),
        ],
      ),
      body: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          final profiles = viewModel.profiles;

          return buildListView(
            padding: const EdgeInsets.symmetric(
              horizontal: HORIZON_PADDING,
            ),
            children: [
              Wrap(
                spacing: pokemonCardSpacing,
                children: profiles.map((e) => Container(
                  width: pokemonCardWidth,
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                    maxWidth: pokemonCardWidth,
                    minHeight: pokemonCardHeight,
                  ),
                  child: Text(
                    e.basicProfile.nameI18nKey,
                  ),
                )).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
