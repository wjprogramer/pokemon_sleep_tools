import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// TODO: 增加 search
class PokemonBasicProfilePickerArgs {
  // final int initBaseProfileId
}

class PokemonBasicProfilePicker extends StatefulWidget {
  const PokemonBasicProfilePicker({super.key});

  static const MyPageRoute<PokemonBasicProfilePickerArgs> route = ('/PokemonBasicProfilePicker', _builder);
  static Widget _builder(dynamic args) {
    args = args as PokemonBasicProfilePickerArgs?;
    return const PokemonBasicProfilePicker();
  }

  static Future<PokemonBasicProfile?> go(BuildContext context) async {
    final res = await context.nav.push(
      PokemonBasicProfilePicker.route,
      arguments: PokemonBasicProfilePickerArgs(),
    );
    return res as PokemonBasicProfile?;
  }

  void _popResult(BuildContext context, PokemonBasicProfile? subSkills) {
    context.nav.pop(subSkills);
  }

  @override
  State<PokemonBasicProfilePicker> createState() => _PokemonBasicProfilePickerState();
}

class _PokemonBasicProfilePickerState extends State<PokemonBasicProfilePicker> {
  PokemonBasicProfileRepository get _pokemonBasicProfileRepo => getIt();

  final _searchTerms = BehaviorSubject<String>();
  late Stream<List<PokemonBasicProfile>> _basicProfileStream;

  var _allBasicProfiles = <PokemonBasicProfile>[];
  PokemonBasicProfile? _currBasicProfile;
  final _keywordController = TextEditingController();

  // UI
  static const _baseChildWidth = 100.0;
  static const _spacing = 12.0;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      _init();
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    _allBasicProfiles = await _pokemonBasicProfileRepo.findAll();
    _basicProfileStream = _searchTerms
        // TODO: 目前沒有打算用網路搜尋，時間設短一點
        .debounce((_) => TimerStream(true, const Duration(milliseconds: 100)))
        .switchMap((query) async* {
          yield await _filter(query);
        })
        .startWith(_allBasicProfiles);

    _keywordController.addListener(() {
      _onKeywordChanged(_keywordController.text);
    });

    if (mounted) {
      setState(() { });
    }
  }

  Future<List<PokemonBasicProfile>> _filter(String keyword) async {
    return _allBasicProfiles
        .where((pokemon) => pokemon.nameI18nKey.xTr.contains(keyword))
        .toList();
  }

  void _onKeywordChanged(String keyword) {
    _searchTerms.add(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = context.mediaQuery.size;
    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;

    if (_allBasicProfiles.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final childWidth = UiUtility.getChildWidthInRowBy(
      baseChildWidth: _baseChildWidth,
      containerWidth: mainWidth,
      spacing: _spacing,
    );

    return Scaffold(
      appBar: buildAppBar(
        titleText: '選擇寶可夢',
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder(
              stream: _basicProfileStream,
              builder: (context, snapshot) {
                final basicProfiles = snapshot.data ?? [];

                return buildListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HORIZON_PADDING,
                  ),
                  children: [
                    Gap.sm,
                    if (MyEnv.USE_DEBUG_IMAGE) Wrap(
                      spacing: _spacing,
                      runSpacing: _spacing,
                      children: [
                        ...basicProfiles.map((basicProfile) => SizedBox(
                          width: childWidth,
                          child: InkWell(
                            onTap: () => _pickBasicProfile(basicProfile),
                            onLongPress: () => PokemonBasicProfilePage.go(context, basicProfile),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                    ),
                                    child: IgnorePointer(
                                      // ignore image tooltip
                                      child: PokemonImage(
                                        basicProfile: basicProfile,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                    child: Text(
                                      basicProfile.nameI18nKey.xTr,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                      ],
                    ) else ...basicProfiles.map((basicProfile) => MyElevatedButton(
                      onPressed: () => _pickBasicProfile(basicProfile),
                      child: Text(basicProfile.nameI18nKey.xTr),
                    )),
                    Gap.sm,
                  ],
                );
              },
            ),
          ),
          // BottomBarWithConfirmButton(
          //   submit: _submit,
          //   childrenAtStart: [
          //     Expanded(
          //       child: Text(
          //         Display.text(_currBasicProfile?.nameI18nKey),
          //         maxLines: 1,
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //     ),
          //     Gap.xl,
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _keywordController,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
        ),
      ),
    );
  }

  void _pickBasicProfile(PokemonBasicProfile basicProfile) {
    // setState(() {
    //   _currBasicProfile = basicProfile;
    // });
    widget._popResult(context, basicProfile);
  }

  void _submit() {
    final basicProfile = _currBasicProfile;

    if (basicProfile == null) {
      DialogUtility.text(
        context,
        title: Text('t_failed'.xTr),
        content: Text('t_incomplete'.xTr),
      );
      return;
    }

    widget._popResult(context, basicProfile);
  }
}

