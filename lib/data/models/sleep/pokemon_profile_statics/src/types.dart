part of 'statics.dart';

enum _Type {
  dev,
  userView,
}

enum _StatisticsLevelType {
  levelCustom,
  level100,
  level50,
}

class ProfileStatisticsResult {
  ProfileStatisticsResult(this.profile, this.rankLv50, this.rankLv100);

  final String rankLv50;
  final String rankLv100;
  final PokemonProfile profile;
}


// final double idealTotalBenefit;
// final double helpTeammateBenefitPerHour;
// final double diffEffectTotalBenefit;
// final double totalBenefitPerHour;
// final String rank;
