import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_basic_profile_ingredients_combination/dev_pokemon_basic_profile_ingredients_combination_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skill/main_skill_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/map/map_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/specialty_info/specialty_info_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/sleep_face_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:provider/provider.dart';

part 'pokemon_basic_profile_logic.dart';
part 'pokemon_basic_profile_view.dart';

class _PokemonBasicProfilePageArgs {
  _PokemonBasicProfilePageArgs(this.basicProfile, {
    this.isView = false,
  });

  final PokemonBasicProfile basicProfile;
  final bool isView;
}

/// TODO: 妙蛙種子#1，食材機率 25.63% (1:3.902)
/// TODO: 反查寶可夢盒
///
/// 攻略網站：會附上各種睡姿的圖片、
class PokemonBasicProfilePage extends StatefulWidget {
  const PokemonBasicProfilePage._(this._args);

  static const MyPageRoute route = ('/PokemonBasicProfilePage', _builder);
  static Widget _builder(dynamic args) {
    return PokemonBasicProfilePage._(args);
  }

  static void go(BuildContext context, PokemonBasicProfile basicProfile) {
    context.nav.push(
      route,
      arguments: _PokemonBasicProfilePageArgs(basicProfile),
    );
  }

  static Widget buildView(PokemonBasicProfile basicProfile) {
    return PokemonBasicProfilePage._(
      _PokemonBasicProfilePageArgs(
        basicProfile, isView: true,
      ),
    );
  }

  final _PokemonBasicProfilePageArgs _args;

  @override
  State<PokemonBasicProfilePage> createState() => _PokemonBasicProfileLogic();
}
