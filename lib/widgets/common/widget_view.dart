import 'package:flutter/material.dart';

/// https://blog.gskinner.com/archives/2020/02/flutter-widgetview-a-simple-separation-of-layout-and-logic.html
abstract class WidgetView<T1, T2> extends StatelessWidget {
  final T2 s;

  T1 get widget => (s as State).widget as T1;

  const WidgetView(this.s, {
    super.key,
  });

  BuildContext get context => (s as State).context;

  @override
  Widget build(BuildContext context);

  void safeSetState(VoidCallback fn) {
    if ((s as State).mounted) {
      // ignore: invalid_use_of_protected_member
      (s as State).setState(fn);
    }
  }

  void setState(VoidCallback fn) {
    // ignore: invalid_use_of_protected_member
    (s as State).setState(fn);
  }
}