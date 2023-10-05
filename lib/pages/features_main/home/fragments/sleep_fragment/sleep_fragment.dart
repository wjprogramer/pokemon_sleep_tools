import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_common/data_sources/data_sources_page.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/common/gap.dart';
import 'package:pokemon_sleep_tools/widgets/common/menu/main_menu_subtitle.dart';

class SleepFragment extends StatefulWidget {
  const SleepFragment({super.key});

  @override
  State<SleepFragment> createState() => _SleepFragmentState();
}

class _SleepFragmentState extends State<SleepFragment> {
  double _menuButtonWidth = 100;
  double _menuButtonSpacing = 0;

  @override
  Widget build(BuildContext context) {
    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _menuButtonWidth = menuItemWidthResults.childWidth;
    _menuButtonSpacing = menuItemWidthResults.spacing;

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
          'TODO: 資料匯出、匯入、語言切換、設定',
        ),
        MainMenuSubtitle(
          icon: const Iconify(Bx.grid_alt, size: 16,),
          title: Text(
            't_others'.xTr,
          ),
        ),
        Wrap(
          spacing: _menuButtonSpacing,
          runSpacing: _menuButtonSpacing,
          children: _wrapMenuItems(
            children: [
              MyOutlinedButton(
                color: greyColor3,
                onPressed: () {
                  showLicensePage(context: context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.file_copy_outlined, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('版權標記'.xTr),
              ),
              MyOutlinedButton(
                color: greyColor3,
                onPressed: () {
                  DataSourcesPage.go(context);
                },
                iconBuilder: (color, size) {
                  return Icon(Icons.file_copy_outlined, color: color, size: size,);
                },
                builder: MyOutlinedButton.builderUnboundWidth,
                child: Text('資料來源'.xTr),
              ),
            ],
          ),
        ),
        Gap.trailing,
      ],
    );
  }

  List<Widget> _wrapMenuItems({ required List<Widget> children }) {
    return children
        .map((e) => _wrapMenuItemContainer(child: e))
        .toList();
  }

  Widget _wrapMenuItemContainer({ required Widget child }) {
    return Container(
      constraints: BoxConstraints.tightFor(
        width: _menuButtonWidth,
      ),
      child: child,
    );
  }
}
