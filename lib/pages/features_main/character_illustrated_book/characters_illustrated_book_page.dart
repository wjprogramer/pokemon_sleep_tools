import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

/// TODO: (Idea) 反查寶可夢盒的對應性格寶可夢 [PokemonBoxPage] (可以帶入初始查詢(篩選)條件)
class CharactersIllustratedBookPage extends StatefulWidget {
  const CharactersIllustratedBookPage._();

  static const MyPageRoute route = ('/CharactersIllustratedBookPage', _builder);
  static Widget _builder(dynamic args) {
    return const CharactersIllustratedBookPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<CharactersIllustratedBookPage> createState() => _CharactersIllustratedBookPageState();
}

class _CharactersIllustratedBookPageState extends State<CharactersIllustratedBookPage> {

  // UI
  late ThemeData _theme;
  double _characterWidth = 100;
  double _characterSpacing = 0;

  // Data
  var _charactersGroupByPositive = <String?, List<PokemonCharacter>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _charactersGroupByPositive = groupBy(
        PokemonCharacter.values, (character) => character.positive,
      );
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _characterWidth = menuItemWidthResults.childWidth;
    _characterSpacing = menuItemWidthResults.spacing;

    final groupedCharactersEntries = _charactersGroupByPositive.entries.sorted((a, b) => a.key == null ? -1 : 1);

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_character'.xTr,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING
        ),
        children: [
          ...groupedCharactersEntries.map((e) {
            final positiveName = e.key;
            final characters = e.value;
            String? positiveEffectText;
            if (positiveName != null) {
              positiveEffectText = _getCharacterEffectTrailing(positiveName, true);
            }

            return <Widget>[
              MySubHeader(
                color: positiveName == null ? warningColor : null,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Display.text(positiveName),
                      ),
                    ),
                    if (positiveEffectText != null)
                      Text(positiveEffectText),
                  ],
                ),
              ),
              Gap.sm,
              Wrap(
                spacing: _characterSpacing,
                runSpacing: _characterSpacing,
                children: _wrapMenuItems(
                  children: characters.map(_buildCharacterCard).toList(),
                ),
              ),
              Gap.md,
            ];
          }).expand((e) => e),
          Gap.trailing,
        ],
      ),
    );
  }

  Widget _buildCharacterCard(PokemonCharacter character) {
    return InkWell(
      onTap: () {
        // TODO: 反查寶可夢盒
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              character.nameI18nKey.xTr,
              style: _theme.textTheme.bodyLarge,
            ),
            _buildDescription(
              effectName: character.negative,
              positive: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription({
    required String? effectName,
    required bool positive,
  }) {
    final style = _theme.textTheme.bodySmall?.copyWith(
      color: greyColor3,
    );
    final prefix = positive ? '+ ' : '- ';

    if (effectName == null) {
      return Text(
        prefix + Display.text(effectName),
        style: style,
        maxLines: 1,
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            prefix + Display.text(effectName),
            style: style?.copyWith(
              color: positive ? positiveColor : dangerColor,
            ),
            maxLines: 1,
          ),
        ),
        if (!positive)
          Text(
            _getCharacterEffectTrailing(effectName, positive),
            style: style?.copyWith(
              color: positive ? positiveColor : dangerColor,
            ),
            maxLines: 1,
          ),
      ],
    );
  }

  String _getCharacterEffectTrailing(String effectName, bool positive) {
    final res = switch (effectName) {
      '主技能' => '_x',
      '幫忙速度' => positive ? '0.9x' : '1.1x',
      '食材發現' => positive ? '1.2x' : '0.8x',
      'EXP' => positive ? '1.18x' : '0.82x',
      '活力回復' => positive ? '1.2x' : '0.8x',
      String() => '',
    };
    return res;
  }

  List<Widget> _wrapMenuItems({ required List<Widget> children }) {
    return children
        .map((e) => _wrapMenuItemContainer(child: e))
        .toList();
  }

  Widget _wrapMenuItemContainer({ required Widget child }) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: _characterWidth,
      ),
      child: child,
    );
  }
}


