import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/map/map_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/sleep_face_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:provider/provider.dart';

class _PokemonBasicProfilePageArgs {
  _PokemonBasicProfilePageArgs(this.basicProfile);

  final PokemonBasicProfile basicProfile;
}

/// TODO: 妙蛙種子#1，食材機率 25.63% (1:3.902)
/// TODO: 反查寶可夢盒
///
/// 攻略網站：會附上各種睡姿的圖片、
///
/// TODO: 反查睡姿的地圖
/// TODO: 收藏 "睡姿" 功能
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

  final _PokemonBasicProfilePageArgs _args;

  @override
  State<PokemonBasicProfilePage> createState() => _PokemonBasicProfilePageState();
}

class _PokemonBasicProfilePageState extends State<PokemonBasicProfilePage> {
  SleepFaceRepository get _sleepFaceRepo => getIt();
  EvolutionRepository get _evolutionRepo => getIt();
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;

  // UI
  late ThemeData _theme;

  // Page status
  var _initialized = false;

  // Data
  final _sleepFacesOfField = <PokemonField, List<SleepFace>>{};

  /// [SleepFace.style] to its nama
  var _sleepNamesOfBasicProfile = <int, String>{};

  var _existInBox = false;

  var _currPokemonLevel = 1;

  List<List<Evolution>> _evolutions = List.generate(MAX_POKEMON_EVOLUTION_STAGE, (index) => []);

  var _basicProfilesInEvolutionChain = <int, PokemonBasicProfile>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
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

      final evolutions = await _evolutionRepo.findByBasicProfileId(_basicProfile.id);
      _evolutions = evolutions;

      final basicProfileIdInEvolutionChain = evolutions
          .expand((e) => e)
          .map((e) => e.basicProfileId)
          .toList();

      _basicProfilesInEvolutionChain = await _basicProfileRepo
          .findByIdList(basicProfileIdInEvolutionChain); // _evolutions

      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;

    if (!_initialized) {
      return LoadingView();
    }

    final screenSize = MediaQuery.of(context).size;
    final leadingWidth = math.min(screenSize.width * 0.3, 150.0);

