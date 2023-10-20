import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/game_item.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/sleep.dart';

class EvolutionsView extends StatelessWidget {
  const EvolutionsView(this.evolutions, {
    super.key,
    required this.basicProfilesInEvolutionChain,
    required this.basicProfile,
    required this.basicProfileWithSmallestBoxNoInChain,
  });

  final List<List<Evolution>> evolutions;

  /// [PokemonBasicProfile.id] to instance
  final Map<int, PokemonBasicProfile> basicProfilesInEvolutionChain;

  final PokemonBasicProfile? basicProfile;

  final PokemonBasicProfile basicProfileWithSmallestBoxNoInChain;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: _buildEvolutions(context, evolutions),
    );
  }

  Widget _buildEvolutions(BuildContext context, List<List<Evolution>> evolutionsStages) {
    List<Widget> x(int index, List<Evolution> e, Iterable<List<Evolution>> list) {
      return [
        ..._buildEvolutionStage(context, e, index == 0 ? null : evolutionsStages[index - 1]),
        if (index != list.length - 1)
          const Center(child: Icon(Icons.arrow_right)),
      ];
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: MyEnv.USE_DEBUG_IMAGE
            ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          ...evolutionsStages
              .where((element) => element.isNotEmpty)
              .xMapIndexed(x)
              .expand((e) => e),
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: greyColor2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text('測試用區塊'),
                    _buildEvolutionCondition(
                      EvolutionConditionRaw(jsonEncode({
                        'type': 'candy',
                        'count': 21,
                      })),
                    ),
                    _buildEvolutionCondition(
                      EvolutionConditionRaw(jsonEncode({
                        'type': 'level',
                        'level': 21,
                      })),
                    ),
                    _buildEvolutionCondition(
                      EvolutionConditionRaw(jsonEncode({
                        'type': 'item',
                        'item': GameItem.i21.id,
                      })),
                    ),
                    _buildEvolutionCondition(
                      EvolutionConditionRaw(jsonEncode({
                        'type': 'timing',
                        'startHour': 6,
                        'endHour': 18,
                      })),
                    ),
                    _buildEvolutionCondition(
                      EvolutionConditionRaw(jsonEncode({
                        'type': 'sleepTime',
                        'hours': 50,
                      })),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildEvolutionStage(BuildContext context, List<Evolution> evolutionsStage, List<Evolution>? preEvolution) {
    final stages = (preEvolution ?? []).map((e) => e.nextStages).expand((e) => e);
    final basicProfileIdToStage = stages.toMap((p0) => p0.basicProfileId, (stage) => stage);

    return [
      ...evolutionsStage
          .map((e) => (e, basicProfilesInEvolutionChain[e.basicProfileId]!))
          .whereNotNull()
          .map((e) => _buildEvolutionItem(context, e, basicProfileIdToStage[e.$2.id])),
    ];
  }

  Widget _buildEvolutionItem(BuildContext context, (Evolution, PokemonBasicProfile) entry, EvolutionStage? stage) {
    // final (_, basicProfile) = entry;
    final otherBasicProfile = entry.$2;
    final isCurrent = basicProfile?.id == otherBasicProfile.id;
    List<Widget> conditionsItems;

    if (stage == null) {
      conditionsItems = [];
    } else {
      conditionsItems = [];
      for (final cond in stage.conditions.whereType<EvolutionConditionRaw>()) {
        final builtCond = _buildEvolutionCondition(cond);
        if (cond.values['type'] == 'candy') {
          conditionsItems.insert(0, builtCond);
        } else {
          conditionsItems.add(builtCond);
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: isCurrent ? null : () {
          PokemonBasicProfilePage.go(context, otherBasicProfile);
        },
        child: Container(
          decoration: !MyEnv.USE_DEBUG_IMAGE ? null : BoxDecoration(
            border: Border.all(
              color: isCurrent ? positiveColor : greyColor2,
            ),
          ),
          constraints: const BoxConstraints(
            minWidth: 110,
            maxWidth: 110,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (MyEnv.USE_DEBUG_IMAGE) ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isCurrent ? positiveColor : greyColor2,
                      ),
                    ),
                    color: otherBasicProfile.pokemonType.color.withOpacity(.2),
                  ),
                  child: PokemonIconImage(
                    basicProfile: otherBasicProfile,
                    width: 100,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: conditionsItems,
                  ),
                ),
              ] else ...[
                Text(
                  otherBasicProfile.nameI18nKey.xTr,
                ),
                ...conditionsItems,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvolutionCondition(EvolutionConditionRaw condition) {
    return buildEvolutionCondition(condition, basicProfileWithSmallestBoxNoInChain);
  }
}

Widget buildEvolutionCondition(EvolutionConditionRaw condition, PokemonBasicProfile basicProfileWithSmallestBoxNoInChain, {
  MainAxisSize? mainAxisSize,
}) {
  final values = condition.values;
  Widget? leading;
  Widget? description;

  switch (values['type']) {
    case 'candy':
      leading = CandyOfPokemonIcon(
        size: 16,
        boxNo: basicProfileWithSmallestBoxNoInChain.boxNo,
      );
      description = Text(
        Display.numInt(values['count'] ?? 0),
        textAlign: TextAlign.start,
      );
      break;
    case 'level':
      leading = const LevelIcon(size: 20,);
      description = Text(
        Display.numInt(values['level'] ?? 0),
        textAlign: TextAlign.start,
      );
      break;
    case 'sleepTime':
      leading = const Iconify(
        Tabler.zzz, color: positiveColor,
        size: 20,
      );
      description = Text(
        '${Display.numInt(values['hours'] ?? 0)}小時',
        textAlign: TextAlign.start,
      );
      break;
    case 'item':
      final gameItem = GameItem.getById(values['item']);
      if (MyEnv.USE_DEBUG_IMAGE && gameItem != null) {
        leading = Padding(
          padding: const EdgeInsets.only(right: 4),
          child: GameItemImage(
            gameItem: gameItem,
            width: 16,
            disableTooltip: true,
          ),
        );
      }
      description = Text(
        Display.text(gameItem?.nameI18nKey.xTr),
        textAlign: TextAlign.start,
      );
      break;
    case 'timing':
      leading = const Icon(
        Icons.access_time_rounded, color: greenColor,
        size: 20,
      );
      description = Text(
        '${values['startHour']} ~ ${values['endHour']}',
        textAlign: TextAlign.start,
      );
      break;
  }

  return Row(
    mainAxisSize: mainAxisSize ?? MainAxisSize.max,
    children: [
      if (leading == null)
        const SizedBox(width: 32)
      else Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(
          minWidth: 32,
        ),
        child: leading,
      ),
      if (description != null)
        description,
    ],
  );
}

// "candy,level"
// "level,candy"
// "item,candy"
// "item,candy,item"
// "timing,sleepTime,candy"
// "sleepTime,candy"
// "candy,sleepTime"
// "candy,sleepTime,timing"
