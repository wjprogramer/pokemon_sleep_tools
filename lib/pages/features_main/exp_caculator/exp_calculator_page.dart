import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_common/common_picker/common_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_caculator_result/exp_caculator_result_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ExpCalculatorPage extends StatefulWidget {
  const ExpCalculatorPage._();

  static const MyPageRoute route = ('/ExpCalculatorPage', _builder);
  static Widget _builder(dynamic args) {
    return const ExpCalculatorPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<ExpCalculatorPage> createState() => _ExpCalculatorPageState();
}

/// 要加上糖果介紹
/// 一般糖果為 +25
/// 萬能糖果 S => 換成三顆
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

  // Skill Level Timer
  int _skillLevelIncrement = 1;
  Timer? _skillLevelTimer;
  Timer? _skillLevelAccelerationTimer;

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
              showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('t_candies'.xTr),
                    content: Text('t_candies_info_text'.xTr),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.nav.pop();
                        },
                        child: Text('t_confirm'.xTr),
                      ),
                    ],
                  );
                },
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
    final screenSize = MediaQuery.of(context).size;
    final leadingWidth = math.min(screenSize.width * 0.3, 100.0);

    Widget buildWithLabel({
      required String text,
      required Widget child,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    }) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            constraints: BoxConstraints.tightFor(width: leadingWidth),
            child: MyLabel(
              text: text,
            ),
          ),
          Expanded(child: child),
        ],
      );
    }

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
      CheckboxListTile(
        value: _isLarvitar,
        onChanged: (v) {
          if (v == null || !v) {
            return;
          }
          _isLarvitar = v;
          setState(() { });
        },
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
      CheckboxListTile(
        value: !_isLarvitar,
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
          Slider(
            value: _currLevel.toDouble(),
            onChanged: (v) {
              _changeLevel(v.toInt());
            },
            divisions: 99,
            min: 1,
            max: 100,
          ),
          Row(
            children: [
              Expanded(child: _buildLevelButton(value: -10)),
              Expanded(child: _buildLevelButton(value: -1)),
              Stack(
                children: [
                  const Opacity(
                    opacity: 0,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('100'),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        _currLevel.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: _buildLevelButton(value: 1)),
              Expanded(child: _buildLevelButton(value: 10)),
            ].xMapIndexed((index, e, list) => <Widget>[
              e,
              if (list.length - 1 != index)
                Gap.sm,
            ]).expand((e) => e).toList(),
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
              suffix: Text('/ $_currLevelNeedExp'),
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

  Widget _buildLevelButton({
    required int value,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _changeLevel(value),
      onLongPressStart: (_) => _startChangeSkillLevel(value),
      onLongPressEnd: (_) => _endChangeSkillLevel(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: _theme.primaryColor,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
            (value > 0 ? '+' : '') + value.toString(),
        ),
      ),
    );
  }

  void _incrementSkillLevel(int delta) {
    const duration = Duration(milliseconds: 1000);
    _changeLevel(_skillLevelIncrement * delta);

    // 開始加速計時器
    _skillLevelAccelerationTimer ??= Timer.periodic(duration, (timer) {
      if (_skillLevelIncrement > 5) {
        return;
      }
      _skillLevelIncrement = (1.5 * _skillLevelIncrement).round(); // 每次加速 x 倍增
    });
  }
  
  void _startChangeSkillLevel(int delta) {
    if (_skillLevelTimer != null) {
      return;
    }

    _incrementSkillLevel(delta);
    _skillLevelTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _incrementSkillLevel(delta);
    });
  }

  void _endChangeSkillLevel() {
    _skillLevelIncrement = 1;
    _skillLevelTimer?.cancel();
    _skillLevelTimer = null;
    _skillLevelAccelerationTimer?.cancel();
    _skillLevelAccelerationTimer = null;
  }

  void _changeLevel(int delta) {
    _currLevel = (_currLevel + delta).clamp(1, 100);

    final fieldValue = _remainExpToNextLevelField.value;
    if (fieldValue != null && fieldValue > _currLevelNeedExp) {
      _remainExpToNextLevelField.value = _currLevelNeedExp;
    }

    setState(() { });
  }

}


