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

typedef PokemonBoxSubmitCallback = dynamic Function(List<PokemonProfile?> profiles);

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
  });

  final _PageType pageType;
  final PokemonBoxSubmitCallback? onConfirm;
  final PokemonTeam? initialTeam;
  final int? initialIndex;
  // TODO: initValues, initialIndex (一開始會優先選中當個)
}

class PokemonBoxPage extends StatefulWidget {
  const PokemonBoxPage._(_PokemonBoxPageArgs args): _args = args;

  static const MyPageRoute route = ('/PokemonBoxPage', _builder);
  static Widget _builder(dynamic args) {
    args = args as _PokemonBoxPageArgs;
    return PokemonBoxPage._(args);
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
      arguments: _PokemonBoxPageArgs(
        pageType: _PageType.readonly,
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

  late ThemeData _theme;

  var _cardWidth = 0.0;
  var _cardHeight = 0.0;

  // Data
  var _allProfiles = <PokemonProfile>[];
  var _resultProfiles = <PokemonProfile>[];
  var _profileIdListInTeam = <int>{};

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

      setState(() {  });
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    final screenSize = MediaQuery.of(context).size;
    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;
    const cardSpacing = 12.0;

    _cardWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: 70,
      containerWidth: mainWidth,
      spacing: cardSpacing,
    );
    _cardHeight = _cardWidth * 1.318;

    return Scaffold(
      appBar: buildAppBar(
        titleText: 't_pokemon_box'.xTr,
        actions: [
          IconButton(
            onPressed: () {
              PokemonMaintainProfilePage.goCreate(context);
            },
            icon: const AddIcon(),
          ),
        ],
      ),
      body: Consumer2<MainViewModel, TeamViewModel>(
        builder: (context, viewModel, teamViewModel, child) {
          _allProfiles = viewModel.profiles;

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
        },
      ),
      bottomNavigationBar: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          final profiles = viewModel.profiles;

          return _buildBottomNavigationBar(profiles);
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(List<PokemonProfile> profiles) {
    return BottomBarWithActions(
      onSearch: () async {
        var res = await DialogUtility.searchPokemon(
          context,
          initialSearchOptions: _searchOptions,
          calcCounts: (options) {
            if (options.isEmptyOptions()) {
              return (profiles.length, profiles.length);
            }
            return (options.filterProfiles(_allProfiles).length, profiles.length);
          },
        );

        _searchOptions = res ?? _searchOptions;
        _resultProfiles = _searchOptions.filterProfiles(_allProfiles);
        setState(() { });
      },
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

    return InkWell(
      onTap: () => _onTap(profile),
      onLongPress: () => _onLongPress(profile),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _cardWidth,
            alignment: Alignment.center,
            constraints: BoxConstraints(
              maxWidth: _cardWidth,
              minHeight: _cardHeight,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: _theme.primaryColorLight,
              )
            ),
            child: !MyEnv.USE_DEBUG_IMAGE
                ? Text(profile.basicProfile.nameI18nKey.xTr)
                : PokemonImage(
                    basicProfile: profile.basicProfile,
                  )
          ),
          if (MyEnv.USE_DEBUG_IMAGE)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  profile.basicProfile.nameI18nKey.xTr,
                  textAlign: TextAlign.center,
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
          if (index != null)
            Positioned(
              right: 0,
              top: -8,
              left: -8,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: color1,
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
                          color: color1,
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
        return _viewPokemonProfile(profile);
    }
  }

  void _onLongPress(PokemonProfile profile) {
    switch (_args.pageType) {
      case _PageType.picker:
        return _viewPokemonProfile(profile);
      case _PageType.readonly:
        return;
    }
  }
  
  void _viewPokemonProfile(PokemonProfile profile) {
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
                        _profilesField[index]?.basicProfile.nameI18nKey ?? '-',
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

    if (profiles.isEmpty) {
      DialogUtility.text(
        context,
        title: Text('t_failed'.xTr),
        content: Text('t_incomplete'.xTr),
      );
      return;
    }

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
