import 'package:flutter/material.dart';

class MultiplicationTableCell extends StatelessWidget {
  const MultiplicationTableCell({
    super.key,
    required this.child,
    this.color,
    required this.height,
    required this.width,
  });

  final Widget child;
  final Color? color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: child,
    );
  }
}