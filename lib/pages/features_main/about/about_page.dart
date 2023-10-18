import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/search_list_tile.dart';

class AboutPage extends StatefulWidget {
  const AboutPage._();

  static const MyPageRoute route = ('/AboutPage', _builder);
  static Widget _builder(dynamic args) {
    return const AboutPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var _versionText = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    _versionText = '$version+$buildNumber';
    if (mounted) {
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '關於'.xTr,
      ),
      body: ListView(
        children: [
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              SearchListTile(
                titleText: '作者臉書',
                url: 'https://www.facebook.com/WJProgramer',
              ),
              SearchListTile(
                titleText: '隱私權政策',
                url: 'https://raw.githubusercontent.com/wjprogramer/public_resources/master/privacy/sleep_tools.md',
              ),
            ],
          ),
          Gap.xl,
          Text(
            _versionText,
            textAlign: TextAlign.center,
          ),
          Gap.trailing,
        ],
      ),
    );
  }
}


