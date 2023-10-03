import 'package:pokemon_sleep_tools/data/models/models.dart';

class SleepFace {
  SleepFace({
    required this.basicProfileId,
    required this.snorlaxRank,
    required this.style,
    required this.rewards,
    required this.field,
  });

  factory SleepFace.from(int basicProfileId, SnorlaxRank snorlaxRank, int style, SleepFaceRewards rewards, PokemonField field) {
    return SleepFace(
      basicProfileId: basicProfileId,
      snorlaxRank: snorlaxRank,
      style: style,
      rewards: rewards,
      field: field,
    );
  }

  final int basicProfileId;
  final SnorlaxRank snorlaxRank;
  final int style;
  final SleepFaceRewards rewards;
  final PokemonField field;

}

class SleepFaceRewards {
  SleepFaceRewards(this.exp, this.shards, this.candy);

  final int exp;
  final int shards;
  final int candy;
}