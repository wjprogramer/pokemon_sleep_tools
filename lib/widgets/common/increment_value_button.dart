import 'dart:async';

import 'package:flutter/material.dart';

class IncrementValueButton extends StatefulWidget {
  const IncrementValueButton({
    super.key,
    required this.child,
    required this.onChanged,
  });

  final Widget child;

  final ValueChanged<num> onChanged;

  @override
  State<IncrementValueButton> createState() => _IncrementValueButtonState();
}

class _IncrementValueButtonState extends State<IncrementValueButton> {

  // Timer properties
  int _skillLevelIncrement = 1;
  Timer? _skillLevelTimer;
  Timer? _skillLevelAccelerationTimer;
  num value = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _changeLevel(value),
      onLongPressStart: (_) => _startChangeSkillLevel(value),
      onLongPressEnd: (_) => _endChangeSkillLevel(),
      child: widget.child,
    );
  }

  void _changeLevel(num delta) {
    widget.onChanged(delta);
  }

  void _startChangeSkillLevel(num delta) {
    if (_skillLevelTimer != null) {
      return;
    }

    _incrementSkillLevel(delta);
    _skillLevelTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _incrementSkillLevel(delta);
    });
  }

  void _incrementSkillLevel(num delta) {
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
}
