import 'dart:convert';

import 'package:pokemon_sleep_tools/data/models/common/common.dart';

class Evolution {
  Evolution({
    required this.basicProfileId,
    required this.stage,
    required this.previousBasicProfileId,
    required this.nextStages,
  });

  factory Evolution.from(
    int basicProfileId,
    int stage,
    int? previousBasicProfileId,
    List<EvolutionStage> nextStages,
  ) {
    return Evolution(
      basicProfileId: basicProfileId,
      stage: stage,
      previousBasicProfileId: previousBasicProfileId,
      nextStages: nextStages,
    );
  }

  /// [PokemonBasicProfile.id]
  final int basicProfileId;

  /// 目前的進化階數
  final int stage;

  /// [PokemonBasicProfile.id]
  final int? previousBasicProfileId;

  final List<EvolutionStage> nextStages;
}

class EvolutionStage {
  EvolutionStage({
    required this.basicProfileId,
    required this.conditions,
  });

  factory EvolutionStage.from(int basicProfileId, List<BaseEvolutionCondition> conditions) {
    return EvolutionStage(
      basicProfileId: basicProfileId,
      conditions: conditions,
    );
  }

  /// [PokemonBasicProfile.id]
  final int basicProfileId;

  final List<BaseEvolutionCondition> conditions;

}

sealed class BaseEvolutionCondition {
  const BaseEvolutionCondition();
}

class EvolutionConditionRaw extends BaseEvolutionCondition {
  EvolutionConditionRaw(String raw) {
    values = json.decode(raw);
  }

  late Map<String, dynamic> values;
}


