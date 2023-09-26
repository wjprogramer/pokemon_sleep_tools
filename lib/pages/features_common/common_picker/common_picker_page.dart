import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';

typedef CommonPickerOptionTextBuilder<T> = Widget Function(BuildContext context, T value);

class CommonPickerPageArgs<T> {
  CommonPickerPageArgs({
    this.initialValue,
    required this.options,
    required this.textBuilder,
  });

  final T? initialValue;
  final List<T> options;
  final CommonPickerOptionTextBuilder<T> textBuilder;
  // TODO: valueAccessor
}

class CommonPickerPage<T> extends StatefulWidget {
  const CommonPickerPage._(this.args);

  static Future<T?> go<T>(BuildContext context, {
    T? initialValue,
    required List<T> options,
    required CommonPickerOptionTextBuilder<T> optionBuilder,
  }) async {
    final res = await context.nav.pushWidget(
      CommonPickerPage<T>._(
        CommonPickerPageArgs<T>(
          initialValue: initialValue,
          options: options,
          textBuilder: optionBuilder,
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

  @override
  void initState() {
    super.initState();
    _currValue = widget.args.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildListView(
        padding: const EdgeInsets.symmetric(horizontal: HORIZON_PADDING),
        children: [
          Gap.xl,
          ...widget.args.options.map((e) => ElevatedButton(
            onPressed: () {
              widget._popResult(context, e);
            },
            child: _args.textBuilder(context, e),
          )),
          Gap.xl,
        ],
      ),
      // bottomNavigationBar: BottomBarWithConfirmButton(
      //   submit: _submit,
      // ),
    );
  }

  // void _submit() {
  //   final currValue = _currValue;
  //   if (currValue == null) {
  //     DialogUtility.text(
  //       context,
  //       title: Text('t_failed'.xTr),
  //       content: Text('t_incomplete'.xTr),
  //     );
  //     return;
  //   }
  //   widget._popResult(context, currValue);
  // }
}
