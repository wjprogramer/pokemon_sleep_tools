import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/view_models.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

class _PageArgs {
  _PageArgs({
    required this.teamIndex,
  });

  final int teamIndex;
}

class TeamAnalysisPage extends StatefulWidget {
  const TeamAnalysisPage._(this._args);

  static const MyPageRoute route = ('/TeamAnalysisPage', _builder);
  static Widget _builder(dynamic args) {
    return TeamAnalysisPage._(args);
  }

  static void go(BuildContext context, int teamIndex) {
    context.nav.push(
      route,
      arguments: _PageArgs(teamIndex: teamIndex),
    );
  }

  final _PageArgs _args;

  @override
  State<TeamAnalysisPage> createState() => _TeamAnalysisPageState();
}

class _TeamAnalysisPageState extends State<TeamAnalysisPage> {
  int get _teamIndex => widget._args.teamIndex;

  // Page status
  final _disposers = <MyDisposable>[];
  var _isInitialized = false;

  // Data
  var _profileOf = <int, PokemonProfile>{};
  PokemonTeam? _team;

  // Data (Calculated)
  final _ingredientsMapLv1 = <Ingredient, int>{};
  final _ingredientsMapLv30 = <Ingredient, int>{};
  final _ingredientsMapLv60 = <Ingredient, int>{};
  final _fruitSet = Set<Fruit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mainViewModel = context.read<MainViewModel>();
      final teamViewModel = context.read<TeamViewModel>();

      _disposers.addAll([
        mainViewModel.xAddListener(_listenMainViewModel),
        teamViewModel.xAddListener(_listenTeamViewModel)
      ]);

      await Future.wait([
        mainViewModel.loadProfiles(),
        teamViewModel.loadTeams(),
      ]);

      _team = teamViewModel.teams[_teamIndex];
      _analysis();
      _isInitialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    super.dispose();
  }

  void _listenTeamViewModel() {
    final teamViewModel = context.read<TeamViewModel>();
    _team = teamViewModel.teams[_teamIndex]!;

    _analysis();
    setState(() { });
  }

  void _listenMainViewModel() {
    final mainViewModel = context.read<MainViewModel>();
    _profileOf = mainViewModel.profiles
        .toMap((profile) => profile.id, (profile) => profile);

    _analysis();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    final team = _team;

    if (team == null) {
      return Scaffold(
        body: Center(child: Text('t_none'.xTr)),
      );
    }

    if (!_isInitialized) {
      return LoadingView();
    }


    final profileIdList = team.profileIdList;
    final profiles = profileIdList.map((e) => _profileOf[e]).toList();
    final profilesNotNull = profiles.whereNotNull().toList();

    return Scaffold(
      appBar: buildAppBar(
        titleText: _getCurrTeamName(),
      ),
      body: buildListView(
        padding: const EdgeInsets.symmetric(
          horizontal: HORIZON_PADDING,
        ),
        children: [
          Container(
            constraints: const BoxConstraints.tightFor(
              height: 100,
            ),
            child: Row(
              children: [
                ...profiles.mapIndexed((index, profile) => <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        final profile = profiles[index];
                        if (profile == null) {
                          return;
                        }

                        PokemonSliderDetailsPage.go(
                          context,
                          initialProfileId: profile.id,
                          initialProfileIds: profilesNotNull.map((e) => e.id).toList(),
                        );
                      },
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: profile == null
                            ? const Center(child: Icon(Icons.question_mark, color: greyColor2,))
                            : Center(child: Text(profile.basicProfile.nameI18nKey.xTr)),
                      ),
                    ),
                  ),
                  if (index != profiles.lastIndex)
                    Gap.xl,
                ]).expand((e) => e),
              ],
            ),
          ),
          MySubHeader(
            titleText: 't_fruits'.xTr,
          ),
          ..._fruitSet.map((e) => Text(e.nameI18nKey.xTr)),
          MySubHeader(
            titleText: 't_ingredients'.xTr,
          ),
          ..._buildIngredient(1, _ingredientsMapLv1),
          ..._buildIngredient(30, _ingredientsMapLv30),
          ..._buildIngredient(60, _ingredientsMapLv60),
          Gap.trailing,
        ]
      ),
    );
  }

  void _analysis() {
    final team = _team;
    if (team == null) {
      return;
    }
    
    final profileIdList = team.profileIdList;
    final profiles = profileIdList.map((e) => _profileOf[e]).toList();
    final profilesNotNull = profiles.whereNotNull().toList();

    addIngredientCount(Map<Ingredient, int> mapping, Ingredient ingredient, int count) {
      mapping[ingredient] = (mapping[ingredient] ?? 0) + count;
    }

    for (final profile in profilesNotNull) {
      _fruitSet.add(profile.basicProfile.fruit);
      addIngredientCount(_ingredientsMapLv1, profile.ingredient1, profile.ingredientCount1);
      addIngredientCount(_ingredientsMapLv30, profile.ingredient2, profile.ingredientCount2);
      addIngredientCount(_ingredientsMapLv60, profile.ingredient3, profile.ingredientCount3);
    }
  }

  List<Widget> _buildIngredient(int level, Map<Ingredient, int> ingredientMapping) {
    return [
      Text(
        'Lv. $level'
      ),
      ...ingredientMapping.entries.map((e) => Text('${e.key.nameI18nKey.xTr} x${e.value}')),
      Gap.xl,
    ];
  }

  String _getCurrTeamName() {
    return _team?.getDisplayText(index: _teamIndex)
        ?? PokemonTeam.getDefaultName(index: _teamIndex);
  }

}


