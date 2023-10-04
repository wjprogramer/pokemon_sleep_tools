import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class PotPage extends StatefulWidget {
  const PotPage._();

  static const MyPageRoute route = ('/PotPage', _builder);
  static Widget _builder(dynamic args) {
    return const PotPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<PotPage> createState() => _PotPageState();
}

class _PotPageState extends State<PotPage> {

  // Page status
  var _initialized = false;

  // Data
  final _dishesOfPotCapacity = <int, List<Dish>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      // Init
      for (final potCapacity in POT_CAPACITIES_OPTIONS) {
        _dishesOfPotCapacity[potCapacity] = [];
      }

      // Load
      final tmpDishes = [...Dish.values];
      for (var i = 0; i < POT_CAPACITIES_OPTIONS.length; i++) {
        _dishesOfPotCapacity[POT_CAPACITIES_OPTIONS[i]] =
            tmpDishes.xRemoveWhere((dish) => dish.capacity < POT_CAPACITIES_OPTIONS[i]);
      }

      // Complete
      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return LoadingView();
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_pot'.xTr,
      ),
      body: buildListView(
        children: [],
      ),
    );
  }
}


