import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

class Hp extends StatelessWidget {
  const Hp({
    super.key,
    this.child,
    this.padding,
  });

  static Iterable<Widget> list({ required Iterable<Widget> children, EdgeInsetsGeometry? padding }) =>
      children.map((e) => Hp(padding: padding, child: e));

  static const defaultPadding = EdgeInsets.symmetric(
    horizontal: HORIZON_PADDING,
  );

  final Widget? child;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? defaultPadding,
      child: child,
    );
  }
}
