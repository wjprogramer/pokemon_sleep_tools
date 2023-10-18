import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';

class PokemonTeam {
  PokemonTeam({
    required this.id,
    required this.name,
    required this.profileIdList,
    required this.comment,
    required this.tags,
  });

  int id;
  String? name;
  List<int> profileIdList;
  String? comment;
  List<String> tags;

  factory PokemonTeam.fromJson(Map<String, dynamic> json) {
    return PokemonTeam(
      id: json['id'],
      name: json['name'],
      profileIdList: (json['profileIdList'] as Iterable)
          .whereType<num>()
          .map((e) => e.toInt())
          .toList(),
      comment: json['comment'] as String?,
      tags: ((json['tags'] ?? []) as Iterable)
          .whereType<String>()
          .toList(),
    );
  }

  factory PokemonTeam.empty(int index) {
    return PokemonTeam(
      id: index,
      name: null,
      profileIdList: List.generate(MAX_TEAM_POKEMON_COUNT, (index) => -1),
      comment: null,
      tags: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileIdList': profileIdList,
      'comment': comment,
      'tags': tags,
    };
  }

  PokemonTeam copyWith({
    int? id,
    String? name,
    List<int>? profileIdList,
    String? comment,
    List<String>? tags,
  }) {
    return PokemonTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      profileIdList: profileIdList ?? this.profileIdList,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
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