tmpEvolutionTest(Map<int, PokemonBasicProfile> basicProfileOf) {
  final basicData = {
    1: Evolution.from(1, 1, 55, [ EvolutionStage.from(2, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
    2: Evolution.from(2, 2, 1, [ EvolutionStage.from(3, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":24}') ], ), ]),
    3: Evolution.from(3, 3, 2, [ ]),
    4: Evolution.from(4, 1, 2, [ EvolutionStage.from(5, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
    5: Evolution.from(5, 2, 4, [ EvolutionStage.from(6, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
    6: Evolution.from(6, 3, 5, [ ]),
    7: Evolution.from(7, 1, 5, [ EvolutionStage.from(8, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
    8: Evolution.from(8, 2, 7, [ EvolutionStage.from(9, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
    9: Evolution.from(9, 3, 8, [ ]),
    10: Evolution.from(10, 1, 8, [ EvolutionStage.from(11, [ EvolutionConditionRaw('{"type":"level","level":5}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    11: Evolution.from(11, 2, 10, [ EvolutionStage.from(12, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":8}') ], ), ]),
    12: Evolution.from(12, 3, 11, [ ]),
    13: Evolution.from(13, 1, 11, [ EvolutionStage.from(20, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":15}') ], ), ]),
    14: Evolution.from(14, 2, 13, [ ]),
    15: Evolution.from(15, 1, 13, [ EvolutionStage.from(24, [ EvolutionConditionRaw('{"type":"level","level":17}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    16: Evolution.from(16, 2, 15, [ ]),
    18: Evolution.from(18, 2, 17, [ EvolutionStage.from(26, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":24}') ], ), ]),
    19: Evolution.from(19, 3, 18, [ ]),
    107: Evolution.from(107, 2, 109, [ EvolutionStage.from(36, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":27}') ], ), ]),
    108: Evolution.from(108, 3, 107, [ ]),
    21: Evolution.from(21, 2, 20, [ EvolutionStage.from(40, [ EvolutionConditionRaw('{"type":"item","item":27}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
    22: Evolution.from(22, 3, 21, [ ]),
    23: Evolution.from(23, 1, 21, [ EvolutionStage.from(51, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":20}') ], ), ]),
    24: Evolution.from(24, 2, 23, [ ]),
    25: Evolution.from(25, 1, 23, [ EvolutionStage.from(53, [ EvolutionConditionRaw('{"type":"level","level":21}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    26: Evolution.from(26, 2, 25, [ ]),
    27: Evolution.from(27, 1, 25, [ EvolutionStage.from(55, [ EvolutionConditionRaw('{"type":"level","level":25}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    28: Evolution.from(28, 2, 27, [ ]),
    29: Evolution.from(29, 1, 27, [ EvolutionStage.from(57, [ EvolutionConditionRaw('{"type":"level","level":21}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    30: Evolution.from(30, 2, 29, [ ]),
    31: Evolution.from(31, 1, 29, [ EvolutionStage.from(59, [ EvolutionConditionRaw('{"type":"item","item":22}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
    32: Evolution.from(32, 2, 31, [ ]),
    33: Evolution.from(33, 1, 31, [ EvolutionStage.from(70, [ EvolutionConditionRaw('{"type":"level","level":16}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    34: Evolution.from(34, 2, 33, [ EvolutionStage.from(71, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":25}') ], ), ]),
    35: Evolution.from(35, 3, 34, [ ]),
    36: Evolution.from(36, 1, 34, [ EvolutionStage.from(75, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":19}') ], ), ]),
    37: Evolution.from(37, 2, 36, [ EvolutionStage.from(76, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":21}') ], ), ]),
    38: Evolution.from(38, 3, 37, [ ]),
    39: Evolution.from(39, 1, 37, [ EvolutionStage.from(80, [ EvolutionConditionRaw('{"type":"level","level":28}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), EvolutionStage.from(199, [ EvolutionConditionRaw('{"type":"item","item":21}'), EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":31}') ], ), ]),
    40: Evolution.from(40, 2, 39, [ ]),
    42: Evolution.from(42, 1, 39, [ EvolutionStage.from(82, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":23}') ], ), ]),
    43: Evolution.from(43, 2, 42, [ EvolutionStage.from(462, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":24}') ], ), ]),
    45: Evolution.from(45, 1, 42, [ EvolutionStage.from(85, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":23}') ], ), ]),
    46: Evolution.from(46, 2, 45, [ ]),
    47: Evolution.from(47, 1, 45, [ EvolutionStage.from(93, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":19}') ], ), ]),
    48: Evolution.from(48, 2, 47, [ EvolutionStage.from(94, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":21}') ], ), ]),
    49: Evolution.from(49, 3, 48, [ ]),
    50: Evolution.from(50, 1, 48, [ EvolutionStage.from(105, [ EvolutionConditionRaw('{"type":"level","level":21}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    51: Evolution.from(51, 2, 50, [ ]),
    52: Evolution.from(52, 1, 50, [ ]),
    106: Evolution.from(106, 2, 105, [ ]),
    53: Evolution.from(53, 1, 105, [ ]),
    54: Evolution.from(54, 1, 105, [ ]),
    55: Evolution.from(55, 1, 105, [ EvolutionStage.from(134, [ EvolutionConditionRaw('{"type":"item","item":23}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(135, [ EvolutionConditionRaw('{"type":"item","item":24}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(136, [ EvolutionConditionRaw('{"type":"item","item":22}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(196, [ EvolutionConditionRaw('{"type":"timing","startHour":6,"endHour":18}'), EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(197, [ EvolutionConditionRaw('{"type":"timing","startHour":18,"endHour":6}'), EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(470, [ EvolutionConditionRaw('{"type":"item","item":25}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(471, [ EvolutionConditionRaw('{"type":"item","item":26}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(700, [ EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
    57: Evolution.from(57, 2, 55, [ ]),
    58: Evolution.from(58, 2, 55, [ ]),
    59: Evolution.from(59, 2, 55, [ ]),
    64: Evolution.from(64, 1, 55, [ EvolutionStage.from(153, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
    65: Evolution.from(65, 2, 64, [ EvolutionStage.from(154, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":24}') ], ), ]),
    66: Evolution.from(66, 3, 65, [ ]),
    67: Evolution.from(67, 1, 65, [ EvolutionStage.from(156, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":11}') ], ), ]),
    68: Evolution.from(68, 2, 67, [ EvolutionStage.from(157, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
    69: Evolution.from(69, 3, 68, [ ]),
    70: Evolution.from(70, 1, 68, [ EvolutionStage.from(159, [ EvolutionConditionRaw('{"type":"level","level":14}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    71: Evolution.from(71, 2, 70, [ EvolutionStage.from(160, [ EvolutionConditionRaw('{"type":"level","level":23}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
    72: Evolution.from(72, 3, 71, [ ]),
    17: Evolution.from(17, 1, 71, [ EvolutionStage.from(25, [ EvolutionConditionRaw('{"type":"sleepTime","hours":50}'), EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
    109: Evolution.from(109, 1, 71, [ EvolutionStage.from(35, [ EvolutionConditionRaw('{"type":"candy","count":20}'), EvolutionConditionRaw('{"type":"sleepTime","hours":50}') ], ), ]),
    20: Evolution.from(20, 1, 71, [ EvolutionStage.from(39, [ EvolutionConditionRaw('{"type":"sleepTime","hours":50}'), EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
    73: Evolution.from(73, 1, 71, [ EvolutionStage.from(176, [ EvolutionConditionRaw('{"type":"sleepTime","hours":50}'), EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
    74: Evolution.from(74, 2, 73, [ EvolutionStage.from(468, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"item","item":28}') ], ), ]),
    76: Evolution.from(76, 1, 73, [ EvolutionStage.from(180, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":11}') ], ), ]),
    77: Evolution.from(77, 2, 76, [ EvolutionStage.from(181, [ EvolutionConditionRaw('{"type":"level","level":23}'), EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
    78: Evolution.from(78, 3, 77, [ ]),
    80: Evolution.from(80, 2, 79, [ ]),
    60: Evolution.from(60, 2, 55, [ ]),
    61: Evolution.from(61, 2, 55, [ ]),
    41: Evolution.from(41, 2, 39, [ ]),
    82: Evolution.from(82, 2, 81, [ ]),
    83: Evolution.from(83, 1, 81, [ ]),
    84: Evolution.from(84, 1, 81, [ EvolutionStage.from(229, [ EvolutionConditionRaw('{"type":"level","level":18}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    85: Evolution.from(85, 2, 84, [ ]),
    86: Evolution.from(86, 1, 84, [ EvolutionStage.from(247, [ EvolutionConditionRaw('{"type":"level","level":23}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    87: Evolution.from(87, 2, 86, [ EvolutionStage.from(248, [ EvolutionConditionRaw('{"type":"level","level":41}'), EvolutionConditionRaw('{"type":"candy","count":100}') ], ), ]),
    88: Evolution.from(88, 3, 87, [ ]),
    89: Evolution.from(89, 1, 87, [ EvolutionStage.from(288, [ EvolutionConditionRaw('{"type":"level","level":14}'), EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
    90: Evolution.from(90, 2, 89, [ EvolutionStage.from(289, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
    91: Evolution.from(91, 3, 90, [ ]),
    92: Evolution.from(92, 1, 90, [ ]),
    93: Evolution.from(93, 1, 90, [ EvolutionStage.from(317, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":20}') ], ), ]),
    94: Evolution.from(94, 2, 93, [ ]),
    95: Evolution.from(95, 1, 93, [ EvolutionStage.from(334, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":26}') ], ), ]),
    96: Evolution.from(96, 2, 95, [ ]),
    97: Evolution.from(97, 1, 95, [ ]),
    81: Evolution.from(81, 1, 95, [ EvolutionStage.from(202, [ EvolutionConditionRaw('{"type":"level","level":11}'), EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
    98: Evolution.from(98, 1, 95, [ EvolutionStage.from(364, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":24}') ], ), ]),
    99: Evolution.from(99, 2, 98, [ EvolutionStage.from(365, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"level","level":33}') ], ), ]),
    100: Evolution.from(100, 3, 99, [ ]),
    79: Evolution.from(79, 1, 99, [ EvolutionStage.from(185, [ EvolutionConditionRaw('{"type":"candy","count":20}'), EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
    105: Evolution.from(105, 1, 99, [ EvolutionStage.from(122, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
    101: Evolution.from(101, 1, 99, [ EvolutionStage.from(448, [ EvolutionConditionRaw('{"type":"candy","count":80}'), EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), EvolutionConditionRaw('{"type":"timing","startHour":6,"endHour":18}') ], ), ]),
    102: Evolution.from(102, 2, 101, [ ]),
    103: Evolution.from(103, 1, 101, [ EvolutionStage.from(454, [ EvolutionConditionRaw('{"type":"candy","count":40}'), EvolutionConditionRaw('{"type":"level","level":28}') ], ), ]),
    104: Evolution.from(104, 2, 103, [ ]),
    44: Evolution.from(44, 3, 43, [ ]),
    75: Evolution.from(75, 3, 74, [ ]),
    62: Evolution.from(62, 2, 55, [ ]),
    63: Evolution.from(63, 2, 55, [ ]),
    56: Evolution.from(56, 2, 55, [ ]),
  };

  final evolutionList = basicData.entries.map((e) => e.value).toList()..sort((a, b) => a.stage - b.stage);

  final results = <List<List<int>>>[];



  // print(results);
}

