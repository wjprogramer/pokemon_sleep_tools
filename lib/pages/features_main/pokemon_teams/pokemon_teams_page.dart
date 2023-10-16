import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_box/pokemon_box_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/team_analysis/team_analysis_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/team_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:provider/provider.dart';

/// TODO: 可以讓使用者自訂標籤，例如對特定某個地圖、對某些樹果
class PokemonTeamsPage extends StatefulWidget {
  const PokemonTeamsPage({super.key});

  static MyPageRoute<void> route = ('/PokemonTeamsPage',
      (dynamic args) => const PokemonTeamsPage());

  static go(BuildContext context) {
    context.nav.push(PokemonTeamsPage.route);
  }

  @override
  State<PokemonTeamsPage> createState() => _PokemonTeamsPageState();
}

class _PokemonTeamsPageState extends State<PokemonTeamsPage> {
  TeamViewModel get _teamViewModel => context.read<TeamViewModel>();

  String get _titleText => 't_form_team'.xTr;

  // UI
  final _pageController = PageController(keepPage: true);

  // Page
  final _disposers = <MyDisposable>[];
  var _isInitialized = false;

  // Data
  late List<PokemonTeam?> _teams;
  var _profileOf = <int, PokemonProfile>{};
  var _currIndex = 0;

  @override
  void initState() {
    super.initState();
    _teams = List.generate(MAX_TEAM_COUNT, (index) => null);

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

      _isInitialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _disposers.disposeAll();
    super.dispose();
  }

  void _listenMainViewModel() {
    final mainViewModel = context.read<MainViewModel>();
    _profileOf = mainViewModel.profiles
        .toMap((profile) => profile.id, (profile) => profile);

    _update();
  }

  void _listenTeamViewModel() {
    final teamViewModel = context.read<TeamViewModel>();
    teamViewModel.teams.take(MAX_TEAM_COUNT).forEachIndexed((index, team) {
      _teams[index] = team;
    });
    _update();
  }

  void _update() {
    setState(() { });
  }

  String _getCurrTeamName() {
    return _teams[_currIndex]?.getDisplayText(index: _currIndex)
        ?? PokemonTeam.getDefaultName(index: _currIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return _buildLoadingView();
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: _titleText,
      ),
      body: ListView(
        children: [
          Gap.xl,
          ...Hp.list(
            children: [
              GestureDetector(
                onTap: () {
                  final textEditCtrl = TextEditingController(text: _getCurrTeamName());
                  var isLoading = false;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, innerSetState) {
                          return AlertDialog(
                            title: Text('隊伍名稱'),
                            content: TextField(
                              controller: textEditCtrl,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context.nav.pop();
                                },
                                child: Text('t_cancel'.xTr),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    isLoading = true;
                                    setState(() { });

                                    await _teamViewModel.updateTeam(
                                      _currIndex,
                                      PokemonTeam.empty(_currIndex).copyWith(name: textEditCtrl.text),
                                    );
                                    context.nav.pop();
                                  } catch (e) {
                                    print(e);
                                  } finally {
                                    isLoading = false;
                                    setState(() { });
                                  }
                                },
                                child: isLoading
                                    ? SizedBox(width: 25, height: 25, child: CircularProgressIndicator(strokeWidth: 3,))
                                    : Text('t_confirm'.xTr),
                              ),
                            ],
                          );
                        }
                      );
                    },
                  );
                },
                child: MyLabel(
                  child: Text.rich(
                    TextSpan(
                      text: _getCurrTeamName(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyLabel.defaultFgColor,
                      ),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: Gap.mdV),
                            child: Icon(
                              Icons.edit,
                              color: MyLabel.defaultFgColor,
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(
                      height: 1.2,
                      forceStrutHeight: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            constraints: const BoxConstraints.tightFor(
              height: 150,
            ),
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: _teams
                  .mapIndexed((teamIndex, e) => _buildPokemonTeam(teamIndex, e))
                  .toList(),
            ),
          ),
          ...Hp.list(
            children: [
              _buildIndicators(context),
              if (kDebugMode) ...[
                Gap.xl,
                MyElevatedButton(
                  onPressed: () {},
                  child: Text('t_auto_form_team'.xTr),
                ),
              ],
              Gap.xl,
              MyElevatedButton(
                onPressed: _getTeamAnalysisGoPageCallback(),
                child: Text('t_analysis'.xTr),
              ),
            ],
          ),
          Gap.trailing,
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            ...List.generate(MAX_TEAM_COUNT, (index) => ListTile(
              onTap: () {
                context.nav.pop();
                _pageController.animateToPage(index, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
              },
              title: Row(
                children: [
                  Text('${index + 1}. '),
                  Expanded(
                    child: Text(
                      _teams[index]?.getDisplayText(index: index) ?? PokemonTeam.getDefaultName(index: index),
                    ),
                  ),
                ],
              ),
            )),
            Gap.trailing,
          ],
        ),
      ),
    );
  }

  Function()? _getTeamAnalysisGoPageCallback() {
    final team = _teams[_currIndex];
    if (team == null) {
      return null;
    }

    if (team.profileIdList.any((e) => e != -1)) {
      return () {
        TeamAnalysisPage.go(context, _currIndex);
      };
    }

    return null;
  }

  Widget _buildLoadingView() {
    return Scaffold(
      appBar: buildAppBar(
        titleText: _titleText,
      ),
      body: const Center(child: CircularProgressIndicator(),),
    );
  }

  Widget _buildPokemonTeam(int teamIndex, PokemonTeam? pokemonTeam) {
    final profileIdList = pokemonTeam?.profileIdList
        ?? List.generate(MAX_TEAM_POKEMON_COUNT, (index) => -1);
    final profiles = profileIdList.map((e) => _profileOf[e]).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: Hp(
        child: Row(
          children: [
            ...profiles.mapIndexed((index, profile) {
              Widget child;

              if (profile == null) {
                child = const Center(child: Icon(Icons.add, color: greyColor2,));
              } else if (MyEnv.USE_DEBUG_IMAGE) {
                child = ClipRect(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..scale(1.5),
                      child: Image.asset(
                        AssetsPath.pokemonPortrait(profile.basicProfile.boxNo),
                        errorBuilder: (context, error, stackTrace) => Container(),
                      ),
                    ),
                  ),
                );
              } else {
                child = Center(child: Text(profile.basicProfile.nameI18nKey.xTr));
              }

              return <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      final pop = context.nav.pop;

                      PokemonBoxPage.pick(
                        context,
                        initialTeam: pokemonTeam,
                        initialIndex: index,
                        onConfirm: (profiles) async {
                          final profileIdList = profiles.map((e) => e?.id ?? -1).toList();

                          if (pokemonTeam == null) {
                            await _teamViewModel.createTeam(CreatePokemonTeamPayload(
                              index: teamIndex,
                              name: null,
                              profileIdList: profileIdList,
                            ));
                          } else {
                            final newTeam = pokemonTeam.copyWith(profileIdList: profileIdList);
                            await _teamViewModel.updateTeam(teamIndex, newTeam);
                          }
                          pop();
                        },
                      );
                    },
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: child,
                    ),
                  ),
                ),
                if (index != profiles.lastIndex)
                  Gap.md,
              ];
            }).expand((e) => e),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators(BuildContext context) {
    const size = 8.0;
    final screenSize = MediaQuery.of(context).size;
    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          minWidth: mainWidth,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(MAX_TEAM_COUNT, (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _currIndex ? primaryColor : greyColor2,
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _onPageChanged(int page) {
    _currIndex = page;
    setState(() { });
  }

}
