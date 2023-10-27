import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skill/main_skill_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/map/map_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/specialty_info/specialty_info_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/sleep_face_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:provider/provider.dart';

class _PokemonBasicProfilePageArgs {
  _PokemonBasicProfilePageArgs(this.basicProfile, {
    this.isView = false,
  });

  final PokemonBasicProfile basicProfile;
  final bool isView;
}

/// TODO: 妙蛙種子#1，食材機率 25.63% (1:3.902)
/// TODO: 反查寶可夢盒
///
/// 攻略網站：會附上各種睡姿的圖片、
class PokemonBasicProfilePage extends StatefulWidget {
  const PokemonBasicProfilePage._(this._args);

  static const MyPageRoute route = ('/PokemonBasicProfilePage', _builder);
  static Widget _builder(dynamic args) {
    return PokemonBasicProfilePage._(args);
  }

  static void go(BuildContext context, PokemonBasicProfile basicProfile) {
    context.nav.push(
      route,
      arguments: _PokemonBasicProfilePageArgs(basicProfile),
    );
  }

  static Widget buildView(PokemonBasicProfile basicProfile) {
    return PokemonBasicProfilePage._(
      _PokemonBasicProfilePageArgs(
        basicProfile, isView: true,
      ),
    );
  }

  final _PokemonBasicProfilePageArgs _args;

  @override
  State<PokemonBasicProfilePage> createState() => _PokemonBasicProfilePageState();
}

class _PokemonBasicProfilePageState extends State<PokemonBasicProfilePage> {
  SleepFaceRepository get _sleepFaceRepo => getIt();
  EvolutionRepository get _evolutionRepo => getIt();
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;
  bool get _isView => widget._args.isView;

  // UI
  late ThemeData _theme;

  // Page status
  var _initialized = false;

  // Data (fixed)
  var _basicIdSetGroupByField = <PokemonField, Set<int>>{};

  // Data
  final _sleepFacesOfField = <PokemonField, List<SleepFace>>{};

  /// [SleepFace.style] to its nama
  var _sleepNamesOfBasicProfile = <int, String>{};

  var _existInBox = false;

  var _currPokemonLevel = 1;
  double? _ingredientRate;

  // Data evolutions
  List<List<Evolution>> _evolutions = List.generate(MAX_POKEMON_EVOLUTION_STAGE, (index) => []);

  var _basicProfilesInEvolutionChain = <int, PokemonBasicProfile>{};

