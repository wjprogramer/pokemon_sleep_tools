import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_common/common_picker/common_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator_result/exp_caculator_result_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../widgets/sleep/list_tiles/list_tiles.dart';

class _PageArgs {
  _PageArgs({
    this.isLarvitarChain = false,
  });

  final bool isLarvitarChain;
}

class ExpCalculatorPage extends StatefulWidget {
  const ExpCalculatorPage._(this._args);

  static const MyPageRoute route = ('/ExpCalculatorPage', _builder);
  static Widget _builder(dynamic args) {
    return ExpCalculatorPage._(args);
  }

  static void go(BuildContext context, {
    bool isLarvitarChain = false,
  }) {
    context.nav.push(
      route,
      arguments: _PageArgs(
        isLarvitarChain: isLarvitarChain
      ),
    );
  }

  final _PageArgs _args;

  @override
  State<ExpCalculatorPage> createState() => _ExpCalculatorPageState();
}

class _ExpCalculatorPageState extends State<ExpCalculatorPage> {
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  late ThemeData _theme;
  String get _titleText => 't_exp_and_candies'.xTr;

  var _initialized = false;

  var _isLarvitar = false;
  final _bagCandiesCount = FormControl<int>(
    value: 0,
  );
  final _remainExpToNextLevelField = FormControl<int>(
    validators: [ ],
    value: 0,
  );
  final _characterField = FormControl<PokemonCharacter>(
    validators: [ ],
  );
  var _currLevel = 2;
  var _larvitarChainProfiles = <PokemonBasicProfile>[];
  int get _currLevelNeedExp => ExpSleepUtility.getNeedExp(_currLevel);

