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

// 評級, Rank
// String rank;
// if (pureTotalBenefitPerHour == 0) {
//   rank = '-';
// } else {
//   if (level < 50) {
//     rank = pureTotalBenefitPerHour >= 0.3 ? 'S' :
//     pureTotalBenefitPerHour >= 0.24 ? 'A' :
//     pureTotalBenefitPerHour >= 0.18 ? 'B' :
//     pureTotalBenefitPerHour >= 0.12 ? 'C' :
//     pureTotalBenefitPerHour >= 0.06 ? 'D' :
//     pureTotalBenefitPerHour >= 0 ? 'E' :
//     pureTotalBenefitPerHour < 0 ? 'F' : '-';
//   } else if (level < 100) {
//     rank = pureTotalBenefitPerHour >= 1 ? 'S' :
//     pureTotalBenefitPerHour >= 0.8 ? 'A' :
//     pureTotalBenefitPerHour >= 0.6 ? 'B' :
//     pureTotalBenefitPerHour >= 0.4 ? 'C' :
//     pureTotalBenefitPerHour >= 0.2 ? 'D' :
//     pureTotalBenefitPerHour >= 0 ? 'E' :
//     pureTotalBenefitPerHour < 0 ? 'F' : '-';
//   } else {
//     rank =  pureTotalBenefitPerHour >= 1.5 ? 'S+' :
//     pureTotalBenefitPerHour >= 1 ? 'S' :
//     pureTotalBenefitPerHour >= 0.8 ? 'A' :
//     pureTotalBenefitPerHour >= 0.6 ? 'B' :
//     pureTotalBenefitPerHour >= 0.4 ? 'C' :
//     pureTotalBenefitPerHour >= 0.2 ? 'D' :
//     pureTotalBenefitPerHour >= 0 ? 'E' :
//     pureTotalBenefitPerHour < 0 ? 'F' : '-';
//   }
// }