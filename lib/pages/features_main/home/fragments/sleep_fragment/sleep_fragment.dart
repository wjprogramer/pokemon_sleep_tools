import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_common/change_lang/change_lang_page.dart';
import 'package:pokemon_sleep_tools/pages/features_common/change_logs/change_logs_page.dart';
import 'package:pokemon_sleep_tools/pages/features_common/data_sources/data_sources_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/about/about_page.dart';
import 'package:pokemon_sleep_tools/persistent/local_storage/local_storage.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SleepFragment extends StatefulWidget {
  const SleepFragment({super.key});

  @override
  State<SleepFragment> createState() => _SleepFragmentState();
}

class _SleepFragmentState extends State<SleepFragment> {
  MyLocalStorage get _localStorage => getIt();

  double _menuButtonWidth = 100;
  double _menuButtonSpacing = 0;

  @override
  Widget build(BuildContext context) {
    final menuItemWidthResults = UiUtility.getCommonWidthInRowBy(context);
    _menuButtonWidth = menuItemWidthResults.childWidth;
    _menuButtonSpacing = menuItemWidthResults.spacing;

    return ListView(
      children: [
        ...Hp.list(
          children: [
            // MainMenuSubtitle(
            //   paddingTop: 0,
            //   icon: const Iconify(Carbon.sub_volume, size: 16),
            //   title: Text(
            //     't_commonly_used'.xTr,
            //   ),
            // ),
            // MainMenuSubtitle(
            //   icon: const Iconify(Bx.grid_alt, size: 16,),
            //   title: Text(
            //     't_main_menu'.xTr,
            //   ),
            // ),
            // const Text(
            //   'TODO: 語言切換、設定',
            // ),
            MainMenuSubtitle(
              paddingTop: 0,
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
                    child: Text('t_copyright_mark'.xTr),
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
                    child: Text('t_source'.xTr),
                  ),
                  MyOutlinedButton(
                    color: tmpColor,
                    onPressed: () async {
                      try {
                        final res = await _localStorage.importData();
                        if (res == null) {
                          return;
                        }

                        final mainViewModel = context.read<MainViewModel>();

                        await mainViewModel.loadProfiles(force: true);
                        DialogUtility.text(
                          context,
                          title: Text('t_data_import_success'.xTr),
                        );
                      } catch (e) {
                        DialogUtility.text(
                          context,
                          title: Text('t_data_import_failed'.xTr),
                        );
                      }
                    },
                    iconBuilder: (color, size) {
                      return Icon(Icons.login, color: color, size: size,);
                    },
                    builder: MyOutlinedButton.builderUnboundWidth,
                    child: Text('t_data_import'.xTr),
                  ),
                  MyOutlinedButton(
                    color: tmpColor,
                    onPressed: () async {
                      try {
                        await _localStorage.exportData();
                        DialogUtility.text(
                          context,
                          title: Text('t_data_export_success'.xTr),
                          content: MyPlatform.isWindows
                              ? Text('t_export_data_to_download_folder'.xTr)
                              : null,
                        );
                      } catch (e, s) {
                        DialogUtility.text(
                          context,
                          title: Text('t_data_export_failed'.xTr),
                        );
                      }
                    },
                    iconBuilder: (color, size) {
                      return Icon(Icons.logout, color: color, size: size,);
                    },
                    builder: MyOutlinedButton.builderUnboundWidth,
                    child: Text('t_data_export'.xTr),
                  ),
                  MyOutlinedButton(
                    color: tmpColor,
                    onPressed: () async {
                      ChangeLogsPage.go(context);
                    },
                    iconBuilder: (color, size) {
                      return Icon(Icons.work_history_outlined, color: color, size: size,);
                    },
                    builder: MyOutlinedButton.builderUnboundWidth,
                    child: Text('t_update_record'.xTr),
                  ),
                  MyOutlinedButton(
                    color: tmpColor,
                    onPressed: () async {
                      AboutPage.go(context);
                    },
                    iconBuilder: (color, size) {
                      // return Icon(Icons.phone_android, color: color, size: size,);
                      return Icon(Icons.info_outline, color: color, size: size,);
                    },
                    builder: MyOutlinedButton.builderUnboundWidth,
                    child: Text('t_about'.xTr),
                  ),
                  MyOutlinedButton(
                    color: positiveColor,
                    onPressed: () async {
                      ChangeLangPage.go(context);
                    },
                    iconBuilder: (color, size) {
                      return Icon(Icons.language, color: color, size: size,);
                    },
                    builder: MyOutlinedButton.builderUnboundWidth,
                    child: Text('${'t_switch_language'.xTr}\n(${'t_developing'.xTr})'),
                  ),
                ],
              ),
            ),
            // MainMenuSubtitle(
            //   icon: const Iconify(Bx.grid_alt, size: 16,),
            //   title: Text(
            //     '外部連結'.xTr,
            //   ),
            // ),
          ],
        ),
        // ...ListTile.divideTiles(
        //   context: context,
        //   tiles: [
        //     _buildListTile(
        //       titleText: '【攻略】使用能量計算!!更科學的『寶可夢Sleep潛力計算機v4.0』五段評價系統!!',
        //       url: 'https://forum.gamer.com.tw/C.php?bsn=36685&snA=913',
        //       subTitleText: '主要參考計算方式',
        //     ),
        //   ],
        // ),
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

  Widget _buildListTile({
    required String titleText,
    required String url,
    String? subTitleText,
  }) {
    return ListTile(
      onTap: () {
        launchUrl(Uri.parse(url));
      },
      title: Text(titleText),
      subtitle: subTitleText == null ? null
          : Text(subTitleText, maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: const Icon(
        Icons.open_in_new,
      ),
    );
  }
}