    Widget buildWithLabel({
      required String text,
      required Widget child,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      appBar: buildAppBar(
        title: Row(
          children: [
            // PokemonTypeIcon(type: _basicProfile.pokemonType),
            if (_existInBox)
              const Padding(
                padding: EdgeInsets.only(right: Gap.mdV),
                child: PokemonRecordedIcon(),
              ),
            Expanded(
              child: Text(
                // TODO: 攻略網站的 "#圖鑑編號" 會比較小、且為灰色
                '${_basicProfile.nameI18nKey.xTr} #${_basicProfile.boxNo}',
              ),
            ),
          ],
        ),
      ),
      body: Consumer2<MainViewModel, SleepFaceViewModel>(
        builder: (context, mainViewModel, sleepFaceViewModel, child) {
          final profiles = mainViewModel.profiles;
          final markStyles = sleepFaceViewModel.markStylesOf[_basicProfile.id] ?? [];
          // 食材 1,2,3

          return buildListView(
            padding: const EdgeInsets.symmetric(
              horizontal: HORIZON_PADDING,
            ),
            children: [
              MySubHeader(
                titleText: 't_abilities'.xTr,
              ),
              Gap.md,
              buildWithLabel(
                text: 't_sleep_type'.xTr,
                child: Text(_basicProfile.sleepType.nameI18nKey.xTr),
              ),
              Gap.md,
              buildWithLabel(
                text: 't_specialty'.xTr,
                child: Text(_basicProfile.specialty.nameI18nKey.xTr),
              ),
              Gap.md,
              buildWithLabel(
                text: 't_fruit'.xTr,
                child: Text(_basicProfile.fruit.nameI18nKey.xTr),
              ),
              Gap.md,
              // TODO: 主技能反查
              buildWithLabel(
                text: 't_main_skill'.xTr,
                child: Text(_basicProfile.mainSkill.nameI18nKey.xTr),
              ),
              Gap.md,
              buildWithLabel(
                text: 't_help_interval_base'.xTr,
                child: Text(Display.numInt(_basicProfile.helpInterval)),
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
              if (kDebugMode)
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
              Text(
                '1. ${_basicProfile.ingredient1.nameI18nKey.xTr}\n'
                    '2. ${_basicProfile.ingredientOptions2.map((e) => '${e.$1.nameI18nKey.xTr} x${e.$2}').join(', ')}\n'
                    '3. ${_basicProfile.ingredientOptions3.map((e) => '${e.$1.nameI18nKey.xTr} x${e.$2}').join(', ')}',
              ),
              // TODO: 顯示各項組合，使用水平滑動可能比較好讀
              Gap.md,
              MySubHeader(
                titleText: 't_evolution'.xTr,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildEvolutions(_evolutions),
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
                            const IslandIcon(),
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
              Gap.trailing,
            ],
          );
        },
      ),
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
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: Gap.smV),
                    child: CandyIcon(size: 16,),
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

  Widget _buildEvolutions(List<List<Evolution>> evolutionsStages) {
    List<Widget> x(int index, List<Evolution> e, Iterable<List<Evolution>> list) {
      return [
        ..._buildEvolutionStage(e, index == 0 ? null : evolutionsStages[index - 1]),
        if (index != list.length - 1)
          const Icon(Icons.arrow_right),
      ];
    }

    return Row(
      children: [
        ...evolutionsStages
            .where((element) => element.isNotEmpty)
            .xMapIndexed(x)
            .expand((e) => e),
      ],
    );
  }

  List<Widget> _buildEvolutionStage(List<Evolution> evolutionsStage, List<Evolution>? preEvolution) {
    final stages = (preEvolution ?? []).map((e) => e.nextStages).expand((e) => e);
    final basicProfileIdToStage = stages.toMap((p0) => p0.basicProfileId, (stage) => stage);

    return [
      ...evolutionsStage
          .map((e) => (e, _basicProfilesInEvolutionChain[e.basicProfileId]!))
          .whereNotNull()
          .map((e) => _buildEvolutionItem(e, basicProfileIdToStage[e.$2.id])),
    ];
  }

  Widget _buildEvolutionItem((Evolution, PokemonBasicProfile) entry, EvolutionStage? stage) {
    final (evolution, basicProfile) = entry;
    final isCurrent = _basicProfile.id == basicProfile.id;

    List<Widget> conditionsItems;

    if (stage == null) {
      conditionsItems = [];
    } else {
      conditionsItems = stage.conditions
          .whereType<EvolutionConditionRaw>()
          .map((e) => _buildEvolutionCondition(e))
          .toList();
    }

    return InkWell(
      onTap: isCurrent ? null : () {
        PokemonBasicProfilePage.go(context, basicProfile);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              basicProfile.nameI18nKey.xTr,
            ),
            ...conditionsItems,
          ],
        ),
      ),
    );
  }

  Widget _buildEvolutionCondition(EvolutionConditionRaw condition) {
    final values = condition.values;
    List<Widget>? children;

    // "candy,level"
    // "level,candy"
    // "item,candy"
    // "item,candy,item"
    // "timing,sleepTime,candy"
    // "sleepTime,candy"
    // "candy,sleepTime"
    // "candy,sleepTime,timing"

    switch (values['type']) {
      case 'candy':
        children = [
          const CandyIcon(),
          Text(Display.numInt(values['count'] ?? 0)),
        ];
        break;
      case 'level':
        children = [
          const LevelIcon(size: 20,),
          Text(Display.numInt(values['level'] ?? 0)),
        ];
        break;
      case 'sleepTime':
        children = [
          const Iconify(
            Tabler.zzz, color: positiveColor,
          ),
          Text('${Display.numInt(values['hours'] ?? 0)}小時'),
        ];
        break;
      case 'item':
        children = [
          Text(GameItem.getById(values['item'])?.nameI18nKey.xTr ?? Display.placeHolder),
        ];
        break;
      case 'timing':
        children = [
          const Icon(Icons.access_time_rounded, color: greenColor,),
          Text(
            '${values['startHour']} ~ ${values['endHour']}'
          ),
        ];
        break;
    }

    if (children != null) {
      return Row(children: children);
    }

    return Text(condition.values.toString());
  }

}


