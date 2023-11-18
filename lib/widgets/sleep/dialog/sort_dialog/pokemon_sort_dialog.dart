import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/base/sleep_sort_dialog_base_content.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/dialog/base_dialog.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/my_list_tile.dart';

Future<PokemonSortOptions?> showPokemonSortDialog(BuildContext context, {
  required bool focusBasicProfile,
  required PokemonSortOptions initialSortOptions
}) async {
  final res = await showSleepDialog(
    context,
    barrierDismissible: false,
    child: PokemonSortDialog(
      titleText: '排序',
      initialSortOptions: initialSortOptions,
      focusBasicProfile: focusBasicProfile,
    ),
  );

  return res is PokemonSortOptions ? res : null;
}

class PokemonSortDialog extends StatefulWidget {
  const PokemonSortDialog({
    super.key,
    required this.titleText,
    required this.initialSortOptions,
    required this.focusBasicProfile,
  });

  final String titleText;
  final PokemonSortOptions initialSortOptions;
  final bool focusBasicProfile;

  void popResult(BuildContext context, [ PokemonSortOptions? value ]) {
    context.nav.pop(value);
  }

  @override
  State<PokemonSortDialog> createState() => _PokemonSortDialogState();
}

class _PokemonSortDialogState extends State<PokemonSortDialog> {
  late List<PokemonSortOption> _options;

  @override
  void initState() {
    super.initState();
    _options = widget.focusBasicProfile
        ? PokemonSortOption.getValuesForBasicProfile()
        : PokemonSortOption.getValuesForProfile();
  }

  @override
  Widget build(BuildContext context) {
    return SleepSortDialogBaseContent(
      titleText: widget.titleText,
      initialSortOptions: widget.initialSortOptions,
      childrenBuilder: (context, sortOptions) {
        return [
          ...SleepSortDialogBaseContent.hpList(
            children: [
              ..._options.map((sortOption) => MyListTile(
                title: Text(sortOption.nameI18nKey.xTr),
                checked: sortOptions.sortOptions.firstOrNull == sortOption,
                isCheckboxRight: false,
                onCheckedChanged: (v) {
                  if (v == null) {
                    return;
                  }

                  if (v) {
                    sortOptions.appendOption(sortOption);
                  } else {
                    sortOptions.remove(sortOption);
                  }
                  setState(() { });
                },
              )),
            ],
          ),
        ];
      },
    );
  }
}

