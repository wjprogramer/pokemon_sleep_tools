import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/common/menu/main_menu_subtitle.dart';

class SleepFragment extends StatelessWidget {
  const SleepFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING,
      ),
      children: [
        MainMenuSubtitle(
          paddingTop: 0,
          icon: const Iconify(Carbon.sub_volume, size: 16),
          title: Text(
            '常用'.xTr,
          ),
        ),
        MainMenuSubtitle(
          icon: const Iconify(Bx.grid_alt, size: 16,),
          title: Text(
            't_main_menu'.xTr,
          ),
        ),
        Text(
          'TODO: 資料匯出、匯入、版權、資料來源、語言切換、設定'
        ),
        Gap.trailing,
      ],
    );
  }
}
