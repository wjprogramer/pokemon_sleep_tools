import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/main/my_app_bar.dart';

enum _PageType {
  create,
  edit,
  readonly;
}

class PokemonMaintainProfilePageArgs {

}

class PokemonMaintainProfilePage extends StatefulWidget {
  const PokemonMaintainProfilePage._({
    required _PageType pageType,
  }) : _pageType = pageType;

  static List<MyPageRoute<PokemonMaintainProfilePageArgs>> get routes => [
    _routeCreate, _routeEdit, _routeReadonly,
  ];

  static MyPageRoute<PokemonMaintainProfilePageArgs> get _routeCreate =>
      ('/PokemonBoxPage/create', _getBuilder(_PageType.create));
  static MyPageRoute<PokemonMaintainProfilePageArgs> get _routeEdit =>
      ('/PokemonBoxPage/edit', _getBuilder(_PageType.edit));
  static MyPageRoute<PokemonMaintainProfilePageArgs> get _routeReadonly =>
      ('/PokemonBoxPage/readonly', _getBuilder(_PageType.readonly));

  static MyRouteBuilder _getBuilder(_PageType pageType) {
    return (dynamic args) {
      args = args as PokemonMaintainProfilePageArgs?;
      return PokemonMaintainProfilePage._(pageType: pageType);
    };
  }

  static goCreate(BuildContext context) {
    context.nav.push(
      _routeCreate,
      /// TODO: 目前的型態檢查不優，即使放字串、數字，也不用有 error
      arguments: PokemonMaintainProfilePageArgs(),
    );
  }

  final _PageType _pageType;

  @override
  State<PokemonMaintainProfilePage> createState() => _PokemonMaintainProfilePageState();
}

class _PokemonMaintainProfilePageState extends State<PokemonMaintainProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
    );
  }
}

