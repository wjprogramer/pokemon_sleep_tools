import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/view_models/team_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

typedef PokemonBoxSubmitCallback = dynamic Function(List<PokemonProfile?> profiles);

const _cardSpacing = 12.0;

enum _PageType {
  readonly,
  picker,
}

class _PokemonBoxPageArgs {
  _PokemonBoxPageArgs({
    required this.pageType,
    this.onConfirm,
    this.initialTeam,
    this.initialIndex,
    this.initialSearchOptions,
  });

  final _PageType pageType;
  final PokemonBoxSubmitCallback? onConfirm;
  final PokemonTeam? initialTeam;
  final int? initialIndex;
  final PokemonSearchOptions? initialSearchOptions;
  // TODO: initValues, initialIndex (一開始會優先選中當個)
}

class PokemonBoxPage extends StatefulWidget {
  const PokemonBoxPage._(_PokemonBoxPageArgs args): _args = args;

  static const MyPageRoute route = ('/PokemonBoxPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as _PokemonBoxPageArgs;
    return PokemonBoxPage._(args);
  }

  static void go(BuildContext context, {
    PokemonSearchOptions? initialSearchOptions,
  }) {
    context.nav.push(
      route,
      arguments: _PokemonBoxPageArgs(
        pageType: _PageType.readonly,
        initialSearchOptions: initialSearchOptions,
      ),
    );
  }

  static Future<List<PokemonProfile?>?> pick(BuildContext context, {
    PokemonTeam? initialTeam,
    PokemonBoxSubmitCallback? onConfirm,
    int? initialIndex,
  }) async {
    final res = await context.nav.push(
      route,
      arguments: _PokemonBoxPageArgs(
        pageType: _PageType.picker,
        onConfirm: onConfirm,
        initialTeam: initialTeam,
        initialIndex: initialIndex,
      ),
    );
    return res is List<PokemonProfile?>
        ? res : null;
  }

  void _popResult(BuildContext context, List<PokemonProfile?>? result) {
    context.nav.pop(result);
  }

  final _PokemonBoxPageArgs _args;

  @override
  State<PokemonBoxPage> createState() => _PokemonBoxPageState();
}

class _PokemonBoxPageState extends State<PokemonBoxPage> {
  _PokemonBoxPageArgs get _args => widget._args;
  MainViewModel get _mainViewModel => context.read<MainViewModel>();

  final _profileViewKey = const ValueKey('profile_view_key_box_page');

  late ThemeData _theme;

  var _cardWidth = 0.0;
  var _cardHeight = 0.0;

  // Page
  final _disposers = <MyDisposable>[];

  // Data
  var _allProfiles = <PokemonProfile>[];
  var _resultProfiles = <PokemonProfile>[];
  var _profileIdListInTeam = <int>{};
  PokemonProfile? _profile;
  var _isMobile = false;

  // Picker mode properties
  var _currPickIndex = 0;
  final List<PokemonProfile?> _profilesField = List.generate(MAX_TEAM_POKEMON_COUNT, (index) => null);
  var _indexToProfileId = <int, int>{};
  final _profileIdToIndex = <int, int>{};

  // Filter properties
  var _searchOptions = PokemonSearchOptions();

