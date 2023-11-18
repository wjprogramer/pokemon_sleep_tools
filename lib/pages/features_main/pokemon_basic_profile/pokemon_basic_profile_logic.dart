part of 'pokemon_basic_profile_page.dart';

class _PokemonBasicProfileLogic extends State<PokemonBasicProfilePage> {

  SleepFaceRepository get _sleepFaceRepo => getIt();
  EvolutionRepository get _evolutionRepo => getIt();
  PokemonBasicProfileRepository get _basicProfileRepo => getIt();

  PokemonBasicProfile get _basicProfile => widget._args.basicProfile;
  bool get _isView => widget._args.isView;

  // UI
  late ThemeData _theme;

  // Page status
  var _initialized = false;

  // Data (fixed)
  var _basicIdSetGroupByField = <PokemonField, Set<int>>{};

  // Data
  final _sleepFacesOfField = <PokemonField, List<SleepFace>>{};
  var _allSleepStyles = <int>[];

  /// [SleepFace.style] to its nama
  var _sleepNamesOfBasicProfile = <int, String>{};

  var _existInBox = false;

  var _currPokemonLevel = 1;
  double? _ingredientRate;

  // Data evolutions
  List<List<Evolution>> _evolutions = List.generate(MAX_POKEMON_EVOLUTION_STAGE, (index) => []);

  var _basicProfilesInEvolutionChain = <int, PokemonBasicProfile>{};

  late PokemonBasicProfile _basicProfileWithSmallestBoxNoInChain;

  // Data / UI
  var _leadingWidth = 0.0;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      _load();
    });
  }

  Future<void> _load() async {
    // Clear or reset
    _initialized = false;
    _basicProfileWithSmallestBoxNoInChain = _basicProfile;
    _sleepFacesOfField.clear();
    for (final field in PokemonField.values) {
      _sleepFacesOfField[field] = [];
    }

    final mainViewModel = context.read<MainViewModel>();
    final profiles = await mainViewModel.loadProfiles();
    _existInBox = profiles.any((element) => element.basicProfileId == _basicProfile.id);

    final allSleepFaces = await _sleepFaceRepo.findAll();
    final sleepFaces = allSleepFaces.where((sleepFace) => sleepFace.basicProfileId == _basicProfile.id).toList();

    final allSleepNames = await _sleepFaceRepo.findAllNames();
    _sleepNamesOfBasicProfile = allSleepNames[_basicProfile.id] ?? {};

    final allSleepStylesSet = <int>{};
    for (final sleepFace in sleepFaces) {
      _sleepFacesOfField[sleepFace.field]?.add(sleepFace);
      allSleepStylesSet.add(sleepFace.style);
    }

    _allSleepStyles = [...allSleepStylesSet];
    _allSleepStyles.sort((a, b) {
      final as = a == -1 ? 4 : a;
      final bs = b == -1 ? 4 : b;
      return as.compareTo(bs);
    });

    final sleepFacesGroupByField = await _sleepFaceRepo.findAllGroupByField();
    final basicIdSetGroupByField = sleepFacesGroupByField.toMap(
          (field, basicProfiles) => field,
          (field, basicProfiles) => {...basicProfiles.map((e) => e.basicProfileId)},
    );
    _basicIdSetGroupByField = basicIdSetGroupByField;

    final evolutions = await _evolutionRepo.findByBasicProfileId(_basicProfile.id);
    _evolutions = evolutions;

    final basicProfileIdInEvolutionChain = evolutions
        .expand((e) => e)
        .map((e) => e.basicProfileId)
        .toList();

    _basicProfilesInEvolutionChain = await _basicProfileRepo
        .findByIdList(basicProfileIdInEvolutionChain); // _evolutions
    _basicProfileWithSmallestBoxNoInChain = _basicProfilesInEvolutionChain
        .entries.map((e) => e.value)
        .firstWhereByCompare((a, b) => a.boxNo < b.boxNo);

    _ingredientRate = (await _basicProfileRepo.findAllIngredientRateOf())[_basicProfile.id];

    _initialized = true;
    if (mounted) {
      setState(() { });
    }
  }

  @override
  void didUpdateWidget(covariant PokemonBasicProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _load();
  }

  VoidCallback? _getViewPokedexCallback() {
    if (!_existInBox) {
      return null;
    }

    return () {
      PokemonBoxPage.go(
        context,
        initialSearchOptions: PokemonSearchOptions(
          keyword: _basicProfile.nameI18nKey.xTr,
        ),
      );
    };
  }

  VoidCallback _getAddToBoxCallback(Ingredient ingredient) {
    return () {
      IngredientPage.go(context, ingredient);
    };
  }

  void _onSleepFaceMarkToggled(SleepFace sleepFace, List<int> markStyles) {
    final facesViewModels = context.read<SleepFaceViewModel>();

    if (markStyles.contains(sleepFace.style)) {
      facesViewModels.removeMark(sleepFace.basicProfileId, sleepFace.style);
    } else {
      facesViewModels.mark(sleepFace.basicProfileId, sleepFace.style);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;


    final screenSize = MediaQuery.of(context).size;
    _leadingWidth = math.min(screenSize.width * 0.3, 150.0);

    return _PokemonBasicProfileView(this);
  }
}
