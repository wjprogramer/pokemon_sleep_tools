import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class BagPage extends StatefulWidget {
  const BagPage._();

  static const MyPageRoute route = ('/BagPage', _builder);
  static Widget _builder(dynamic args) {
    return const BagPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  PokemonBasicProfileRepository get _basicProfileRepository => getIt();

  final _basicProfileIdToInstance = <int, PokemonBasicProfile>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _init();

      if (mounted) {
        setState(() { });
      }
    });
  }

  Future<void> _init() async {
    for (final evolutionItem in EvolutionGameItem.values) {
      for (final basicProfileId in evolutionItem.basicProfileIds) {
        if (_basicProfileIdToInstance[basicProfileId] != null) {
          continue;
        }

        final basicProfile = await _basicProfileRepository.getBasicProfile(basicProfileId);
        if (basicProfile == null) {
          continue;
        }
        _basicProfileIdToInstance[basicProfile.id] = basicProfile;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_bag'.xTr,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          Gap.xl,
          // 薰香
          // 進化道具
          Text('t_evolution_items'.xTr),
          ...EvolutionGameItem.values.map((evolutionItem) => <Widget>[
            Gap.xl,
            Text('# ${evolutionItem.nameI18nKey.xTr}'),
            Gap.sm,
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: _buildBasicProfiles(evolutionItem),
            ),
          ]).expand((e) => e),
          Gap.trailing,
        ],
      ),
    );
  }

  List<Widget> _buildBasicProfiles(EvolutionGameItem evolutionItem) {
    return evolutionItem.basicProfileIds
        .map((basicProfileId) => _basicProfileIdToInstance[basicProfileId])
        .whereNotNull()
        .map(_buildBasicProfileForEvolution)
        .toList();
  }

  Widget _buildBasicProfileForEvolution(PokemonBasicProfile basicProfile) {
    return Text(basicProfile.nameI18nKey.xTr);
  }
}


