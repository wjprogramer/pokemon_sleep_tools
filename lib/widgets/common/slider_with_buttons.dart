import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class SliderWithButtons extends StatefulWidget {
  const SliderWithButtons({
    super.key,
    required this.value,
    required this.onChanged,
    this.max = 100,
    this.min = 1,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double max;
  final double min;

  @override
  State<SliderWithButtons> createState() => _SliderWithButtonsState();
}

class _SliderWithButtonsState extends State<SliderWithButtons> {

  // Data
  double get _value => widget.value;
  double get _max => widget.max;
  double get _min => widget.min;

  // UI
  late ThemeData _theme;

  // Timer properties
  int _skillLevelIncrement = 1;
  Timer? _skillLevelTimer;
  Timer? _skillLevelAccelerationTimer;

  void _startChangeSkillLevel(int delta) {
    if (_skillLevelTimer != null) {
      return;
    }

    _incrementSkillLevel(delta);
    _skillLevelTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _incrementSkillLevel(delta);
    });
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

  void _endChangeSkillLevel() {
    _skillLevelIncrement = 1;
    _skillLevelTimer?.cancel();
    _skillLevelTimer = null;
    _skillLevelAccelerationTimer?.cancel();
    _skillLevelAccelerationTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// FIXME: 模擬器的滑動有點問題
        Slider(
          value: widget.value.toDouble(),
          onChanged: (v) {
            _changeLevel(v);
          },
          divisions: 99,
          min: _min,
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
                      _value.toString(),
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
      ],
    );
  }

  Widget buildWithLabel({
    required String text,
    required Widget child,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    final screenSize = MediaQuery.of(context).size;
    final leadingWidth = math.min(screenSize.width * 0.3, 100.0);

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

  void _changeLevel(num delta) {
    widget.onChanged(
      (_value + delta).clamp(_min, _max),
    );
  }
}
