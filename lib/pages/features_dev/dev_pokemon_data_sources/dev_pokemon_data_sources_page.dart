import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/data_sources/data_sources.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_pokemon_evolutions/dev_pokemon_evolutions_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/pokemon_evolution_illustrated_book/pokemon_evolution_illustrated_book_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

/// TODO: Complete
///
/// - 不驗證進化資料，進化的驗證請參考 [DevPokemonEvolutionsPage] 或 [PokemonEvolutionIllustratedBookPage]
/// - 不用在意效能，只是用來驗證資料
class DevPokemonDataSourcesPage extends StatefulWidget {
  const DevPokemonDataSourcesPage._();

  static const MyPageRoute route = ('/DevPokemonDataSourcesPage', _builder);
  static Widget _builder(dynamic args) {
    return const DevPokemonDataSourcesPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DevPokemonDataSourcesPage> createState() => _DevPokemonDataSourcesPageState();
}

class _DevPokemonDataSourcesPageState extends State<DevPokemonDataSourcesPage> {

  String get _titleText => '資料驗證用'.xTr;

  // Page status
  var _initialized = false;
  String? _errMsg;

  // Data
  late Map<int, PokemonBasicProfile> _allPokemonMapping;
  late List<SleepFace> _sleepFaces;
  late Map<int, Map<int, String>> _sleepFaceNamesOf;
  late Map<int, double> _allIngredientRateOf;
  late Map<int, IngredientChain> _ingredientChainMap;

  // Data (result)
  final _data = <_Data>[];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _allPokemonMapping = DataSources.allPokemonMapping;
      _sleepFaces = DataSources.findSleepFaces();
      _sleepFaceNamesOf = DataSources.findSleepFaceNames();
      _allIngredientRateOf = DataSources.allIngredientRateOf;
      _ingredientChainMap = DataSources.ingredientChainMap;

      try {
        _validateBasic();

        // BasicProfiles
        for (final entry in _allPokemonMapping.entries) {
          if (entry.key != entry.value.id) {
            throw Exception('basicProfile id (${entry.value.id}) 與 Map key (${entry.key}) 不同');
          }
          final basicProfile = entry.value;
          _data.add(_Data(basicProfile));
        }

        // Prepare / SleepFace
        final idToSleepFaces = <int, List<SleepFace>>{};
        for (final sleepFace in _sleepFaces) {
          idToSleepFaces
              .putIfAbsent(sleepFace.basicProfileId, () => [])
              .add(sleepFace);
        }

        // Inject data
        for (final data in _data) {
          data.sleepFaces.addAll(
            idToSleepFaces[data.basicProfile.id] ?? [],
          );
        }
      } catch (e) {
        _errMsg = e.toString();
      } finally {
        _initialized = true;
        setState(() { });
      }
    });
  }

  void _validateBasic() {
    try {

    } catch (e) {
      _errMsg = e.toString();
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const LoadingView();
    }

    if (_errMsg != null) {
      return Scaffold(
        appBar: buildAppBar(
          titleText: _titleText,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '錯誤',
              textAlign: TextAlign.center,
            ),
            Text(
              _errMsg ?? '',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: _titleText,
      ),
    );
  }
}

class _Data {
  _Data(this.basicProfile);

  final PokemonBasicProfile basicProfile;
  List<SleepFace> sleepFaces = [];
}


