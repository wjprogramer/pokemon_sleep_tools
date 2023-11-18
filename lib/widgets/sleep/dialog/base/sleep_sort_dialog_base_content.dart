import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog_data.dart';

class SleepSortDialogBaseContent<T extends BaseSortOptions> extends StatefulWidget {
  const SleepSortDialogBaseContent({
    super.key,
    required this.titleText,
    required this.initialSortOptions,
    required this.childrenBuilder,
  });

  final T initialSortOptions;
  final String titleText;
  final CommonSortChildrenBuilder<T> childrenBuilder;

  /// For dialog children in list view
  static Iterable<Widget> hpList({ required List<Widget> children }) {
    return Hp.list(
      padding: const EdgeInsets.symmetric(
        horizontal: sleepStyleSortDialogHorizontalListViewPaddingValue,
      ),
      children: children,
    );
  }

  @override
  State<SleepSortDialogBaseContent<T>> createState() => _SleepSortDialogBaseContentState<T>();
}

class _SleepSortDialogBaseContentState<T extends BaseSortOptions> extends State<SleepSortDialogBaseContent<T>> {
  late T _sortOptions;

  @override
  void initState() {
    super.initState();
    _sortOptions = widget.initialSortOptions.clone() as T;
  }

  @override
  void dispose() {
    _sortOptions.dispose();
    super.dispose();
  }

  void _popResult([T? value]) {
    context.nav.pop(value);
  }

  Widget _header({
    required String titleText,
  }) {
    return Row(
      children: [
        IgnorePointer(
          child: IconButton(
            onPressed: () { },
            icon: const Icon(Icons.sort),
          ),
        ),
        Expanded(
          child: Text(
            titleText,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: _header(titleText: widget.titleText),
        ),
        Expanded(
          child: buildListView(
            children: widget.childrenBuilder.call(context, _sortOptions),
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
                onPressed: () => _popResult(_sortOptions),
                child: Text('t_ok'.xTr),
              ),
            ],
          ),
        ),
      ],
    );
  }
}