  @override
  void initState() {
    super.initState();
    _searchOptions = _args.initialSearchOptions ?? _searchOptions;

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();
      final teamViewModel = context.read<TeamViewModel>();
      final teams = await teamViewModel.loadTeams();

      _indexToProfileId = List
          .generate(MAX_TEAM_POKEMON_COUNT, (index) => index)
          .toMap((i) => i, (i) => -1);
      _currPickIndex = _args.initialIndex ?? _currPickIndex;

      _allProfiles = await mainViewModel.loadProfiles();
      _resultProfiles = _searchOptions.filterProfiles(_allProfiles);

      final profileIdList = _args.initialTeam?.profileIdList;
      if (profileIdList != null) {
        final profiles = mainViewModel.profiles;
        final profileOf = profiles.toMap((e) => e.id, (e) => e);
        final teamProfiles = profileIdList.map((e) => profileOf[e]).toList();

        teamProfiles.forEachIndexed((index, profile) {
          if (profile == null) {
            return;
          }
          _profilesField[index] = profile;
          _indexToProfileId[index] = profile.id;
          _profileIdToIndex[profile.id] = index;
        });
      }

      _profileIdListInTeam = {
        ...teams.whereNotNull().map((team) => team.profileIdList).expand((e) => e),
      }..remove(-1);

      _disposers.addAll([
        mainViewModel.xAddListener(_listenMainViewModel)
      ]);

      setState(() {  });
    });
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    super.dispose();
  }

  void _listenMainViewModel() {
    _allProfiles = _mainViewModel.profiles;
    _resultProfiles = _searchOptions.filterProfiles(_allProfiles);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final responsive = ResponsiveBreakpoints.of(context);

    _theme = Theme.of(context);
    _isMobile = responsive.isMobile || screenSize.width < COMMON_SIDE_WIDTH * 2.5;

    return Consumer2<MainViewModel, TeamViewModel>(
      builder: (context, viewModel, teamViewModel, child) {
        if (_isMobile) {
          final mainWidth = screenSize.width - 2 * HORIZON_PADDING;
          _calcUiValuesByMainWidth(mainWidth);

          return Scaffold(
            appBar: buildAppBar(
              title: _buildAppBarTitle(),
              actions: [
                IconButton(
                  onPressed: () {
                    PokemonMaintainProfilePage.goCreate(context);
                  },
                  icon: const AddIcon(),
                ),
              ],
            ),
            body: _buildMainContent(
              context, viewModel, teamViewModel, child,
              cardSpacing: _cardSpacing,
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          );
        }

        const sideSize = COMMON_SIDE_WIDTH;
        const mainWidth = sideSize - 2 * HORIZON_PADDING;
        _calcUiValuesByMainWidth(mainWidth);

        final profile = _profile;
        return Scaffold(
          appBar: buildAppBar(
            title: _buildAppBarTitle(),
            actions: [
              IconButton(
                onPressed: () {
                  PokemonMaintainProfilePage.goCreate(context);
                },
                icon: const AddIcon(),
              ),
            ],
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: sideSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildMainContent(
                        context, viewModel, teamViewModel, child,
                        cardSpacing: _cardSpacing,
                      ),
                    ),
                    _buildBottomNavigationBar(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: Divider.createBorderSide(context),
                    ),
                  ),
                  child: profile == null
                      ? const Center(child: Text('選擇寶可夢'),)
                      : PokemonSliderDetailsPage.buildView(key: _profileViewKey, profileId: profile?.id),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('t_pokemon_box'.xTr),
        Tooltip(
          message: '篩選結果數量 / 全部數量'.xTr,
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              color: color1,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${_resultProfiles.length} / ${_allProfiles.length}',
              style: _theme.textTheme.bodySmall?.copyWith(
                color: color1.fgColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _calcUiValuesByMainWidth(double mainWidth) {
    _cardWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: 70,
      containerWidth: mainWidth,
      spacing: _cardSpacing,
    );
    _cardHeight = _cardWidth * 1.318;
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        final profiles = viewModel.profiles;

        return _buildBottomNavigationBarContent(profiles);
      },
    );
  }

  Widget _buildMainContent(BuildContext context, MainViewModel viewModel, TeamViewModel teamViewModel, Widget? child, {
    required double cardSpacing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_args.pageType == _PageType.picker)
          _buildSelectedPokemonList(),
        Expanded(
          child: buildListView(
            padding: const EdgeInsets.symmetric(
              horizontal: HORIZON_PADDING,
            ),
            children: [
              Gap.md,
              Wrap(
                spacing: cardSpacing,
                runSpacing: cardSpacing,
                children: _resultProfiles
                    .map((profile) => _buildProfileItem(profile))
                    .toList(),
              ),
              Gap.trailing,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBarContent(List<PokemonProfile> profiles) {
    return BottomBarWithActions(
      onSearch: () async {
        var searchOptions = await DialogUtility.searchPokemon(
          context,
          initialSearchOptions: _searchOptions,
          calcCounts: (options) {
            if (options.isEmptyOptions()) {
              return (profiles.length, profiles.length);
            }
            return (options.filterProfiles(_allProfiles).length, profiles.length);
          },
        );
        if (searchOptions == null) {
          return;
        }

        _searchOptions = searchOptions;
        _resultProfiles = _searchOptions.filterProfiles(_allProfiles);
        setState(() { });
      },
      isSearchOn: _searchOptions.isEmptyOptions() ? null : true,
      onSort: () {

      },
      suffixActions: [
        if (_confirmButtonVisible())
          Padding(
            padding: const EdgeInsets.only(right: Gap.mdV),
            child: MyElevatedButton(
              onPressed: _submit,
              child: Text('t_confirm'.xTr),
            ),
          ),
      ],
    );
  }

  bool _confirmButtonVisible() {
    switch (_args.pageType) {
      case _PageType.picker:
        return true;
      case _PageType.readonly:
        return false;
    }
  }

  Widget _buildProfileItem(PokemonProfile profile) {
    final index = _profileIdToIndex[profile.id];

    Widget child;
    if (!MyEnv.USE_DEBUG_IMAGE) {
      child = Center(child: Text(profile.basicProfile.nameI18nKey.xTr));
    } else {
      child = Align(
        alignment: const Alignment(0, -0.3),
        child: IgnorePointer(
          // Ignore image tooltip
          child: PokemonImage(
            basicProfile: profile.basicProfile,
            isShiny: profile.isShiny,
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => _onTap(profile),
      onLongPress: () => _onLongPress(profile),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _cardWidth,
            constraints: BoxConstraints(
              maxWidth: _cardWidth,
              minHeight: _cardHeight,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: _theme.primaryColorLight,
              ),
            ),
            child: child,
          ),
          if (MyEnv.USE_DEBUG_IMAGE)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text.rich(
                  TextSpan(
                    text: '',
                    children: [
                      TextSpan(
                        text: profile.getDisplayText(),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  // overflow: TextOverflow.fade,
                ),
              ),
            ),
          if (_profileIdListInTeam.contains(profile.id) && widget._args.pageType == _PageType.readonly)
            Positioned(
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                color: color1,
                child: Text(
                  '正在隊中',
                  style: TextStyle(
                    fontSize: 10,
                    color: color1.fgColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          if (index != null || profile.isFavorite)
            Positioned(
              right: 0,
              top: -8,
              left: -8,
              child: Align(
                alignment: Alignment.topLeft,
                child: index == null ? Icon(
                  Icons.star,
                  color: starIconColor,
                ) : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: profile.isFavorite ? starIconColor : color1,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: profile.isFavorite ? orangeColor : color1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onTap(PokemonProfile profile) {
    switch (_args.pageType) {
      case _PageType.picker:
        return _onTapUnderPickerMode(profile);
      case _PageType.readonly:
        return _viewPokemonProfile(profile, markDirty: true);
    }
  }

  void _onLongPress(PokemonProfile profile) {
    switch (_args.pageType) {
      case _PageType.picker:
        return _viewPokemonProfile(profile, markDirty: true);
      case _PageType.readonly:
        return;
    }
  }
  
  void _viewPokemonProfile(PokemonProfile profile, {
    bool markDirty = false
  }) {
    if (!_isMobile) {
      _profile = profile;
      if (markDirty) {
        setState(() { });
      }
      return;
    }

    PokemonSliderDetailsPage.go(
      context,
      initialProfileId: profile.id,
      initialProfileIds: _searchOptions.isEmptyOptions() ? null : _resultProfiles.map((e) => e.id).toList(),
    );
  }

  void _onTapUnderPickerMode(PokemonProfile profile) {
    final index = _currPickIndex;

    // Validate
    // if (_profileIdToIndex.containsKey(profile.id)) {
    //   return;
    // }

    // Remove old (not same id);
    final oldProfileId = _indexToProfileId[index];
    _profileIdToIndex.remove(oldProfileId);

    // Remove old (with same id)
    final oldIndex = _profileIdToIndex[profile.id];
    if (oldIndex != null) {
      _indexToProfileId[oldIndex] = -1;
      _profilesField[oldIndex] = null;
    }

    // Set new data
    _profilesField[index] = profile;
    _indexToProfileId[index] = profile.id;
    _profileIdToIndex[profile.id] = index;

    // Next
    _currPickIndex = (index + 1) % SubSkill.maxCount;

    // View
    // _viewPokemonProfile(profile, markDirty: false);
    _profile = profile;
    setState(() { });
  }

  Widget _buildSelectedPokemonList() {
    return Container(
      padding: const EdgeInsets.only(
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: Divider.createBorderSide(context),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(MAX_TEAM_POKEMON_COUNT, (index) => Expanded(
            child: _buildPokemonField(index),
          )),
        ),
      ),
    );
  }

  Widget _buildPokemonField(int index) {
    final isSelected = _currPickIndex == index;
    final basicProfile = _profilesField[index]?.basicProfile;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currPickIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            constraints: const BoxConstraints(
              minHeight: 50,
            ),
            decoration: BoxDecoration(
              color: isSelected ? _theme.primaryColorLight : null,
              border: Border.all(
                color: isSelected
                    ? _theme.primaryColor
                    : _theme.disabledColor,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.hardEdge,
                children: [
                  Opacity(
                    opacity: _profilesField[index]?.basicProfile != null && MyEnv.USE_DEBUG_IMAGE ? 0 : 1,
                    child: Center(
                      child: Text(
                        _profilesField[index]?.getDisplayText() ?? '-',
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (basicProfile == null || !MyEnv.USE_DEBUG_IMAGE)
                    Container()
                  else
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: PokemonIconImage(
                        width: 50,
                        basicProfile: basicProfile,
                      ),
                    ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: AnimatedOpacity(
                      opacity: basicProfile == null ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        onPressed: basicProfile == null ? null : () {
                          setState(() {
                            _profilesField[index] = null;
                            _profileIdToIndex.remove(_indexToProfileId[index]);
                            _indexToProfileId[index] = -1;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Only for [_PageType.picker]
  Future<void> _submit() async {
    final profiles = _profilesField.nonNulls.toList();

    // if (profiles.isEmpty) {
    //   DialogUtility.text(
    //     context,
    //     title: Text('t_failed'.xTr),
    //     content: Text('t_incomplete'.xTr),
    //   );
    //   return;
    // }

    // TODO: 需驗證沒有被刪除?

    final onConfirm = _args.onConfirm;
    if (onConfirm == null) {
      widget._popResult(context, _profilesField);
      return;
    }

    try {
      final res = onConfirm(_profilesField);
      if (res is Future) {
        await res;
      }
      // TODO: show loading
    } catch (e) {
      // TODO: error handling
    }
  }

}
