import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';

class BottomBarWithConfirmButton extends StatelessWidget {
  const BottomBarWithConfirmButton({
    super.key,
    required this.submit,
    this.childrenAtStart,
  });

  final Function() submit;
  final List<Widget>? childrenAtStart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: Divider.createBorderSide(context),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...?childrenAtStart,
            ElevatedButton(
              onPressed: submit,
              child: Text('t_confirm'.xTr),
            ),
          ],
        ),
      ),
    );
  }
}
