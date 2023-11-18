import 'package:collection/collection.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

class PokemonSortOptions implements BaseSortOptions<PokemonSortOption> {
  PokemonSortOptions({
    List<PokemonSortOption>? sortOptions,
    initAscending = true,
  }): _sortOptions = sortOptions ?? [],
        _isAscending = initAscending;

  final List<PokemonSortOption> _sortOptions;

  bool _isAscending;

  @override
  bool get isAscending => _isAscending;

  /// 目前先限制只能選一個
  static const _maxCount = 1;

  /// 因為目前支援單個 [_maxCount] == 1
  PokemonSortOption? get _firstSortOption => _sortOptions.firstOrNull;

  @override
  List<PokemonSortOption> get sortOptions => _sortOptions;

  @override
  bool get isEmpty => _sortOptions.isEmpty;

  @override
  void appendOption(PokemonSortOption sortOption) {
    if (_sortOptions.length >= _maxCount) {
      _sortOptions.removeAt(0);
    }
    _sortOptions.add(sortOption);
  }

  @override
  void remove(PokemonSortOption option) {
    _sortOptions.remove(option);
  }

  @override
  BaseSortOptions clone() {
    return PokemonSortOptions(
      sortOptions: _sortOptions,
    );
  }

  @override
  void clear() {
    _sortOptions.clear();
  }

  @override
  void dispose() {
  }

  List<PokemonProfile> sortProfiles(List<PokemonProfile> profiles) {
    print(_firstSortOption);
    return profiles.sorted((a, b) => _compare(
      _firstSortOption ?? PokemonSortOption.createDate,
      isAscending: _isAscending,
      basicA: a.basicProfile,
      basicB: b.basicProfile,
      profileA: a,
      profileB: b,
    ));
  }

  List<PokemonBasicProfile> sortBasicProfiles(List<PokemonBasicProfile> basicProfiles) {
    return basicProfiles.sorted((a, b) => _compare(
      _firstSortOption!,
      isAscending: _isAscending,
      basicA: a,
      basicB: b,
    ));
  }

  int _compare(PokemonSortOption sortOption, {
    required PokemonBasicProfile basicA,
    required PokemonBasicProfile basicB,
    required bool isAscending,
    PokemonProfile? profileA,
    PokemonProfile? profileB,
  }) {
    final firstSortOption = sortOption;

    final v = switch (firstSortOption) {
      PokemonSortOption.boxNo => basicA.boxNo.compareTo(basicB.boxNo),
      PokemonSortOption.createDate => profileA!.id.compareTo(profileB!.id),
    };

    return isAscending ? v : -v;
  }

  @override
  void toggleAscending() {
    _isAscending = !_isAscending;
  }

  @override
  void setAscending(bool isAscending) {
    _isAscending = isAscending;
  }

}

/// [boxNo] : compare to [PokemonBasicProfile.boxNo]
/// [createDate] : compare to [PokemonProfile.id]
enum PokemonSortOption {
  boxNo('圖鑑編號', false),
  createDate('新增時間', true),
  ;

  const PokemonSortOption(this.nameI18nKey, this.isProfileOnly);

  final String nameI18nKey;

  /// Only for [PokemonProfile], not for [PokemonBasicProfile]
  final bool isProfileOnly;

  static List<PokemonSortOption> getValuesForProfile() {
    return PokemonSortOption.values;
  }

  static List<PokemonSortOption> getValuesForBasicProfile() {
    return PokemonSortOption.values.where((e) => !e.isProfileOnly).toList();
  }

}