  @override
  void initState() {
    super.initState();
    _remainExpToNextLevelField.valueChanges.listen((v) {
      if (v != null && v > _currLevelNeedExp) {
        _remainExpToNextLevelField.value = _currLevelNeedExp;
      }
    });

    scheduleMicrotask(() async {
      _larvitarChainProfiles = (await Future.wait([86, 87, 88].map((basicProfileId) =>
          _basicProfileRepo.getBasicProfile(basicProfileId))
      )).whereNotNull().toList();

      _isLarvitar = widget._args.isLarvitarChain;

      _initialized = true;
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    if (!_initialized) {
      return LoadingView(titleText: _titleText);
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: _titleText,
        actions: [
          IconButton(
            onPressed: () {
              DialogUtility.text(
                context,
                title: Text('t_candies'.xTr),
                content: Text('t_candies_info_text'.xTr),
                barrierDismissible: true,
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: buildListView(children: _buildListItems()),
    );
  }

  List<Widget> _buildListItems() {
    Widget otherLabel(String text) {
      return Text(
        text,
        style: _theme.textTheme.bodySmall?.copyWith(
          color: greyColor3,
        ),
        textAlign: TextAlign.start,
      );
    }

    Widget otherPostLabel(String label) {
      return Text(
        label,
        style: _theme.textTheme.bodySmall?.copyWith(
          color: greenColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.end,
      );
    }

    return [
      ...Hp.list(
        children: [
          MySubHeader(
            titleText: 't_select_pokemon'.xTr,
          ),
        ],
      ),
      _buildMyCheckListTile(
        value: _isLarvitar,
        onChanged: (v) {
          if (v == null || !v) {
            return;
          }
          _isLarvitar = v;
          setState(() { });
        },
        leading: !MyEnv.USE_DEBUG_IMAGE ? null : Padding(
          padding: const EdgeInsets.only(right: 16),
          child: PokemonIconImage(
            basicProfile: _larvitarChainProfiles[0],
            width: 48,
          ),
        ),
        title: Text(
          _larvitarChainProfiles
              .map((e) => e.nameI18nKey.xTr)
              .join('t_separator'.xTr),
        ),
        subtitle: Text(
          't_special_exp_format_hint'.xTr,
          style: const TextStyle(
            color: warningColor,
          ),
        ),
      ),
      _buildMyCheckListTile(
        value: !_isLarvitar,
        leading: !MyEnv.USE_DEBUG_IMAGE ? null : Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 48,
          ),
        ),
        onChanged: (v) {
          if (v == null || !v) {
            return;
          }
          _isLarvitar = !v;
          setState(() { });
        },
        title: Text('t_other_pokemon'.xTr),
      ),
      ...Hp.list(
        children: [
          MySubHeader(
            titleText: 't_set_level'.xTr,
          ),
          SliderWithButtons(
            value: _currLevel.toDouble(),
            max: 100,
            min: 1,
            divisions: 99,
            onChanged: (v) {
              _currLevel = v.toInt();

              final fieldValue = _remainExpToNextLevelField.value;
              if (fieldValue != null && fieldValue > _currLevelNeedExp) {
                _remainExpToNextLevelField.value = _currLevelNeedExp;
              }

              setState(() { });
            },
          ),
          Gap.xl,
          MySubHeader(
            titleText: 't_other_settings'.xTr,
          ),
          Gap.xl,
          // buildWithLabel(
          //   text: 't_hold_candies'.xTr,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //
          //     ],
          //   ),
          // ),
          otherLabel('t_need_exp_next_level_prefix'.xTr),
          ReactiveMyTextField(
            formControl: _remainExpToNextLevelField,
            decoration: InputDecoration(
              suffix: Text('/ ${Display.numInt(_currLevelNeedExp)}'),
            ),
          ),
          Gap.sm,
          otherPostLabel('EXP'),

          Gap.md,
          otherLabel('t_hold_candies'.xTr),
          ReactiveMyTextField(
            formControl: _bagCandiesCount,
          ),
          Gap.sm,
          otherPostLabel('t_candy_unit'.xTr),

          Gap.md,
          otherLabel('t_character'.xTr),
          ReactiveMyTextField(
            formControl: _characterField,
            // TODO: suffixIcon 放按鈕會點不了 （GestureDetector 和 Button 都一樣）
            // 不知為何 (之前用都可以，應該 flutter 版本問題？需確認)
            // decoration: InputDecoration(
            //   suffixIcon: 清除按鈕
            // ),
            wrapFieldBuilder: (context, fieldWidget) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final result = await CommonPickerPage.go<PokemonCharacter>(
                    context,
                    options: PokemonCharacter.values,
                    optionBuilder: (context, character) {
                      return Text(character.nameI18nKey);
                    },
                    itemBuilder: (item, onItemTap) {
                      Color? color;

                      if (item.positive == 'EXP') {
                        color = positiveColor;
                      } else if (item.negative == 'EXP') {
                        color = dangerColor;
                      }

                      return ListTile(
                        title: Text(item.nameI18nKey.xTr),
                        subtitle: Text(
                          '+ ${Display.text(item.positive)}, - ${Display.text(item.negative)}',
                          style: TextStyle(
                            color: color,
                            fontWeight: color != null ? FontWeight.bold : null,
                          ),
                        ),
                        onTap: () => onItemTap(item),
                      );
                    },
                    padding: EdgeInsets.zero,
                  );
                  if (result == null) {
                    return;
                  }
                  _characterField.value = result;
                },
                child: IgnorePointer(
                  child: fieldWidget,
                ),
              );
            },
          ),
          Gap.sm,

          Gap.xxl,
          MyElevatedButton(
            onPressed: () {
              ExpCalculatorResultPage.go(
                context,
                isLarvitar: _isLarvitar,
                currLevel: _currLevel,
                character: _characterField.value,
                remainExpToNextLevel: _remainExpToNextLevelField.value ?? 0,
                bagCandiesCount: _bagCandiesCount.value ?? 0,
              );
            },
            child: Text('t_calculate_result'.xTr),
          ),
          Gap.trailing,
        ],
      ),
    ];
  }

  _buildMyCheckListTile({
    required bool value,
    required ValueChanged onChanged,
    required Widget title,
    Widget? subtitle,
    Widget? leading,
  }) {
    return MyListTile(
      checked: value,
      onCheckedChanged: onChanged,
      title: title,
      subtitle: subtitle,
      leading: leading,
    );
  }

}


