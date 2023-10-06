import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
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
              horizontal: sleepStyleSearchDialogHorizontalMarginValue,
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

class SleepSearchDialogBaseContent<T extends BaseSearchOptions> extends StatefulWidget {
  const SleepSearchDialogBaseContent({
    super.key,
    required this.titleText,
    required this.initialSearchOptions,
    this.calcCounts,
    this.onOptionsCreated,
    required this.childrenBuilder,
  });

  final T initialSearchOptions;
  final String titleText;
  final CommonSleepChildrenBuilder<T> childrenBuilder;
  final CalculateCounts<T>? calcCounts;
  final Function(T options, VoidCallback search)? onOptionsCreated;

  /// For dialog children in list view
  static Iterable<Widget> hpList({ required List<Widget> children }) {
    return Hp.list(
      padding: const EdgeInsets.symmetric(
        horizontal: sleepStyleSearchDialogHorizontalListViewPaddingValue,
      ),
      children: children,
    );
  }

  @override
  State<SleepSearchDialogBaseContent<T>> createState() => _SleepSearchDialogBaseContentState<T>();
}

class _SleepSearchDialogBaseContentState<T extends BaseSearchOptions> extends State<SleepSearchDialogBaseContent<T>> {
  late T _searchOptions;
  int? _matchCount;
  int? _allCount;
  var _suffixHeaderText = '';

  @override
  void initState() {
    super.initState();
    _searchOptions = widget.initialSearchOptions.clone() as T;
    widget.onOptionsCreated?.call(_searchOptions, _search);
    _tryCalcCounts();
  }

  @override
  void dispose() {
    _searchOptions.dispose();
    super.dispose();
  }

  void _popResult([T? value]) {
    context.nav.pop(value);
  }

  _tryCalcCounts() {
    if (widget.calcCounts != null) {
      final calcMatchCount = widget.calcCounts!(_searchOptions);
      _matchCount = calcMatchCount.$1;
      _allCount = calcMatchCount.$2;
    }
  }

  void _search() {
    _tryCalcCounts();
    setState(() { });
  }

  Widget _header({
    required String titleText,
    required VoidCallback onReset,
  }) {
    return Row(
      children: [
        IgnorePointer(
          child: IconButton(
            onPressed: () { },
            icon: const Icon(Icons.search),
          ),
        ),
        Expanded(
          child: Text(
            titleText,
          ),
        ),
        TextButton(
          onPressed: onReset,
          child: Text('t_reset'.xTr),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_matchCount != null && _allCount != null) {
      _suffixHeaderText = '($_matchCount/$_allCount)';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 4,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context),
            ),
          ),
          child: _header(
            titleText: '${widget.titleText} $_suffixHeaderText',
            onReset: () {
              _searchOptions.clear();
              _search();
            },
          ),
        ),
        Expanded(
          child: buildListView(
            children: widget.childrenBuilder.call(context, _search, _searchOptions),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              top: Divider.createBorderSide(context),
            ),
          ),
          child: Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => _popResult(),
                child: Text('t_cancel'.xTr),
              ),
              TextButton(
                onPressed: () => _popResult(_searchOptions),
                child: Text('t_ok'.xTr),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

