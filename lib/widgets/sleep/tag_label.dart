import 'package:flutter/material.dart';

class TagLabel extends StatelessWidget {
  const TagLabel({
    super.key,
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  (String, Color) _getLabelContent() {
    return ('', Colors.blue);
  }
}
