import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/third_clone/bot_toast/src/bot_toast_init.dart';
import 'package:pokemon_sleep_tools/third_clone/bot_toast/src/bot_toast_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// 取代 [BotToastInit]
TransitionBuilder appBuilder() {
  BotToastWidgetsBindingObserver.singleton;

  return (context, child) {
    Widget result;

    result = ResponsiveBreakpoints.builder(
      child: child!,
      breakpoints: [
        const Breakpoint(start: 0, end: 600, name: MOBILE),
        const Breakpoint(start: 601, end: 1000, name: TABLET),
        const Breakpoint(start: 1001, end: 1920, name: DESKTOP),
        const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ],
    );

    result = BotToastManager(key: botToastManagerKey, child: result);

    return result;
  };
}