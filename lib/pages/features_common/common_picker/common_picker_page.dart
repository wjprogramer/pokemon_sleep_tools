import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

typedef CommonPickerOptionTextBuilder<T> = Widget Function(BuildContext context, T value);

typedef CommonPickerFilter<T> = bool Function(T value, String keyword);

typedef CommonPickerItemBuilder<T> = Widget Function(T value, void Function(T item) onTap);

class CommonPickerPageArgs<T> {
  CommonPickerPageArgs({
    this.initialValue,
    required this.options,
    required this.textBuilder,
    this.withConfirmButton = false,
    this.itemFilter,
    this.itemBuilder,
    this.padding,
  });

  final T? initialValue;
  final List<T> options;
  final CommonPickerOptionTextBuilder<T> textBuilder;
  final bool withConfirmButton;
  final CommonPickerFilter<T>? itemFilter;
  final CommonPickerItemBuilder<T>? itemBuilder;
  final EdgeInsetsGeometry? padding;
  // TODO: valueAccessor
}

class CommonPickerPage<T> extends StatefulWidget {
  const CommonPickerPage._(this.args);

  static Future<T?> go<T>(BuildContext context, {
    T? initialValue,
    required List<T> options,
    required CommonPickerOptionTextBuilder<T> optionBuilder,
    CommonPickerFilter<T>? itemFilter,
    CommonPickerItemBuilder<T>? itemBuilder,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: HORIZON_PADDING),
  }) async {
    final res = await context.nav.pushWidget(
      CommonPickerPage<T>._(
        CommonPickerPageArgs<T>(
          initialValue: initialValue,
          options: options,
          textBuilder: optionBuilder,
          itemFilter: itemFilter,
          itemBuilder: itemBuilder,
          padding: padding,
        ),
      ),
    );
    return res as T?;
  }

  final CommonPickerPageArgs<T> args;

  void _popResult(BuildContext context, T? value) {
    context.nav.pop(value);
  }

  @override
  State<CommonPickerPage> createState() => _CommonPickerPageState<T>();
}

class _CommonPickerPageState<T> extends State<CommonPickerPage<T>> {
  CommonPickerPageArgs<T> get _args => widget.args;

  T? _currValue;
  late List<T> _allOptions;
  var _evaluatedOptions = <T>[];
  final _keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currValue = _args.initialValue;
    _updateAllOptions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAllOptions();

    _keywordController.addListener(() {
      _filterOptions();

      setState(() { });
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  void _updateAllOptions() {
    _allOptions = _args.options;

    if (_args.itemFilter == null) {
      _evaluatedOptions = [..._allOptions];
    } else {
      _filterOptions();
    }
  }

  void _filterOptions() {
    if (_args.itemFilter == null) {
      return;
    }

    _evaluatedOptions = _allOptions
        .where((item) => _args.itemFilter!(item, _keywordController.text))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_args.itemFilter != null)
            _buildSearchBar(),
          Expanded(
            child: buildListView(
              padding: _args.padding,
              children: [
                Gap.xl,
                /// itemBuilder
                ..._evaluatedOptions.map((item) {
                  return _args.itemBuilder?.call(item, _onItemTap) ?? MyElevatedButton(
                    onPressed: () => _onItemTap(item),
                    child: _args.textBuilder(context, item),
                  );
                }),
                Gap.xl,
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !_args.withConfirmButton ? null : BottomBarWithConfirmButton(
        submit: _submit,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      child: TextField(
        controller: _keywordController,
      ),
    );
  }

  void _onItemTap(T item) {
    if (!_args.withConfirmButton) {
      widget._popResult(context, item);
      return;
    }

    setState(() {
      _currValue = item;
    });
  }

  void _submit() {
    final currValue = _currValue;
    if (currValue == null) {
      DialogUtility.text(
        context,
        title: Text('t_failed'.xTr),
        content: Text('t_incomplete'.xTr),
      );
      return;
    }
    widget._popResult(context, currValue);
  }
}
