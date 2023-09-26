import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/common/common.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum _PageType {
  create(true),
  edit(true),
  readonly(false);

  const _PageType(this.isMutate);

  final bool isMutate;
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
  bool get _isMutate => widget._pageType.isMutate;

  // Form
  late FormGroup _form;

  // Form Field
  late FormControl<PokemonBasicProfile> _basicProfileField;

  @override
  void initState() {
    super.initState();
    _basicProfileField = FormControl<PokemonBasicProfile>(
      validators: [ Validators.required ],
    );

    _form = FormGroup({});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: _getTitleText(),
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: buildListView(
          padding: const EdgeInsets.symmetric(
            horizontal: HORIZON_PADDING,
          ),
          children: [
            Gap.xl,
            ReactiveMyTextField<PokemonBasicProfile>(
              label: 't_pokemon'.xTr,
              formControl: _basicProfileField,
              wrapFieldBuilder: (context, fieldWidget) {
                return GestureDetector(
                  onTap: () async {
                    final baseProfile = await PokemonBasicProfilePicker.go(context);
                    if (baseProfile == null) {
                      return;
                    }
                    _basicProfileField.value = baseProfile;
                  },
                  behavior: HitTestBehavior.opaque,
                  child: IgnorePointer(
                    child: fieldWidget,
                  ),
                );
              },
            ),
            Gap.trailing,
          ],
        ),
      ),
      bottomNavigationBar: BottomBarWithConfirmButton(
        submit: _submit,
      ),
    );
  }

  String _getTitleText() {
    switch (widget._pageType) {
      case _PageType.create:
        return 't_create'.xTr;
      case _PageType.edit:
      case _PageType.readonly:
        return ''; // TODO: add pokemon name
    }
  }

  void _submit() {

  }
}

