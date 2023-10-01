import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

class Hp extends StatelessWidget {
  const Hp({
    super.key,
    this.child,
  });

  static Iterable<Widget> list({ required Iterable<Widget> children }) =>
      children.map((e) => Hp(child: e,));

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING,
      ),
      child: child,
    );
  }
}
