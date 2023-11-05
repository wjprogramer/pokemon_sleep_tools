import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// TODO: 重要 https://wikiwiki.jp/poke_sleep/%E3%81%9B%E3%81%84%E3%81%8B%E3%81%8F
///       根據這個修正 （裡面有張表還不錯）

enum _PageType {
  readonly,
  picker,
}

class _Args {
  _Args(this.pageType);

  final _PageType pageType;
}

/// TODO: (Idea) 反查寶可夢盒的對應性格寶可夢 [PokemonBoxPage] (可以帶入初始查詢(篩選)條件)
class CharacterListPage extends StatefulWidget {
  const CharacterListPage._(this._args);

  static const MyPageRoute route = ('/CharacterListPage', _builder);
  static Widget _builder(dynamic args) {
    return CharacterListPage._(args);
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
      arguments: _Args(_PageType.readonly),
    );
  }

  static Future<PokemonCharacter?> pick(BuildContext context) async {
    final res = await context.nav.push(
      route,
      arguments: _Args(_PageType.picker),
    );
    return res is PokemonCharacter ? res : null;
  }

  void _popResult(BuildContext context, PokemonCharacter? character) {
    context.nav.pop(character);
  }

  final _Args _args;

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  _Args get _args => widget._args;
  _PageType get _pageType => _args.pageType;

  // UI
  late ThemeData _theme;
  double _characterWidth = 100;
  double _characterSpacing = 0;

  // Data
  var _charactersGroupByPositive = <CharacterEffect, List<PokemonCharacter>>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _charactersGroupByPositive = groupBy(
        PokemonCharacter.values, (character) => character.positiveEffect,
      );
      for (final positiveToCharacters in _charactersGroupByPositive.entries) {
        final characters = positiveToCharacters.value;
        characters.sortByCompare((e) => e, (a, b) {
          if (a.type.sort == b.type.sort) {
            return a.id - b.id;
          }
          return a.type.sort - b.type.sort;
        });
      }
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _characterWidth = menuItemWidthResults.childWidth;
    _characterSpacing = menuItemWidthResults.spacing;

    final groupedCharactersEntries = _charactersGroupByPositive.entries.sorted((a, b) => a.key == CharacterEffect.none ? -1 : 1);

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
            final positiveEffect = e.key;
            final characters = e.value;
            String? positiveEffectText = _getCharacterEffectTrailing(positiveEffect, true);

            return <Widget>[
              MySubHeader(
                color: positiveEffect == CharacterEffect.none ? warningColor : null,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Display.text(
                          positiveEffect.nameI18nKey.xTr,
                          emptyText: '沒有因性格帶來的特色',
                        ),
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
        switch (_pageType) {
          case _PageType.readonly:
          // TODO: 反查寶可夢盒
            return;
          case _PageType.picker:
            widget._popResult(context, character);
            return;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: character.type.color.withOpacity(.05),
          border: Border.all(
            color: character.type.color.withOpacity(.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: character.nameI18nKey.xTr,
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      // decorationColor: character.type.color.withOpacity(1),
                      // decorationThickness: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: _theme.textTheme.bodyLarge,
            ),
            _buildDescription(
              characterEffect: character.negativeEffect,
              positive: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription({
    required CharacterEffect characterEffect,
    required bool positive,
  }) {
    final style = _theme.textTheme.bodySmall?.copyWith(
      color: greyColor3,
    );
    final prefix = '';// positive ? '+ ' : '- ';
    final effectName = characterEffect.nameI18nKey.xTr;

    if (characterEffect == CharacterEffect.none) {
      return Text(
        prefix + Display.text(effectName),
        style: style,
        maxLines: 1,
      );
    }

    String text = prefix + Display.text(effectName);

    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              text: text,
              children: [
                if (!positive) ...[
                  TextSpan(
                    text: ' (${_getCharacterEffectTrailing(characterEffect, positive)}) ',
                    style: style?.copyWith(
                      fontSize: 10,
                    ),
                  ),
                  const WidgetSpan(
                    child: Icon(Icons.keyboard_arrow_down, color: positiveColor, size: 14,),
                  ),
                ],
              ],
            ),
            style: style?.copyWith(
              // color: positive ? positiveColor : dangerColor,
              color: greyColor3,
            ),
            maxLines: 1,
          ),
        ),

      ],
    );
  }

  String? _getCharacterEffectTrailing(CharacterEffect effectName, bool positive) {
    final res = switch (effectName) {
      CharacterEffect.mainSkill => '_x',
      CharacterEffect.helpSpeed => positive ? '0.9x' : '1.1x',
      CharacterEffect.ingredientDiscovery => positive ? '1.2x' : '0.8x',
      CharacterEffect.exp => positive ? '1.18x' : '0.82x',
      CharacterEffect.energyRecovery => positive ? '1.2x' : '0.8x',
      CharacterEffect.none => null,
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


