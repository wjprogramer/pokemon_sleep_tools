import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';

class DialogUtility {
  DialogUtility._();

  static void text(BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
  }) {
    showAdaptiveDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: actions ?? [
          TextButton(
            onPressed: () {
              context.nav.pop();
            },
            child: Text('t_confirm'.xTr),
          ),
        ],
      ),
    );
  }

  static void loading() {

  }

}