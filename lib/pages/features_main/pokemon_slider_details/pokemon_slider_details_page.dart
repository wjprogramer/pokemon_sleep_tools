import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_statics_2/dev_pokemon_statics_2_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/analysis_details/analysis_details_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/exp_calculator/exp_calculator_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/fruit/fruit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/ingredient/ingredient_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/main_skill/main_skill_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_basic_profile/pokemon_basic_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/list_tiles/search_list_tile.dart';
import 'package:provider/provider.dart';

part 'src/pokemon_details.dart';

/// TODO: 要顯示所有食材可能性
class _Args {
  _Args({
    this.initialProfileId,
    this.initialProfileIds,
    this.isView = false,
  });

  final int? initialProfileId;

  /// [PokemonProfile.id]
  final List<int>? initialProfileIds;

  final bool isView;
}

class PokemonSliderDetailsPage extends StatefulWidget {
  const PokemonSliderDetailsPage._(this._args, {
    super.key,
  });

  static MyPageRoute<void> route = ('/PokemonSliderDetailsPage',
      (dynamic args) => PokemonSliderDetailsPage._(args));

  static void go(BuildContext context, {
    int? initialProfileId,
    List<int>? initialProfileIds,
  }) {
    context.nav.push(
      PokemonSliderDetailsPage.route,
      arguments: _Args(
        initialProfileId: initialProfileId,
        initialProfileIds: initialProfileIds,
      ),
    );
  }

  static Widget buildView({
    Key? key,
    int? profileId,
    List<int>? initialProfileIds,
  }) {
    return PokemonSliderDetailsPage._(
      _Args(
        initialProfileId: profileId,
        initialProfileIds: initialProfileIds,
        isView: true,
      ),
      key: key,
    );
  }

  final _Args _args;

  @override
  State<PokemonSliderDetailsPage> createState() => _PokemonSliderDetailsPageState();
}

class _PokemonSliderDetailsPageState extends State<PokemonSliderDetailsPage> {
  MainViewModel get _mainViewModel => context.read<MainViewModel>();
  _Args get _args => widget._args;
  bool get _isView => _args.isView;

  late PageController _pageController;

  // final _cache = ListQueue<PokemonProfileStatistics2>(10);
  /// [PokemonProfile.id] to statistics
  final _cache = <int, ProfileStatisticsResult>{};

  var _previousPage = 0;
  var _currIndex = 0;

  /// [PokemonProfile.id] to instance
  final _profileOf = <int, PokemonProfile>{};

  // Page status
  final _disposers = <MyDisposable>[];
  var _initialized = false;

  // List
  var _lastOffset = 0.0;
  var _profiles = <PokemonProfile>[];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      // Load
      final mainViewModel = context.read<MainViewModel>();
      await mainViewModel.loadProfiles();

      // Update profiles
      _updateProfileMapping();
      _updateProfiles();

      // Update according profiles
      _updateProfileStatistics();

      // Update index
      if (_args.initialProfileId != null) {
        _updateProfiles();
        int? index;
        if (_args.initialProfileIds != null) {
          index = _args.initialProfileIds?.indexOrNullWhere((profileId) => profileId == _args.initialProfileId);
        } else {
          index = _profiles.indexOrNullWhere((e) => e.id == _args.initialProfileId);
        }

        _previousPage = index ?? _previousPage;
        _currIndex = index ?? 0;
      }

