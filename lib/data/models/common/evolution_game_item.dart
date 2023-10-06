import 'package:pokemon_sleep_tools/data/models/models.dart';

/// TODO: 應該被 [GameItem] 取代？
enum EvolutionGameItem {
  i1(1, '聯繫繩', [ 39, 37, 48 ]),
  i2(2, '火之石', [ 55, 31 ]),
  i3(3, '水之石', [ 55, ]),
  i4(4, '雷之石', [ 55, 18, 43 ]),
  i5(5, '葉之石', [ 55, 34 ]),
  i6(6, '冰之石', [ 55, ]),
  i7(7, '月之石', [ 21, 107 ]),
  i8(8, '光之石', [ 74 ]),
  i9(9, '王者之證', [ 39 ]);

  const EvolutionGameItem(this.id, this.nameI18nKey, this.basicProfileIds);

  final int id;
  final String nameI18nKey;

  /// [PokemonBasicProfile.id] list
  final List<int> basicProfileIds;
}