import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_slider_details/pokemon_slider_details_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
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

  // Picker mode properties
  var _currPickIndex = 0;
  final List<PokemonProfile?> _profilesField = List.generate(MAX_TEAM_POKEMON_COUNT, (index) => null);
  var _indexToProfileId = <int, int>{};
  final _profileIdToIndex = <int, int>{};

  // Filter properties
  // TODO:

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();

      _indexToProfileId = List
          .generate(MAX_TEAM_POKEMON_COUNT, (index) => index)
          .toMap((i) => i, (i) => -1);
      _currPickIndex = _args.initialIndex ?? _currPickIndex;

      await mainViewModel.loadProfiles();

      final profileIdList = _args.initialTeam?.profileIdList;
      if (profileIdList != null) {
        final profiles = mainViewModel.profiles;
        final profileOf = profiles.toMap((e) => e.id, (e) => e);
        final teamProfiles = profileIdList.map((e) => e == null ? null : profileOf[e]).toList();

        teamProfiles.forEachIndexed((index, profile) {
          if (profile == null) {
            return;
          }
          _profilesField[index] = profile;
          _indexToProfileId[index] = profile.id;
          _profileIdToIndex[profile.id] = index;
        });
      }

      setState(() {  });
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    // TODO: Consumer2, for teams, readonly, 若有在 teams 中，要顯示「正在隊中」;

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
      body: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          final profiles = viewModel.profiles;

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
                      children: profiles
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: Divider.createBorderSide(context),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // TODO: 篩選器、排序
            if (_confirmButtonVisible())
              MyElevatedButton(
                onPressed: _submit,
                child: Text('t_confirm'.xTr),
              ),
          ],
        ),
      ),
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
      child: Stack(
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
            child: Text(
              profile.basicProfile.nameI18nKey,
            ),
          ),
          if (index != null)
            Positioned(
              right: 0,
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${index + 1}'),
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
        return _onTapUnderReadOnly(profile);
    }
  }
  
  void _onTapUnderReadOnly(PokemonProfile profile) {
    PokemonSliderDetailsPage.go(
      context,
      initialProfileId: profile.id,
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

    return GestureDetector(
      onTap: () {
        setState(() {
          _currPickIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(4, 4, 4, 8),
            padding: const EdgeInsets.all(4),
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
            child: Text(
              _profilesField[index]?.basicProfile.nameI18nKey ?? '-',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
