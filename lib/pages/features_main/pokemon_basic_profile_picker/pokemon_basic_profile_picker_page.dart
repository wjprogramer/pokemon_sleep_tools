import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/extensions.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

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
        .where((pokemon) => pokemon.nameI18nKey.contains(keyword))
        .toList();
  }

  void _onKeywordChanged(String keyword) {
    _searchTerms.add(keyword);
  }

  @override
  Widget build(BuildContext context) {
    if (_allBasicProfiles.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: buildAppBar(),
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
                    ...basicProfiles.map((basicProfile) => ElevatedButton(
                      onPressed: () => _pickBasicProfile(basicProfile),
                      child: Text(basicProfile.nameI18nKey),
                    )),
                    Gap.sm,
                  ],
                );
              },
            ),
          ),
          BottomBarWithConfirmButton(
            submit: _submit,
            childrenAtStart: [
              Expanded(
                child: Text(
                  Display.text(_currBasicProfile?.nameI18nKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap.xl,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      child: TextField(
        controller: _keywordController,
      ),
    );
  }

  void _pickBasicProfile(PokemonBasicProfile basicProfile) {
    setState(() {
      _currBasicProfile = basicProfile;
    });
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

