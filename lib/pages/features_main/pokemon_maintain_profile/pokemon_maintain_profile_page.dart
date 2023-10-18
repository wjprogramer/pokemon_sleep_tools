import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/form/validation/validation.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_common/common_picker/common_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/view_models.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum _PageType {
  create(true),
  edit(true),
  readonly(false);

  const _PageType(this.isMutate);

  final bool isMutate;
}

class _PokemonMaintainProfilePageArgs {
  _PokemonMaintainProfilePageArgs({
    this.profile,
  });

  final PokemonProfile? profile;
}

/// TODO: 切換寶可夢的時候，要清除食材
class PokemonMaintainProfilePage extends StatefulWidget {
  const PokemonMaintainProfilePage._({
    required _PageType pageType,
    required _PokemonMaintainProfilePageArgs args,
  }) : _args = args, _pageType = pageType;

  static List<MyPageRoute> get routes => [
    _routeCreate, _routeEdit, _routeReadonly,
  ];

  static MyPageRoute<_PokemonMaintainProfilePageArgs> get _routeCreate =>
      ('/PokemonBoxPage/create', _getBuilder(_PageType.create));
  static MyPageRoute<_PokemonMaintainProfilePageArgs> get _routeEdit =>
      ('/PokemonBoxPage/edit', _getBuilder(_PageType.edit));
  static MyPageRoute<_PokemonMaintainProfilePageArgs> get _routeReadonly =>
      ('/PokemonBoxPage/readonly', _getBuilder(_PageType.readonly));

  static MyRouteBuilder _getBuilder(_PageType pageType) {
    return (dynamic args) {
      return PokemonMaintainProfilePage._(pageType: pageType, args: args);
    };
  }

  static goCreate(BuildContext context) {
    context.nav.push(
      _routeCreate,
      arguments: _PokemonMaintainProfilePageArgs(),
    );
  }

  static goEdit(BuildContext context, PokemonProfile profile) {
    context.nav.push(
      _routeEdit,
      arguments: _PokemonMaintainProfilePageArgs(
        profile: profile,
      ),
    );
  }

  final _PageType _pageType;
  final _PokemonMaintainProfilePageArgs _args;

  @override
  State<PokemonMaintainProfilePage> createState() => _PokemonMaintainProfilePageState();
}

class _PokemonMaintainProfilePageState extends State<PokemonMaintainProfilePage> {
  MainViewModel get _mainViewModel => context.read<MainViewModel>();

  late ThemeData _theme;

  PokemonProfile? get _profile => widget._args.profile;

  // Form
  late FormGroup _form;
  final _ingredientDisplayTextControllers = List.generate(3, (index) => TextEditingController());

  // Form Field
  late FormControl<PokemonBasicProfile> _basicProfileField;
  late FormControl<PokemonCharacter> _characterField;
  late FormControl<List<SubSkill>> _subSkillsField;

  late FormControl<Ingredient> _ingredient2Field;
  late FormControl<Ingredient> _ingredient3Field;

  late FormControl<int> _ingredient1CountField;
  late FormControl<int> _ingredient2CountField;
  late FormControl<int> _ingredient3CountField;

