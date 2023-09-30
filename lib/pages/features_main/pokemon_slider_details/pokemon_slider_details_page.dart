import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_maintain_profile/pokemon_maintain_profile_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/view_models/main_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/main/main_widgets.dart';
import 'package:provider/provider.dart';

class _PokemonSliderDetailsPageArgs {
  _PokemonSliderDetailsPageArgs({
    this.initialProfileId,
  });

  final int? initialProfileId;
}

class PokemonSliderDetailsPage extends StatefulWidget {
  const PokemonSliderDetailsPage._({
    required _PokemonSliderDetailsPageArgs args,
  }) : _args = args;

  static MyPageRoute<void> route = ('/PokemonSliderDetailsPage', (dynamic args) => PokemonSliderDetailsPage._(
    args: args as _PokemonSliderDetailsPageArgs,
  ));

  static void go(BuildContext context, {
    int? initialProfileId,
  }) {
    context.nav.push(
      PokemonSliderDetailsPage.route,
      arguments: _PokemonSliderDetailsPageArgs(
        initialProfileId: initialProfileId,
      ),
    );
  }

  final _PokemonSliderDetailsPageArgs _args;

  @override
  State<PokemonSliderDetailsPage> createState() => _PokemonSliderDetailsPageState();
}

class _PokemonSliderDetailsPageState extends State<PokemonSliderDetailsPage> {
  _PokemonSliderDetailsPageArgs get _args => widget._args;

  late PageController _pageController;

  final _cache = ListQueue<PokemonProfileStatistics>(5);
  var _previousPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    scheduleMicrotask(() async {
      final mainViewModel = context.read<MainViewModel>();
      await mainViewModel.loadProfiles();

      if (_args.initialProfileId != null) {
        final profiles = mainViewModel.profiles;
        final index = profiles.indexOrNullWhere((e) => e.id == _args.initialProfileId);

        if (index != null) {
          _previousPage = index;
          _pageController.jumpToPage(index);
        }

        _loadData(index ?? 0, mainViewModel.profiles);
        if (mounted) {
          setState(() { });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        actions: [
          TextButton(
            onPressed: () {
            },
            child: const Text('X'),
          ),
        ],
      ),
      body: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          final profiles = viewModel.profiles;

          return PageView(
            controller: _pageController,
            onPageChanged: (page) => _onPageChanged(page, profiles),
            children: profiles.map((profile) => _PokemonDetailsView(
              profile: profile,
              statistics: _getStatistics(profile),
            )).toList(),
          );
        }
      ),
    );
  }

  void _onPageChanged(int page, List<PokemonProfile> profiles) {
    scheduleMicrotask(() {
      _loadData(page, profiles);
    });
  }

  Future<void> _loadData(int index, List<PokemonProfile> profiles) async {
    var delta = index - _previousPage;
    var preloadIndex = delta == 0 && profiles.length > 1 ? null : (
        (profiles.length + index + delta) % profiles.length
    );

    PokemonProfileStatistics? currentStatistics;
    PokemonProfileStatistics? preloadStatistics;

    for (final data in [..._cache]) {
      if (data.profile.id == profiles[index].id) {
        currentStatistics = data;
      } else if (preloadIndex != null &&
          data.profile.id == profiles[preloadIndex].id) {
        preloadStatistics = data;
      }

      if (currentStatistics != null && preloadStatistics != null) {
        break;
      }
    }

    _cache.removeWhere((statistics) {
      return statistics.profile.id == currentStatistics?.profile.id ||
          statistics.profile.id == preloadStatistics?.profile.id;
    });

    if (currentStatistics == null) {
      currentStatistics = PokemonProfileStatistics.from(profiles[index]);
      currentStatistics.init();
    }
    if (preloadIndex != null && preloadStatistics == null) {
      preloadStatistics = PokemonProfileStatistics.from(profiles[preloadIndex]);
      preloadStatistics.init();
    }

    _cache.add(currentStatistics);
    if (preloadStatistics != null) {
      _cache.add(preloadStatistics);
    }

    setState(() { });
  }

  PokemonProfileStatistics? _getStatistics(PokemonProfile profile) {
    return _cache.firstWhereOrNull((e) => e.profile.id == profile.id);
  }

}

class _PokemonDetailsView extends StatelessWidget {
  const _PokemonDetailsView({
    required this.profile,
    this.statistics,
  });

  final PokemonProfile profile;
  final PokemonProfileStatistics? statistics;

  @override
  Widget build(BuildContext context) {
    return buildListView(
      children: _buildListItems(),
    );
  }

  List<Widget> _buildListItems() {
    return [
      Gap.xl,
      ...Hp.list(
        children: [
          Text(
            profile.basicProfile.nameI18nKey,
          ),
          Text(
            statistics?.rank ?? '',
          ),
        ],
      ),
      Gap.trailing,
    ];
  }
}





