// 卡比獸等級

import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/data/models/sleep/rank_title.dart';

class SnorlaxRank {
  const SnorlaxRank(this.title, this.number);

  final RankTitle title;
  final int number;

  @override
  int get hashCode => Object.hashAll([title, number]);

  @override
  bool operator ==(Object other) {
    return other is SnorlaxRank
        && title == other.title
        && number == other.number;
  }
}
