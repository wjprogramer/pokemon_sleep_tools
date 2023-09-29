import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';

class DevIconsPage extends StatefulWidget {
  const DevIconsPage({super.key});

  static MyPageRoute<void> route = ('/DevIconsPage', (_) => const DevIconsPage());

  @override
  State<DevIconsPage> createState() => _DevIconsPageState();
}

class _DevIconsPageState extends State<DevIconsPage> {
  late List<MapEntry<String, List Function()>> _iconNameToIconList;
  var _currIndex = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final mapping = {
      'Academicons': () => Academicons.iconsList,
      'AkarIcons': () => AkarIcons.iconsList,
      'AntDesign': () => AntDesign.iconsList,
      'Arcticons': () => Arcticons.iconsList,
      'Bi': () => Bi.iconsList,
      'Bpmn': () => Bpmn.iconsList,
      'Brandico': () => Brandico.iconsList,
      'Bx': () => Bx.iconsList,
      'Bxl': () => Bxl.iconsList,
      'Bxs': () => Bxs.iconsList,
      'Bytesize': () => Bytesize.iconsList,
      'Carbon': () => Carbon.iconsList,
      'Charm': () => Charm.iconsList,
      'Ci': () => Ci.iconsList,
      'Cib': () => Cib.iconsList,
      'Cil': () => Cil.iconsList,
      'Clarity': () => Clarity.iconsList,
      'Codicon': () => Codicon.iconsList,
      'Cryptocurrency': () => Cryptocurrency.iconsList,
      'Dashicons': () => Dashicons.iconsList,
      'Ei': () => Ei.iconsList,
      'El': () => El.iconsList,
      'EmojioneMonotone': () => EmojioneMonotone.iconsList,
      'Entypo': () => Entypo.iconsList,
      'EntypoSocial': () => EntypoSocial.iconsList,
      'EosIcons': () => EosIcons.iconsList,
      'Ep': () => Ep.iconsList,
      'Et': () => Et.iconsList,
      'Eva': () => Eva.iconsList,
      'Fa': () => Fa.iconsList,
      'Fa6Brands': () => Fa6Brands.iconsList,
      'Fa6Regular': () => Fa6Regular.iconsList,
      'Fa6Solid': () => Fa6Solid.iconsList,
      'FaBrands': () => FaBrands.iconsList,
      'FaRegular': () => FaRegular.iconsList,
      'FaSolid': () => FaSolid.iconsList,
      'Fad': () => Fad.iconsList,
      'Fe': () => Fe.iconsList,
      'Feather': () => Feather.iconsList,
      'FileIcons': () => FileIcons.iconsList,
      'FluentEmojiHighContrast': () => FluentEmojiHighContrast.iconsList,
      'FluentMdl2': () => FluentMdl2.iconsList,
      'Fontelico': () => Fontelico.iconsList,
      'Fontisto': () => Fontisto.iconsList,
      'Foundation': () => Foundation.iconsList,
      'Gala': () => Gala.iconsList,
      'GameIcons': () => GameIcons.iconsList,
      'Geo': () => Geo.iconsList,
      'Gg': () => Gg.iconsList,
      'Gis': () => Gis.iconsList,
      'Gridicons': () => Gridicons.iconsList,
      'GrommetIcons': () => GrommetIcons.iconsList,
      'Healthicons': () => Healthicons.iconsList,
      'Heroicons': () => Heroicons.iconsList,
      'HeroiconsOutline': () => HeroiconsOutline.iconsList,
      'HeroiconsSolid': () => HeroiconsSolid.iconsList,
      'Humbleicons': () => Humbleicons.iconsList,
      'Ic': () => Ic.iconsList,
      'IcomoonFree': () => IcomoonFree.iconsList,
      'IconParkOutline': () => IconParkOutline.iconsList,
      'IconParkSolid': () => IconParkSolid.iconsList,
      'IconParkTwotone': () => IconParkTwotone.iconsList,
      'Iconoir': () => Iconoir.iconsList,
      'Icons8': () => Icons8.iconsList,
      'Il': () => Il.iconsList,
      'Ion': () => Ion.iconsList,
      'Iwwa': () => Iwwa.iconsList,
      'Jam': () => Jam.iconsList,
      'La': () => La.iconsList,
      'LineMd': () => LineMd.iconsList,
      'Ls': () => Ls.iconsList,
      'Lucide': () => Lucide.iconsList,
      'Majesticons': () => Majesticons.iconsList,
      'Maki': () => Maki.iconsList,
      'MapIcons': () => MapIcons.iconsList,
      'MaterialSymbols': () => MaterialSymbols.iconsList,
      'Mdi': () => Mdi.iconsList,
      'MdiLight': () => MdiLight.iconsList,
      'MedicalIcon': () => MedicalIcon.iconsList,
      'Mi': () => Mi.iconsList,
      'Mingcute': () => Mingcute.iconsList,
      'MonoIcons': () => MonoIcons.iconsList,
      'Nimbus': () => Nimbus.iconsList,
      'Octicon': () => Octicon.iconsList,
      'Oi': () => Oi.iconsList,
      'Ooui': () => Ooui.iconsList,
      'Pajamas': () => Pajamas.iconsList,
      'Pepicons': () => Pepicons.iconsList,
      'Ph': () => Ph.iconsList,
      'Pixelarticons': () => Pixelarticons.iconsList,
      'Prime': () => Prime.iconsList,
      'Ps': () => Ps.iconsList,
      'Quill': () => Quill.iconsList,
      'RadixIcons': () => RadixIcons.iconsList,
      'Raphael': () => Raphael.iconsList,
      'Ri': () => Ri.iconsList,
      'SiGlyph': () => SiGlyph.iconsList,
      'SimpleIcons': () => SimpleIcons.iconsList,
      'SimpleLineIcons': () => SimpleLineIcons.iconsList,
      'Subway': () => Subway.iconsList,
      'SystemUicons': () => SystemUicons.iconsList,
      'Tabler': () => Tabler.iconsList,
      'Teenyicons': () => Teenyicons.iconsList,
      'Topcoat': () => Topcoat.iconsList,
      'Typcn': () => Typcn.iconsList,
      'Uil': () => Uil.iconsList,
      'Uim': () => Uim.iconsList,
      'Uis': () => Uis.iconsList,
      'Uit': () => Uit.iconsList,
      'Uiw': () => Uiw.iconsList,
      'Vaadin': () => Vaadin.iconsList,
      'Vs': () => Vs.iconsList,
      'Websymbol': () => Websymbol.iconsList,
      'Whh': () => Whh.iconsList,
      'Wi': () => Wi.iconsList,
      'Wpf': () => Wpf.iconsList,
      'Zmdi': () => Zmdi.iconsList,
      'Zondicons': () => Zondicons.iconsList,
    };

    _iconNameToIconList = mapping.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    // UiUtility.getChildWidthInRowBy(
    //   baseChildWidth: baseChildWidth,
    //   containerWidth: containerWidth,
    //   spacing: spacing,
    // );

    final entry = _iconNameToIconList[_currIndex];

    return Scaffold(
      appBar: buildAppBar(
        titleText: 'Icons / ${entry.key}',
      ),
      body: buildListView(
        children: [
          Wrap(
            spacing: 4,
            runSpacing: 2,
            children: entry.value().map((icon) => Iconify(icon)).toList(),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          children: [
            MyElevatedButton(
              onPressed: () {
                _changeIconList(-1);
              },
              child: const Text('Prev'),
            ),
            const Spacer(),
            MyElevatedButton(
              onPressed: () {
                _changeIconList(1);
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  void _changeIconList(int indexDelta) {
    _currIndex = (_iconNameToIconList.length + _currIndex + indexDelta) % _iconNameToIconList.length;
    setState(() { });
  }
}
