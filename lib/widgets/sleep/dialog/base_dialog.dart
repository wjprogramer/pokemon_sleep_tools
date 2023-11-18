import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/base/sleep_search_dialog_base_content.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog_data.dart';

Future<dynamic> showSleepDialog(BuildContext context, {
  bool barrierDismissible = true,
  required Widget child,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      final screenSize = context.mediaQuery.size;
      final dialogHeight = math.min(screenSize.height * 0.8, 800).toDouble();
      final theme = context.theme;

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: sleepStyleDialogHorizontalMarginValue,
            ),
            constraints: BoxConstraints.tightFor(
              height: dialogHeight,
            ),
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: child,
          ),
        ),
      );
    },
  );
}

Future<T> showSleepSearchDialog<T extends BaseSearchOptions>(BuildContext context, {
  required String titleText,
  required T initialSearchOptions,
  CalculateCounts<T>? calcCounts,
  required CommonSleepChildrenBuilder<T> childrenBuilder,
}) async {
  final searchOptions = initialSearchOptions.clone() as T;

  await showSleepDialog(
    context,
    barrierDismissible: false,
    child: SleepSearchDialogBaseContent<T>(
      titleText: titleText,
      initialSearchOptions: initialSearchOptions,
      childrenBuilder: childrenBuilder,
      calcCounts: calcCounts,
    ),
  );

  return searchOptions;
}



