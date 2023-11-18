import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/team_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

part 'pokemon_box_logic.dart';
part 'pokemon_box_view.dart';

typedef PokemonBoxSubmitCallback = dynamic Function(List<PokemonProfile?> profiles);

const _cardSpacing = 12.0;

enum _PageType {
  readonly,
  picker,
}

class _PokemonBoxPageArgs {
  _PokemonBoxPageArgs({
    required this.pageType,
    this.onConfirm,
    this.initialTeam,
    this.initialIndex,
    this.initialSearchOptions,
  });

  final _PageType pageType;
  final PokemonBoxSubmitCallback? onConfirm;
  final PokemonTeam? initialTeam;
  final int? initialIndex;
  final PokemonSearchOptions? initialSearchOptions;
// TODO: initValues, initialIndex (一開始會優先選中當個)
}

class PokemonBoxPage extends StatefulWidget {
  const PokemonBoxPage._(_PokemonBoxPageArgs args): _args = args;

  static const MyPageRoute route = ('/PokemonBoxPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as _PokemonBoxPageArgs;
    return PokemonBoxPage._(args);
  }

  static void go(BuildContext context, {
    PokemonSearchOptions? initialSearchOptions,
  }) {
    context.nav.push(
      route,
      arguments: _PokemonBoxPageArgs(
        pageType: _PageType.readonly,
        initialSearchOptions: initialSearchOptions,
      ),
    );
  }

  static Future<List<PokemonProfile?>?> pick(BuildContext context, {
    PokemonTeam? initialTeam,
    PokemonBoxSubmitCallback? onConfirm,
    int? initialIndex,
  }) async {
    final res = await context.nav.push(
      route,
      arguments: _PokemonBoxPageArgs(
        pageType: _PageType.picker,
        onConfirm: onConfirm,
        initialTeam: initialTeam,
        initialIndex: initialIndex,
      ),
    );
    return res is List<PokemonProfile?>
        ? res : null;
  }

  void _popResult(BuildContext context, List<PokemonProfile?>? result) {
    context.nav.pop(result);
  }

  final _PokemonBoxPageArgs _args;

  @override
  State<PokemonBoxPage> createState() => _PokemonBoxLogic();
}