  late PokemonBasicProfile _basicProfileWithSmallestBoxNoInChain;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _load();
    });
  }

  Future<void> _load() async {
    // Clear or reset
    _initialized = false;
    _basicProfileWithSmallestBoxNoInChain = _basicProfile;
    _sleepFacesOfField.clear();
    for (final field in PokemonField.values) {
      _sleepFacesOfField[field] = [];
    }

    final mainViewModel = context.read<MainViewModel>();
    final profiles = await mainViewModel.loadProfiles();
    _existInBox = profiles.any((element) => element.basicProfileId == _basicProfile.id);

    final allSleepFaces = await _sleepFaceRepo.findAll();
    final sleepFaces = allSleepFaces.where((sleepFace) => sleepFace.basicProfileId == _basicProfile.id).toList();

    final allSleepNames = await _sleepFaceRepo.findAllNames();
    _sleepNamesOfBasicProfile = allSleepNames[_basicProfile.id] ?? {};

    for (final sleepFace in sleepFaces) {
      _sleepFacesOfField[sleepFace.field]?.add(sleepFace);
    }

    final sleepFacesGroupByField = await _sleepFaceRepo.findAllGroupByField();
    final basicIdSetGroupByField = sleepFacesGroupByField.toMap(
          (field, basicProfiles) => field,
          (field, basicProfiles) => {...basicProfiles.map((e) => e.basicProfileId)},
    );
    _basicIdSetGroupByField = basicIdSetGroupByField;

    final evolutions = await _evolutionRepo.findByBasicProfileId(_basicProfile.id);
    _evolutions = evolutions;

    final basicProfileIdInEvolutionChain = evolutions
        .expand((e) => e)
        .map((e) => e.basicProfileId)
        .toList();

    _basicProfilesInEvolutionChain = await _basicProfileRepo
        .findByIdList(basicProfileIdInEvolutionChain); // _evolutions
    _basicProfileWithSmallestBoxNoInChain = _basicProfilesInEvolutionChain
        .entries.map((e) => e.value)
        .firstWhereByCompare((a, b) => a.boxNo < b.boxNo);

    _ingredientRate = (await _basicProfileRepo.findAllIngredientRateOf())[_basicProfile.id];

    _initialized = true;
    if (mounted) {
      setState(() { });
    }
  }

  @override
  void didUpdateWidget(covariant PokemonBasicProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;

    if (!_initialized) {
      return LoadingView(
        isView: _isView,
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final leadingWidth = math.min(screenSize.width * 0.3, 150.0);

    Widget buildWithLabel({
      required String text,
      required Widget child,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    }) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            constraints: BoxConstraints.tightFor(width: leadingWidth),
            child: DefaultTextStyle(
              style: _theme.textTheme.bodySmall ?? const TextStyle(),
              child: MyLabel(
                text: text,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: MyLabel.verticalPaddingValue),
              child: child,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: _isView ? null : buildAppBar(
        title: _buildAppBarTitle(),
      ),
      body: Consumer2<MainViewModel, SleepFaceViewModel>(
        builder: (context, mainViewModel, sleepFaceViewModel, child) {
          final profiles = mainViewModel.profiles;
          final markStyles = sleepFaceViewModel.markStylesOf[_basicProfile.id] ?? [];
          // 食材 1,2,3

          Widget mainBodyContent = buildListView(
            padding: const EdgeInsets.symmetric(
              horizontal: HORIZON_PADDING,
            ),
            children: [
              if (MyEnv.USE_DEBUG_IMAGE)
                SizedBox(
                  height: 200,
                  child: PokemonImage(
                    basicProfile: _basicProfile,
                    fit: BoxFit.fitHeight,
                    disableTooltip: true,
                  ),
                ),
              MySubHeader(
                titleText: 't_abilities'.xTr,
              ),
              Gap.md,
              buildWithLabel(
                text: 't_sleep_type'.xTr,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SleepTypeLabel(
                    sleepType: _basicProfile.sleepType,
                  ),
                ),
              ),
              Gap.md,
              buildWithLabel(
                text: 't_specialty'.xTr,
                crossAxisAlignment: CrossAxisAlignment.center,
                child: Row(
                  children: [
                    SpecialtyLabel(
                      specialty: _basicProfile.specialty,
                    ),
                    Spacer(),
                    if (kDebugMode)
                      IconButton(
                        onPressed: () {
                          SpecialtyInfoPage.go(context);
                        },
                        icon: Icon(
                          Icons.info_outline,
                          color: greyColor2,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
              Gap.md,
              buildWithLabel(
                text: 't_fruit'.xTr,
                child: Row(
                  children: [
                    if (MyEnv.USE_DEBUG_IMAGE)
                      Padding(
                        padding: const EdgeInsets.only(right: Gap.smV),
                        child: FruitImage(
                          fruit: _basicProfile.fruit,
                          width: 24,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        '${_basicProfile.fruit.nameI18nKey.xTr} (${'機率'.xTr}: ${Display.numDouble(_ingredientRate == null ? null : 100.0 - _ingredientRate!)}%)'
                      ),
                    ),
                  ],
                ),
              ),
              Gap.md,
              // TODO: 主技能反查
              buildWithLabel(
                text: 't_main_skill'.xTr,
                child: InkWell(
                  onTap: () {
                    MainSkillPage.go(context, _basicProfile.mainSkill);
                  },
                  child: Text(_basicProfile.mainSkill.nameI18nKey.xTr),
                ),
              ),
              Gap.md,
              buildWithLabel(
                text: 't_help_interval_base'.xTr,
                child: Text(Display.numInt(_basicProfile.maxHelpInterval)),
              ),
              Gap.md,
              buildWithLabel(
                text: 't_abilities'.xTr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Text(Display.numInt(_basicProfile.helpInterval))
                    Row(
                      children: [
                        FriendPointsIcon(),
                        Gap.md,
                        Expanded(
                          child: Text(Display.numInt(_basicProfile.friendshipPoints)),
                        ),
                      ],
                    ),
                    Gap.sm,
                    Row(
                      children: [
                        Text('t_max_carry'.xTr),
                        Gap.md,
                        Expanded(
                          child: Text(Display.numInt(_basicProfile.maxCarry)),
                        ),
                      ],
                    ),
                    Text(
                        '成為夥伴報酬: ${_basicProfile.recruitRewards.exp}, ${_basicProfile.recruitRewards.shards}'
                    ),
                  ],
                ),
              ),
              Gap.md,
              MySubHeader(
                titleText: 't_ingredients'.xTr,
              ),
              // TODO: 反查食材
              if (kDebugMode && !kDebugMode)
                SliderWithButtons(
                  value: _currPokemonLevel.toDouble(),
                  onChanged: (v) {
                    _currPokemonLevel = v.toInt();
                    setState(() { });
                  },
                  max: 60,
                  min: 1,
                  divisions: 59,
                  hideSlider: true,
                ),
              // TODO: 顯示各項組合，使用水平滑動可能比較好讀
              _buildIngredientsUnderLevel(1, [ (_basicProfile.ingredient1, _basicProfile.ingredientCount1) ]),
              _buildIngredientsUnderLevel(30, _basicProfile.ingredientOptions2),
              _buildIngredientsUnderLevel(60, _basicProfile.ingredientOptions3),
              Gap.md,
              MySubHeader(
                titleText: 't_evolution'.xTr,
              ),
              EvolutionsView(
                _evolutions,
                basicProfile: _basicProfile,
                basicProfilesInEvolutionChain: _basicProfilesInEvolutionChain,
                basicProfileWithSmallestBoxNoInChain: _basicProfileWithSmallestBoxNoInChain,
              ),
              Gap.md,
              MySubHeader(
                titleText: 't_sleep_faces'.xTr,
              ),
              Gap.md,
              ..._sleepFacesOfField.entries.where((e) => e.value.isNotEmpty).map((e) {
                final field = e.key;
                final sleepFaces = e.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () {
                        MapPage.go(context, field);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          8, 8, 8, Gap.smV,
                        ),
                        child: Row(
                          children: [
                            const FieldMenuIcon(),
                            Gap.md,
                            Expanded(
                              child: Text(
                                field.nameI18nKey.xTr,
                              ),
                            ),
                            // Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Gap.xs,
                          ...sleepFaces.map((sleepFace) => _buildSleepFace(sleepFace, markStyles)),
                          Gap.md,
                        ],
                      ),
                    ),
                  ],
                );
              }),
              MySubHeader(
                titleText: '其他'.xTr,
              ),
              MyElevatedButton(
                onPressed: !_existInBox ? null : () {
                  PokemonBoxPage.go(
                    context,
                    initialSearchOptions: PokemonSearchOptions(
                      keyword: _basicProfile.nameI18nKey.xTr,
                    ),
                  );
                },
                child: Text('查看寶可夢盒'),
              ),
              Gap.trailing,
            ],
          );

          if (_isView) {
            mainBodyContent = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      Gap.h,
                      Expanded(child: _buildAppBarTitle()),
                    ],
                  ),
                ),
                Expanded(child: mainBodyContent),
              ],
            );
          }

          return mainBodyContent;
        },
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        if (MyEnv.USE_DEBUG_IMAGE)
          Padding(
            padding: const EdgeInsets.only(right: Gap.mdV),
            child: PokemonTypeImage(
              pokemonType: _basicProfile.pokemonType,
              width: 24,
            ),
          ),
        if (_existInBox)
          const Padding(
            padding: EdgeInsets.only(right: Gap.mdV),
            child: PokemonRecordedIcon(),
          ),
        Expanded(
          child: Text(
            // TODO: 攻略網站的 "#圖鑑編號" 會比較小、且為灰色
            '${_basicProfile.nameI18nKey.xTr} #${_basicProfile.boxNo}',
            style: _isView ? _theme.appBarTheme.titleTextStyle : null,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsUnderLevel(int level, List<(Ingredient, int)> ingredients) {
    Widget buildLevel(int level) {
      return Text(
        'Lv $level',
      );
    }

    Widget buildIngredient(Ingredient ingredient, int count) {
      return InkWell(
        onTap: () => IngredientPage.go(context, ingredient),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (MyEnv.USE_DEBUG_IMAGE)
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: IngredientImage(
                  ingredient: ingredient,
                  width: 32,
                  disableTooltip: true,
                ),
              ),
            Text(ingredient.nameI18nKey.xTr),
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          children: [
            Opacity(
              opacity: 0,
              child: buildLevel(999),
            ),
            buildLevel(level),
          ],
        ),
        Gap.sm,
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ...ingredients.map((e) => buildIngredient(e.$1, e.$2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSleepFace(SleepFace sleepFace, List<int> markStyles) {
    final marked = markStyles.contains(sleepFace.style);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                final facesViewModels = context.read<SleepFaceViewModel>();

                if (markStyles.contains(sleepFace.style)) {
                  facesViewModels.removeMark(sleepFace.basicProfileId, sleepFace.style);
                } else {
                  facesViewModels.mark(sleepFace.basicProfileId, sleepFace.style);
                }
              },
              icon: BookmarkIcon(marked: marked),
            ),
            Text(
              _sleepNamesOfBasicProfile[sleepFace.style] ?? _sleepFaceRepo.getCommonSleepFaceName(sleepFace.style) ?? '',
            ),
            Gap.md,
            SnorlaxRankItem(rank: sleepFace.snorlaxRank),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48),
          child: RichText(
            text: TextSpan(
              text: '',
              style: _theme.textTheme.bodyMedium,
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: Gap.smV),
                    child: CandyOfPokemonIcon(
                      size: 16,
                      boxNo: _basicProfileWithSmallestBoxNoInChain.boxNo,
                    ),
                  ),
                ),
                TextSpan(
                  text: '${sleepFace.rewards.candy}',
                ),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Gap.mdV,
                      right: Gap.smV,
                    ),
                    child: DreamChipIcon(size: 16,),
                  ),
                ),
                TextSpan(
                  text: '${sleepFace.rewards.shards}',
                ),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Gap.mdV,
                      right: Gap.smV,
                    ),
                    child: XpIcon(size: 16,),
                  ),
                ),
                TextSpan(
                  text: '${sleepFace.rewards.exp}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


