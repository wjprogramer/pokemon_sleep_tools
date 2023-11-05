import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/form/validation/validation.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/character_list/characters_list_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient_picker/ingredient_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile_picker/pokemon_basic_profile_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/sub_skill_picker/sub_skill_picker_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/styles.dart';
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

/// TODO: [PokemonProfile.customNote]
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
  late FormControl<String?> _customNameField;
  late FormControl<bool> _shinyField;
  late FormControl<List<SubSkill?>> _subSkillsField;
  late FormControl<DateTime> _customDateField;

  late FormControl<Ingredient> _ingredient1Field;
  late FormControl<Ingredient> _ingredient2Field;
  late FormControl<Ingredient> _ingredient3Field;

  late FormControl<int> _ingredient1CountField;
  late FormControl<int> _ingredient2CountField;
  late FormControl<int> _ingredient3CountField;

  @override
  void initState() {
    super.initState();
    _initForm();

    scheduleMicrotask(() async {
      // 先初始化資料，再新增 listener (避免因 listener 被 trigger 後清空欄位)
      await _initData();

      _basicProfileField.valueChanges.listen((basicProfile) {
        _ingredientDisplayTextControllers[0].text =
            Display.text(basicProfile?.ingredient1.nameI18nKey.xTr);

        _ingredient1CountField.value = basicProfile?.ingredientCount1;
        _ingredient1Field.value = basicProfile?.ingredient1;
        _ingredient2CountField.value = null;
        _ingredient2Field.value = null;
        _ingredient3CountField.value = null;
        _ingredient3Field.value = null;

        setState(() { });
      });

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
    _customNameField = FormControl();
    _shinyField = FormControl();
    _customDateField = FormControl();
    _subSkillsField = FormControl(
      validators: [
        Validators.required,
        MyValidators.iterableLength(SubSkill.maxCount),
      ],
    );

    _ingredient1Field = FormControl(
      validators: [ Validators.required ],
      disabled: true,
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
      '_customNameField': _customNameField,
      '_shinyField': _shinyField,
      '_customDateField': _customDateField,
      '_subSkills': _subSkillsField,
      '_ingredient1': _ingredient1Field,
      '_ingredient2': _ingredient2Field,
      '_ingredient3': _ingredient3Field,
      '_ingredient1Count': _ingredient1CountField,
      '_ingredient2Count': _ingredient2CountField,
      '_ingredient3Count': _ingredient3CountField,
    });

    _ingredient2Field.valueChanges.listen((_) {
      // 更新 field icon
      setState(() { });
    });
    _ingredient3Field.valueChanges.listen((_) {
      // 更新 field icon
      setState(() { });
    });

  }

  Future<void> _initData() async {
    final profile = _profile;
    if (widget._pageType != _PageType.edit || profile == null) {
      return;
    }

    _basicProfileField.value = profile.basicProfile;
    _characterField.value = profile.character;
    _customNameField.value = profile.customName;
    _shinyField.value = profile.isShiny;
    _customDateField.value = profile.customDate;
    _subSkillsField.value = profile.subSkills;

    _ingredient1Field.value = profile.ingredient1;
    _ingredient2Field.value = profile.ingredient2;
    _ingredient3Field.value = profile.ingredient3;

    _ingredient1CountField.value = profile.ingredientCount1;
    _ingredient2CountField.value = profile.ingredientCount2;
    _ingredient3CountField.value = profile.ingredientCount3;
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (widget._pageType.isMutate) {
          final result = await DialogUtility.confirm(
            context,
            title: Text('t_leave_without_saving'.xTr),
            content: Text('t_leave_without_saving_content'.xTr),
          );
          return result;
        }
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(
          titleText: _getTitleText(),
        ),
        body: ReactiveForm(
          formGroup: _form,
          child: buildListView(
            children: [
              ...Hp.list(
                children: [
                  MySubHeader(
                    titleText: 't_basic_information'.xTr,
                  ),
                  Gap.xl,
                  Row(
                    children: [
                      Expanded(
                        child: ReactiveMyTextField<PokemonBasicProfile>(
                          label: 't_pokemon'.xTr,
                          formControl: _basicProfileField,
                          wrapFieldBuilder: (context, fieldWidget) {
                            return InkWell(
                              onTap: () async {
                                // TODO: 要可以改進化前後的寶可夢，例如原本是皮卡丘，進來後要可以改成皮丘或雷丘
                                final baseProfile = await PokemonBasicProfilePicker.go(context);
                                if (baseProfile == null) {
                                  return;
                                }
                                _basicProfileField.value = baseProfile;
                              },
                              child: IgnorePointer(
                                child: fieldWidget,
                              ),
                            );
                          },
                        ),
                      ),
                      if (_basicProfileField.value != null && MyEnv.USE_DEBUG_IMAGE)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: greyColor,
                              ),
                              color: whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 15,
                                  color: _theme.shadowColor.withOpacity(.05),
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: PokemonIconImage(
                              basicProfile: _basicProfileField.value!,
                              width: 64,
                              disableTooltip: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                  // _customNameField
                  Gap.xl,
                  ...ReactiveMyTextField.labelField(
                    label: Text('t_custom_name'.xTr),
                    field: ReactiveMyTextField(
                      formControl: _customNameField,
                    ),
                  ),
                  Gap.xl,
                  ...ReactiveMyTextField.labelField(
                      label: Text('t_ingredient'.xTr),
                      field: Column(
                        children: [
                          Gap.xl,
                          ..._buildIngredientField(
                            index: 0,
                            ingredientField: _ingredient1Field,
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
                  Gap.xl,
                  ReactiveMyTextField<List<SubSkill?>>(
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
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${index + 1}. ',
                                            ),
                                            TextSpan(
                                              text: Display.text(subSkill?.nameI18nKey.xTr),
                                              style: TextStyle(
                                                color: subSkill == null ? _theme.disabledColor : null,
                                                backgroundColor: subSkill?.bgColor,
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ReactiveMyTextField<PokemonCharacter>(
                    label: 't_character'.xTr,
                    formControl: _characterField,
                    wrapFieldBuilder: (context, fieldWidget) {
                      return InkWell(
                        onTap: () async {
                          final result = await CharacterListPage.pick(context);
                          // final result = await CommonPickerPage.go<PokemonCharacter>(
                          //   context,
                          //   options: PokemonCharacter.values,
                          //   optionBuilder: (context, character) {
                          //     return Text(character.nameI18nKey);
                          //   },
                          // );
                          if (result == null) {
                            return;
                          }
                          _characterField.value = result;
                        },
                        child: IgnorePointer(
                          child: fieldWidget,
                        ),
                      );
                    },
                  ),
                  ReactiveValueListenableBuilder(
                    formControl: _characterField,
                    builder: (context, control, child) {
                      final character = control.value;
                      if (character == null) {
                        return Container();
                      }

                      final positiveEffect = character.positiveEffect;
                      final negativeEffect = character.negativeEffect;
                      if (positiveEffect == CharacterEffect.none && negativeEffect == CharacterEffect.none) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '沒有因性格帶來的特色'.xTr, style: TextStyle(color: _theme.disabledColor),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text.rich(
                          TextSpan(
                            style: _theme.textTheme.bodySmall?.copyWith(
                              color: greyColor3,
                            ),
                            children: [
                              if (positiveEffect != CharacterEffect.none) ...[
                                TextSpan(
                                  text: positiveEffect.nameI18nKey.xTr,
                                ),
                                const WidgetSpan(
                                  child: Icon(Icons.keyboard_arrow_up, color: dangerColor, size: 14,),
                                ),
                              ],
                              if (negativeEffect != CharacterEffect.none) ...[
                                if (positiveEffect != CharacterEffect.none)
                                  TextSpan(
                                    text: '、'.xTr,
                                  ),
                                TextSpan(
                                  text: negativeEffect.nameI18nKey.xTr,
                                ),
                                const WidgetSpan(
                                  child: Icon(Icons.keyboard_arrow_down, color: positiveColor, size: 14,),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  MySubHeader(
                    titleText: 't_others'.xTr,
                  ),
                ],
              ),
              MyListTile(
                title: Text(
                  '是否異色'.xTr,
                ),
                checked: _shinyField.value ?? false,
                onCheckedChanged: (v) {
                  setState(() {
                    _shinyField.value = v ?? false;
                  });
                },
              ),
              Gap.sm,
              Hp(
                child: ReactiveMyTextField(
                  label: '登錄日期'.xTr,
                  formControl: _customDateField,
                  valueAccessor: MyDateTimeValueAccessor(DateFormatType.date),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  wrapFieldBuilder: (context, fieldWidget) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final res = await showDatePicker(
                                context: context,
                                // 7/19 是台灣上線日期
                                initialDate: _customDateField.value ?? MyTimezone.clientNow,
                                firstDate: DateTime(2023, 7, 19),
                                lastDate: MyTimezone.clientNow,
                              );

                              if (res == null) {
                                return;
                              }
                              _customDateField.value = res;
                            },
                            child: IgnorePointer(
                              child: fieldWidget,
                            ),
                          ),
                        ),
                        Gap.md,
                        ReactiveValueListenableBuilder(
                          formControl: _customDateField,
                          builder: (context, control, child) {
                            final date = control.value;

                            return AnimatedOpacity(
                              opacity: date == null ? 0 : 1,
                              duration: const Duration(milliseconds: 200),
                              child: IconButton(
                                onPressed: () {
                                  _customDateField.value = null;
                                },
                                icon: const Icon(Icons.clear),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
              Gap.trailing,
            ],
          ),
        ),
        bottomNavigationBar: BottomBarWithConfirmButton(
          submit: _submit,
        ),
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
    List<(Ingredient, int)> ingredientOptions = [];
    Widget field;

    if (basicProfile != null) {
      if (index == 1) {
        ingredientOptions = basicProfile.ingredientOptions2;
      } else if (index == 2) {
        ingredientOptions = basicProfile.ingredientOptions3;
      }
    }

    final ignoringIngredientField = index == 0 || ingredientOptions.isNotEmpty;

    if (ingredientField != null) {
      field = ReactiveMyTextField<Ingredient>(
        formControl: ingredientField,
        wrapFieldBuilder: (context, fieldWidget) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: index == 0 || ignoringIngredientField ? null : () async {
              final pickedIngredient = await IngredientPickerPage.pick(context);
              if (pickedIngredient == null) {
                return;
              }
              ingredientField.value = pickedIngredient;
            },
            child: IgnorePointer(child: fieldWidget),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: field,
                    ),
                    Gap.xl,
                    Expanded(
                      flex: 1,
                      child: IgnorePointer(
                        ignoring: ignoringIngredientField,
                        child: ReactiveMyTextField(
                          formControl: countField,
                        ),
                      ),
                    ),
                  ],
                ),
                ...ingredientOptions.map((ingredientAndCount) => InkWell(
                  onTap: () {
                    ingredientField?.value = ingredientAndCount.$1;
                    countField.value = ingredientAndCount.$2;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: countField.value == ingredientAndCount.$2 && ingredientField?.value == ingredientAndCount.$1
                        ? primaryColor.withOpacity(.09)
                        : null,
                    child: Row(
                      children: [
                        if (MyEnv.USE_DEBUG_IMAGE)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Opacity(
                              opacity: 0.5,
                              child: IngredientImage(
                                ingredient: ingredientAndCount.$1,
                                size: 24,
                                disableTooltip: true,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            '${ingredientAndCount.$1.nameI18nKey.xTr} x${ingredientAndCount.$2}',
                          ),
                        ),
                      ],
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
        _update();
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
        customName: _customNameField.value,
        customNote: null,
        isFavorite: false, // TODO:
        isShiny: _shinyField.value ?? false,
        customDate: _customDateField.value,
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
        actions: [
          TextButton(
            onPressed: () {
              context.nav.pop();
            },
            child: Text('繼續新增下一筆'.xTr),
          ),
          TextButton(
            onPressed: () {
              context.nav.pop();
              context.nav.pop();
            },
            child: Text('t_confirm'.xTr),
          ),
        ],
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
        customName: _customNameField.value,
        customNote: null,
        isFavorite: profile.isFavorite,
        isShiny: _shinyField.value ?? false,
        customDate: _customDateField.value,
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
      context.nav.pop();
    } catch (e) {
      DialogUtility.text(
        context,
        title: Text('t_update_failed'.xTr),
      );
    }
  }
}

