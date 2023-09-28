import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

enum _PageType {
  readonly,
  picker,
}

class _PokemonBoxPageArgs {
  _PokemonBoxPageArgs({
    required this.pageType,
  });

  final _PageType pageType;
}

class PokemonBoxPage extends StatefulWidget {
  const PokemonBoxPage._(_PokemonBoxPageArgs args): _args = args;

  static const MyPageRoute route = ('/PokemonBoxPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as _PokemonBoxPageArgs;
    return PokemonBoxPage._(args);
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
      arguments: _PokemonBoxPageArgs(
        pageType: _PageType.readonly,
      ),
    );
  }

  static void pick(BuildContext context) {
    context.nav.push(
      route,
      arguments: _PokemonBoxPageArgs(
        pageType: _PageType.picker,
      ),
    );
  }

  final _PokemonBoxPageArgs _args;

  @override
  State<PokemonBoxPage> createState() => _PokemonBoxPageState();
}

class _PokemonBoxPageState extends State<PokemonBoxPage> {
  _PokemonBoxPageArgs get _args => widget._args;

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
    const cardSpacing = 12.0;

    final cardWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: 70,
      containerWidth: mainWidth,
      spacing: cardSpacing,
    );
    final cardHeight = cardWidth * 1.318;

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
                spacing: cardSpacing,
                children: profiles.map((e) => InkWell(
                  onTap: () {
                    PokemonSliderDetailsPage.go(
                      context,
                      initialProfileId: e.id,
                    );
                  },
                  child: Container(
                    width: cardWidth,
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                      maxWidth: cardWidth,
                      minHeight: cardHeight,
                    ),
                    child: Text(
                      e.basicProfile.nameI18nKey,
                    ),
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