  @override
  void initState() {
    super.initState();
    _initForm();

    _basicProfileField.valueChanges.listen((basicProfile) {
      _ingredientDisplayTextControllers[0].text =
          Display.text(basicProfile?.ingredient1.nameI18nKey);
      _ingredient1CountField.value = basicProfile?.ingredientCount1;

      setState(() { });
    });

    scheduleMicrotask(() async {
      await _initData();
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _ingredientDisplayTextControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// TODO: 加上 disabled: true, 會導致 errors 永遠為空
  void _initForm() {
    _basicProfileField = FormControl(
      validators: [ Validators.required ],
    );
    _characterField = FormControl(
      validators: [ Validators.required ],
    );
    _subSkillsField = FormControl(
      validators: [
        Validators.required,
        MyValidators.iterableLength(SubSkill.maxCount),
      ],
    );

    _ingredient2Field = FormControl(validators: [ Validators.required ]);
    _ingredient3Field = FormControl(validators: [ Validators.required ]);

    _ingredient1CountField = FormControl(
      validators: [ Validators.required, Validators.min(1), Validators.max(99) ],
    );
    _ingredient2CountField = FormControl(
      validators: [ Validators.required, Validators.min(1), Validators.max(99) ],
    );
    _ingredient3CountField = FormControl(
      validators: [ Validators.required, Validators.min(1), Validators.max(99) ],
    );

    _form = FormGroup({
      '_basicProfile': _basicProfileField,
      '_character': _characterField,
      '_subSkills': _subSkillsField,
      '_ingredient2': _ingredient2Field,
      '_ingredient3': _ingredient3Field,
      '_ingredient1Count': _ingredient1CountField,
      '_ingredient2Count': _ingredient2CountField,
      '_ingredient3Count': _ingredient3CountField,
    });
  }

  Future<void> _initData() async {
    final profile = _profile;
    if (widget._pageType != _PageType.edit || profile == null) {
      return;
    }

    _basicProfileField.value = profile.basicProfile;
    _characterField.value = profile.character;
    _subSkillsField.value = profile.subSkills;

    _ingredient2Field.value = profile.ingredient2;
    _ingredient3Field.value = profile.ingredient3;

    _ingredient1CountField.value = profile.ingredientCount1;
    _ingredient2CountField.value = profile.ingredientCount2;
    _ingredient3CountField.value = profile.ingredientCount3;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

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
                    // TODO: 要可以改進化前後的寶可夢，例如原本是皮卡丘，進來後要可以改成皮丘或雷丘
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
            Gap.xl,
            ReactiveMyTextField<PokemonCharacter>(
              label: 't_character'.xTr,
              formControl: _characterField,
              wrapFieldBuilder: (context, fieldWidget) {
                return GestureDetector(
                  onTap: () async {
                    final result = await CommonPickerPage.go<PokemonCharacter>(
                        context,
                        options: PokemonCharacter.values,
                        optionBuilder: (context, character) {
                          return Text(character.nameI18nKey);
                        }
                    );
                    if (result == null) {
                      return;
                    }
                    _characterField.value = result;
                  },
                  behavior: HitTestBehavior.opaque,
                  child: IgnorePointer(
                    child: fieldWidget,
                  ),
                );
              },
            ),
            Gap.xl,
            ReactiveMyTextField<List<SubSkill>>(
              label: 't_sub_skills'.xTr,
              formControl: _subSkillsField,
              fieldWidget: ReactiveValueListenableBuilder(
                formControl: _subSkillsField,
                builder: (context, field, child) {
                  final List<SubSkill?> subSkills = _subSkillsField.value ??
                      List.generate(SubSkill.maxCount, (index) => null);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap.xl,
                      ...subSkills.mapIndexed((index, subSkill) {
                        final level = SubSkill.levelList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${index + 1}. ${Display.text(subSkill?.nameI18nKey)}',
                                ),
                              ),
                              Text(
                                'Lv. $level',
                              ),
                            ],
                          ),
                        );
                      }),
                      if (_subSkillsField.hasErrors && _subSkillsField.touched)
                        Text(
                          _subSkillsField.getAnyErrorKey() ?? '',
                          // TODO: style 要決定
                          style: TextStyle(
                            color: _theme.colorScheme.error,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Gap.md,
            Row(
              children: [
                const Spacer(),
                MyElevatedButton(
                  onPressed: () async {
                    final result = await SubSkillPickerPage.go(
                      context,
                      initialValue: _subSkillsField.value,
                    );
                    if (result == null) {
                      return;
                    }
                    _subSkillsField.value = result;
                  },
                  child: Text('t_edit'.xTr),
                ),
              ],
            ),
            Gap.xl,
            ...ReactiveMyTextField.labelField(
              label: Text('t_ingredient'.xTr),
              field: Column(
                children: [
                  Gap.xl,
                  ..._buildIngredientField(
                    index: 0,
                    countField: _ingredient1CountField,
                  ),
                  ..._buildIngredientField(
                    index: 1,
                    countField: _ingredient2CountField,
                    ingredientField: _ingredient2Field,
                  ),
                  ..._buildIngredientField(
                    index: 2,
                    countField: _ingredient3CountField,
                    ingredientField: _ingredient3Field,
                  ),
                ],
              )
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

  List<Widget> _buildIngredientField({
    required int index,
    required FormControl<int> countField,
    FormControl<Ingredient>? ingredientField,
  }) {
    final basicProfile = _basicProfileField.value;
    List<(Ingredient, int)>? ingredientOptions;
    Widget field;

    if (basicProfile != null) {
      if (index == 1) {
        ingredientOptions = basicProfile.ingredientOptions2;
      } else if (index == 2) {
        ingredientOptions = basicProfile.ingredientOptions3;
      }
    }

    if (index == 0) {
      field = TextField(
        controller: _ingredientDisplayTextControllers[index],
        enabled: false,
      );
    } else if (ingredientField != null) {
      field = ReactiveMyTextField<Ingredient>(
        formControl: ingredientField,
        wrapFieldBuilder: (context, fieldWidget) {
          return IgnorePointer(
            child: fieldWidget,
          );
        },
      );
    } else {
      field = Container();
    }

    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              const AnimatedOpacity(
                opacity: 0,
                duration: Duration.zero,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 30,
                    child: TextField(),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: const Alignment(-1, 0.2),
                  child: Text(
                    '${index + 1}',
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: field,
                    ),
                    Gap.xl,
                    Expanded(
                      flex: 1,
                      child: IgnorePointer(
                        child: ReactiveMyTextField(
                          formControl: countField,
                        ),
                      ),
                    ),
                  ],
                ),
                if (ingredientOptions != null)
                  ...ingredientOptions.map((ingredientAndCount) => InkWell(
                    onTap: () {
                      ingredientField?.value = ingredientAndCount.$1;
                      countField.value = ingredientAndCount.$2;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${ingredientAndCount.$1.nameI18nKey} x${ingredientAndCount.$2}',
                      ),
                    ),
                  )),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  void _submit() async {
    if (!_form.valid) {
      _form.markAllAsTouched();
      setState(() { });
      return;
    }

    switch (widget._pageType) {
      case _PageType.create:
        _create();
        break;
      case _PageType.edit:
        break;
      case _PageType.readonly:
        break;
    }
  }

  void _create() async {
    try {
      final pokemon = await _mainViewModel.createProfile(CreatePokemonProfilePayload(
        basicProfileId: _basicProfileField.value!.id,
        character: _characterField.value!,
        subSkills: _subSkillsField.value!,
        ingredient2: _ingredient2Field.value!,
        ingredientCount2: _ingredient2CountField.value!,
        ingredient3: _ingredient3Field.value!,
        ingredientCount3: _ingredient3CountField.value!,
      ));

      debugPrint(pokemon.getConstructorCode());
      DialogUtility.text(
        context,
        title: Text('t_create_success'.xTr),
        content: Text('t_continue_to_create_next_or_back_manually'.xTr),
      );
    } catch (e) {
      DialogUtility.text(
        context,
        title: Text('t_create_failed'.xTr),
      );
    }
  }

  void _update() async {
    try {
      final profile = _profile;
      if (profile == null) {
        throw Exception();
      }

      final newProfile = profile.copyWith(
        character: _characterField.value!,
        subSkillLv10: _subSkillsField.value![0],
        subSkillLv25: _subSkillsField.value![1],
        subSkillLv50: _subSkillsField.value![2],
        subSkillLv75: _subSkillsField.value![3],
        subSkillLv100: _subSkillsField.value![4],
        ingredient2: _ingredient2Field.value!,
        ingredientCount2: _ingredient2CountField.value!,
        ingredient3: _ingredient3Field.value!,
        ingredientCount3: _ingredient3CountField.value!,
      );

      final pokemon = await _mainViewModel.updateProfile(newProfile);
      debugPrint(pokemon.getConstructorCode());
      // DialogUtility.text(
      //   context,
      //   title: Text('t_create_success'.xTr),
      //   content: Text('t_continue_to_create_next_or_back_manually'.xTr),
      // );
    } catch (e) {
      // DialogUtility.text(
      //   context,
      //   title: Text('t_create_failed'.xTr),
      // );
    }
  }
}

