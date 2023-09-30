import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';

class PokemonTeam {
  PokemonTeam({
    required this.id,
    required this.name,
    required this.profileIdList,
  });

  int id;
  String? name;
  List<int> profileIdList;

  factory PokemonTeam.fromJson(Map<String, dynamic> json) {
    return PokemonTeam(
      id: json['id'],
      name: json['name'],
      profileIdList: (json['profileIdList'] as Iterable)
          .whereType<num>()
          .map((e) => e.toInt())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileIdList': profileIdList,
    };
  }

  PokemonTeam copyWith({
    int? id,
    String? name,
    List<int>? profileIdList,
  }) {
    return PokemonTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      profileIdList: profileIdList ?? this.profileIdList,
    );
  }

  static String getDefaultName({ int? index }) {
      return 't_helper_team'.xTr +
          (index != null ? ' ${index + 1}' : '');
  }

  String getDisplayText({ int? index }) {
    return name ?? getDefaultName(index: index);
  }

}