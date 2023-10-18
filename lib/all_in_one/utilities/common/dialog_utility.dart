import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/dialog.dart';

class DialogUtility {
  DialogUtility._();

  static Future<T?> text<T>(BuildContext context, {
    Widget? title,
    Widget? content,
    bool? barrierDismissible,
    List<Widget>? actions,
  }) async {
    return showAdaptiveDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
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

  static Future<bool> confirm(BuildContext context, {
    Widget? title,
    Widget? content,
    bool? barrierDismissible,
    List<Widget>? actions,
  }) async {
    final res = await showAdaptiveDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        title: title,
        content: content,
        actions: actions ?? [
          TextButton(
            onPressed: () {
              context.nav.pop(false);
            },
            child: Text('t_cancel'.xTr),
          ),
          TextButton(
            onPressed: () {
              context.nav.pop(true);
            },
            child: Text('t_confirm'.xTr),
          ),
        ],
      ),
    );

    return res is bool ? res : false;
  }

  static void danger(BuildContext context, {
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    String? confirmText,
    Function()? onConfirm,
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
            child: Text('t_cancel'.xTr),
          ),
          TextButton(
            onPressed: () {
              context.nav.pop();
              onConfirm?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: dangerColor,
            ),
            child: Text(confirmText ?? 't_confirm'.xTr),
          ),
        ],
      ),
    );
  }

  static Future<PokemonSearchOptions?> searchPokemon(BuildContext context, {
    required PokemonSearchOptions initialSearchOptions,
    CalculateCounts<PokemonSearchOptions>? calcCounts,
  }) async {
    return showPokemonSearchDialog(
      context,
      titleText: 't_pokemon'.xTr,
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
    );
  }

  static Future<DishSearchOptions?> pickDishSearchOptions(BuildContext context, {
    required DishSearchOptions initialSearchOptions,
    (int, int) Function(DishSearchOptions options)? calcCounts,
  }) async {
    return showDishSearchDialog(
      context,
      titleText: '',
      initialSearchOptions: initialSearchOptions,
      calcCounts: calcCounts,
    );
  }

  static void loading() {

  }

}