      _pageController = PageController(initialPage: _currIndex);

      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _disposers.add(
        _mainViewModel.xAddListener(() {
          // Update profiles
          _updateProfiles();
          _updateProfileMapping();

          // Update according profiles
          _updateProfileStatistics();
        }),
      );
    });
  }

  void _updateProfileMapping() {
    final newProfiles = _mainViewModel.profiles;
    for (final profile in newProfiles) {
      _profileOf[profile.id] = profile;
    }
  }

  /// TODO: [initState] 的 load data 需要這裡使用？
  @override
  void didUpdateWidget(covariant PokemonSliderDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_args.isView && _args.initialProfileId != null) {
      final profileIndex = _profiles
          .indexOrNullWhere((p) => p.id == _args.initialProfileId);

      if (profileIndex != null && _pageController.hasClients) {
        _pageController.jumpToPage(profileIndex);
      }
    }
  }

  @override
  void dispose() {
    _disposers.disposeAll();
    _pageController.dispose();
    super.dispose();
  }

  void _updateProfileStatistics() {
    for (final profile in _profiles) {
      final resultLv50 = PokemonProfileStatistics([ profile ], level: 50).calc()[0]?.resultWithHelpers;
      final resultLv100 = PokemonProfileStatistics([ profile ], level: 100).calc()[0]?.resultWithHelpers;

      final resultView = ProfileStatisticsResult(
        profile, resultLv50?.rank ?? '', resultLv100?.rank ?? '',
      );
      _cache[profile.id] = resultView;
    }
  }

  void _updateProfiles() {
    final initialProfileIds = _args.initialProfileIds;
    if (initialProfileIds != null) {
      _profiles = initialProfileIds.map((e) => _profileOf[e]).whereNotNull().toList();
    } else {
      _profiles = _mainViewModel.profiles;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const LoadingView();
    }

    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        _currIndex = _currIndex.clamp(0, _profiles.lastIndex ?? 0);

        if (_profiles.isEmpty) {
          return Scaffold(
            appBar: buildAppBar(),
            body: Center(
              child: Text('t_none'.xTr),
            ),
          );
        }

        Widget buildBody({ required Size viewSize}) {
          return PageView(
            controller: _pageController,
            onPageChanged: (page) => _onPageChanged(page, _profiles),
            children: _profiles.mapIndexed((profileIndex, profile) => _PokemonDetails(
              profile: profile,
              statistics: _getStatistics(profile),
              onDeletedSuccess: () {
                _currIndex -= 1;
              },
              initialOffset: _lastOffset,
              onScroll: (offset) {
                if (_currIndex != profileIndex) {
                  return;
                }

                _lastOffset = offset;
                setState(() { });
              },
              viewSize: viewSize,
            )).toList(),
          );
        }

        Widget body;

        if (_isView) {
          body = LayoutBuilder(
            builder: (context, constraints) {
              return buildBody(viewSize: Size(constraints.maxWidth, constraints.maxHeight));
            }
          );
        } else {
          body = buildBody(viewSize: context.mediaQuery.size);
        }

        if (_isView) {
          body = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: kToolbarHeight,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Gap.h,
                    Expanded(
                      child: _buildTitle(),
                    ),
                    ..._buildActions(),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          );
        }

        return Scaffold(
          appBar: _isView ? null : buildAppBar(
            title: _buildTitle(),
            actions: _buildActions(),
          ),
          body: body,
        );
      }
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (MyEnv.USE_DEBUG_IMAGE)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PokemonTypeImage(
              pokemonType: _profiles[_currIndex].basicProfile.pokemonType,
              width: 32,
            ),
          ),
        Expanded(child: Text(_profiles[_currIndex].getDisplayText())),
      ],
    );
  }

  List<Widget> _buildActions() {
    return [
      IconButton(
        onPressed: () {
          PokemonMaintainProfilePage.goEdit(context, _profiles[_currIndex]);
        },
        icon: const Icon(Icons.edit),
      ),
    ];
  }

  void _onPageChanged(int page, List<PokemonProfile> profiles) {
    _currIndex = page;
    setState(() { });

    // scheduleMicrotask(() {
    //   _loadData(page, profiles);
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
  }

  Future<void> _loadData(int index, List<PokemonProfile> profiles) async {
    // var delta = index - _previousPage;
    // var preloadIndex = delta == 0 && profiles.length > 1 ? null : (
    //     (profiles.length + index + delta) % profiles.length
    // );
    //
    // PokemonProfileStatistics? currentStatistics;
    // PokemonProfileStatistics? preloadStatistics;
    //
    // for (final data in [..._cache]) {
    //   if (data.profile.id == profiles[index].id) {
    //     currentStatistics = data;
    //   } else if (preloadIndex != null &&
    //       data.profile.id == profiles[preloadIndex].id) {
    //     preloadStatistics = data;
    //   }
    //
    //   if (currentStatistics != null && preloadStatistics != null) {
    //     break;
    //   }
    // }
    //
    // _cache.removeWhere((statistics) {
    //   return statistics.profile.id == currentStatistics?.profile.id ||
    //       statistics.profile.id == preloadStatistics?.profile.id;
    // });
    //
    // if (currentStatistics == null) {
    //   currentStatistics = PokemonProfileStatistics2(profiles[index])..calcForUser();
    //   _cache.add(currentStatistics);
    // }
    // if (preloadIndex != null && preloadStatistics == null) {
    //   preloadStatistics = PokemonProfileStatistics2(profiles[preloadIndex])..calcForUser();
    //   _cache.add(preloadStatistics);
    // }
    //
    // setState(() { });
  }

  ProfileStatisticsResult? _getStatistics(PokemonProfile profile) {
    return _cache[profile.id];
    // return _cache.firstWhereOrNull((e) => e.profile.id == profile.id);
  }

}
