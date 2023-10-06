import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/helpers/common/my_cache_manager.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';

class EvolutionRepository implements MyInjectable {
  Future<Map<int, Evolution>> findAllMapping() async {
    return {
      1: Evolution.from(1, 1, null, [ EvolutionStage.from(2, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
      2: Evolution.from(2, 2, 1, [ EvolutionStage.from(3, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":24}') ], ), ]),
      3: Evolution.from(3, 3, 2, [ ]),
      4: Evolution.from(4, 1, 2, [ EvolutionStage.from(5, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
      5: Evolution.from(5, 2, 4, [ EvolutionStage.from(6, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
      6: Evolution.from(6, 3, 5, [ ]),
      7: Evolution.from(7, 1, 5, [ EvolutionStage.from(8, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
      8: Evolution.from(8, 2, 7, [ EvolutionStage.from(9, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
      9: Evolution.from(9, 3, 8, [ ]),
      10: Evolution.from(10, 1, 8, [ EvolutionStage.from(11, [ const EvolutionConditionRaw('{"type":"level","level":5}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      11: Evolution.from(11, 2, 10, [ EvolutionStage.from(12, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":8}') ], ), ]),
      12: Evolution.from(12, 3, 11, [ ]),
      13: Evolution.from(13, 1, 11, [ EvolutionStage.from(14, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":15}') ], ), ]),
      14: Evolution.from(14, 2, 13, [ ]),
      15: Evolution.from(15, 1, 13, [ EvolutionStage.from(16, [ const EvolutionConditionRaw('{"type":"level","level":17}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      16: Evolution.from(16, 2, 15, [ ]),
      18: Evolution.from(18, 2, 17, [ EvolutionStage.from(19, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":24}') ], ), ]),
      19: Evolution.from(19, 3, 18, [ ]),
      107: Evolution.from(107, 2, 109, [ EvolutionStage.from(108, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":27}') ], ), ]),
      108: Evolution.from(108, 3, 107, [ ]),
      21: Evolution.from(21, 2, 20, [ EvolutionStage.from(22, [ const EvolutionConditionRaw('{"type":"item","item":27}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
      22: Evolution.from(22, 3, 21, [ ]),
      23: Evolution.from(23, 1, 21, [ EvolutionStage.from(24, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":20}') ], ), ]),
      24: Evolution.from(24, 2, 23, [ ]),
      25: Evolution.from(25, 1, 23, [ EvolutionStage.from(26, [ const EvolutionConditionRaw('{"type":"level","level":21}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      26: Evolution.from(26, 2, 25, [ ]),
      27: Evolution.from(27, 1, 25, [ EvolutionStage.from(28, [ const EvolutionConditionRaw('{"type":"level","level":25}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      28: Evolution.from(28, 2, 27, [ ]),
      29: Evolution.from(29, 1, 27, [ EvolutionStage.from(30, [ const EvolutionConditionRaw('{"type":"level","level":21}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      30: Evolution.from(30, 2, 29, [ ]),
      31: Evolution.from(31, 1, 29, [ EvolutionStage.from(32, [ const EvolutionConditionRaw('{"type":"item","item":22}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
      32: Evolution.from(32, 2, 31, [ ]),
      33: Evolution.from(33, 1, 31, [ EvolutionStage.from(34, [ const EvolutionConditionRaw('{"type":"level","level":16}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      34: Evolution.from(34, 2, 33, [ EvolutionStage.from(35, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":25}') ], ), ]),
      35: Evolution.from(35, 3, 34, [ ]),
      36: Evolution.from(36, 1, 34, [ EvolutionStage.from(37, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":19}') ], ), ]),
      37: Evolution.from(37, 2, 36, [ EvolutionStage.from(38, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":21}') ], ), ]),
      38: Evolution.from(38, 3, 37, [ ]),
      39: Evolution.from(39, 1, 37, [ EvolutionStage.from(40, [ const EvolutionConditionRaw('{"type":"level","level":28}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), EvolutionStage.from(41, [ const EvolutionConditionRaw('{"type":"item","item":21}'), const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":31}') ], ), ]),
      40: Evolution.from(40, 2, 39, [ ]),
      42: Evolution.from(42, 1, 39, [ EvolutionStage.from(43, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":23}') ], ), ]),
      43: Evolution.from(43, 2, 42, [ EvolutionStage.from(44, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":24}') ], ), ]),
      45: Evolution.from(45, 1, 42, [ EvolutionStage.from(46, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":23}') ], ), ]),
      46: Evolution.from(46, 2, 45, [ ]),
      47: Evolution.from(47, 1, 45, [ EvolutionStage.from(48, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":19}') ], ), ]),
      48: Evolution.from(48, 2, 47, [ EvolutionStage.from(49, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":21}') ], ), ]),
      49: Evolution.from(49, 3, 48, [ ]),
      50: Evolution.from(50, 1, 48, [ EvolutionStage.from(51, [ const EvolutionConditionRaw('{"type":"level","level":21}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      51: Evolution.from(51, 2, 50, [ ]),
      52: Evolution.from(52, 1, 50, [ ]),
      106: Evolution.from(106, 2, 105, [ ]),
      53: Evolution.from(53, 1, 105, [ ]),
      54: Evolution.from(54, 1, 105, [ ]),
      55: Evolution.from(55, 1, 105, [ EvolutionStage.from(57, [ const EvolutionConditionRaw('{"type":"item","item":23}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(58, [ const EvolutionConditionRaw('{"type":"item","item":24}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(59, [ const EvolutionConditionRaw('{"type":"item","item":22}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(60, [ const EvolutionConditionRaw('{"type":"timing","startHour":6,"endHour":18}'), const EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(61, [ const EvolutionConditionRaw('{"type":"timing","startHour":18,"endHour":6}'), const EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(62, [ const EvolutionConditionRaw('{"type":"item","item":25}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(63, [ const EvolutionConditionRaw('{"type":"item","item":26}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), EvolutionStage.from(56, [ const EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
      57: Evolution.from(57, 2, 55, [ ]),
      58: Evolution.from(58, 2, 55, [ ]),
      59: Evolution.from(59, 2, 55, [ ]),
      64: Evolution.from(64, 1, 55, [ EvolutionStage.from(65, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
      65: Evolution.from(65, 2, 64, [ EvolutionStage.from(66, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":24}') ], ), ]),
      66: Evolution.from(66, 3, 65, [ ]),
      67: Evolution.from(67, 1, 65, [ EvolutionStage.from(68, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":11}') ], ), ]),
      68: Evolution.from(68, 2, 67, [ EvolutionStage.from(69, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
      69: Evolution.from(69, 3, 68, [ ]),
      70: Evolution.from(70, 1, 68, [ EvolutionStage.from(71, [ const EvolutionConditionRaw('{"type":"level","level":14}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      71: Evolution.from(71, 2, 70, [ EvolutionStage.from(72, [ const EvolutionConditionRaw('{"type":"level","level":23}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
      72: Evolution.from(72, 3, 71, [ ]),
      17: Evolution.from(17, 1, 71, [ EvolutionStage.from(18, [ const EvolutionConditionRaw('{"type":"sleepTime","hours":50}'), const EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
      109: Evolution.from(109, 1, 71, [ EvolutionStage.from(107, [ const EvolutionConditionRaw('{"type":"candy","count":20}'), const EvolutionConditionRaw('{"type":"sleepTime","hours":50}') ], ), ]),
      20: Evolution.from(20, 1, 71, [ EvolutionStage.from(21, [ const EvolutionConditionRaw('{"type":"sleepTime","hours":50}'), const EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
      73: Evolution.from(73, 1, 71, [ EvolutionStage.from(74, [ const EvolutionConditionRaw('{"type":"sleepTime","hours":50}'), const EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
      74: Evolution.from(74, 2, 73, [ EvolutionStage.from(75, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"item","item":28}') ], ), ]),
      76: Evolution.from(76, 1, 73, [ EvolutionStage.from(77, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":11}') ], ), ]),
      77: Evolution.from(77, 2, 76, [ EvolutionStage.from(78, [ const EvolutionConditionRaw('{"type":"level","level":23}'), const EvolutionConditionRaw('{"type":"candy","count":80}') ], ), ]),
      78: Evolution.from(78, 3, 77, [ ]),
      80: Evolution.from(80, 2, 79, [ ]),
      60: Evolution.from(60, 2, 55, [ ]),
      61: Evolution.from(61, 2, 55, [ ]),
      41: Evolution.from(41, 2, 39, [ ]),
      82: Evolution.from(82, 2, 81, [ ]),
      83: Evolution.from(83, 1, 81, [ ]),
      84: Evolution.from(84, 1, 81, [ EvolutionStage.from(85, [ const EvolutionConditionRaw('{"type":"level","level":18}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      85: Evolution.from(85, 2, 84, [ ]),
      86: Evolution.from(86, 1, 84, [ EvolutionStage.from(87, [ const EvolutionConditionRaw('{"type":"level","level":23}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      87: Evolution.from(87, 2, 86, [ EvolutionStage.from(88, [ const EvolutionConditionRaw('{"type":"level","level":41}'), const EvolutionConditionRaw('{"type":"candy","count":100}') ], ), ]),
      88: Evolution.from(88, 3, 87, [ ]),
      89: Evolution.from(89, 1, 87, [ EvolutionStage.from(90, [ const EvolutionConditionRaw('{"type":"level","level":14}'), const EvolutionConditionRaw('{"type":"candy","count":40}') ], ), ]),
      90: Evolution.from(90, 2, 89, [ EvolutionStage.from(91, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":27}') ], ), ]),
      91: Evolution.from(91, 3, 90, [ ]),
      92: Evolution.from(92, 1, 90, [ ]),
      93: Evolution.from(93, 1, 90, [ EvolutionStage.from(94, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":20}') ], ), ]),
      94: Evolution.from(94, 2, 93, [ ]),
      95: Evolution.from(95, 1, 93, [ EvolutionStage.from(96, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":26}') ], ), ]),
      96: Evolution.from(96, 2, 95, [ ]),
      97: Evolution.from(97, 1, 95, [ ]),
      81: Evolution.from(81, 1, 95, [ EvolutionStage.from(82, [ const EvolutionConditionRaw('{"type":"level","level":11}'), const EvolutionConditionRaw('{"type":"candy","count":20}') ], ), ]),
      98: Evolution.from(98, 1, 95, [ EvolutionStage.from(99, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":24}') ], ), ]),
      99: Evolution.from(99, 2, 98, [ EvolutionStage.from(100, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"level","level":33}') ], ), ]),
      100: Evolution.from(100, 3, 99, [ ]),
      79: Evolution.from(79, 1, 99, [ EvolutionStage.from(80, [ const EvolutionConditionRaw('{"type":"candy","count":20}'), const EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
      105: Evolution.from(105, 1, 99, [ EvolutionStage.from(106, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":12}') ], ), ]),
      101: Evolution.from(101, 1, 99, [ EvolutionStage.from(102, [ const EvolutionConditionRaw('{"type":"candy","count":80}'), const EvolutionConditionRaw('{"type":"sleepTime","hours":150}'), const EvolutionConditionRaw('{"type":"timing","startHour":6,"endHour":18}') ], ), ]),
      102: Evolution.from(102, 2, 101, [ ]),
      103: Evolution.from(103, 1, 101, [ EvolutionStage.from(104, [ const EvolutionConditionRaw('{"type":"candy","count":40}'), const EvolutionConditionRaw('{"type":"level","level":28}') ], ), ]),
      104: Evolution.from(104, 2, 103, [ ]),
      44: Evolution.from(44, 3, 43, [ ]),
      75: Evolution.from(75, 3, 74, [ ]),
      62: Evolution.from(62, 2, 55, [ ]),
      63: Evolution.from(63, 2, 55, [ ]),
      56: Evolution.from(56, 2, 55, [ ]),
    };
  }

  Future<List<List<Evolution>>> findByBasicProfileId(int basicProfileId) async {
    final mapping = await findAllMapping();
    final res = List.generate(MAX_POKEMON_EVOLUTION_STAGE, (index) => <Evolution>[]);

    final baseEvolution = mapping[basicProfileId]!;

    tourPrevious(Evolution evolution) {
      if (baseEvolution.basicProfileId != evolution.basicProfileId) {
        res[evolution.stage - 1].add(evolution);
      }
      final previousBasicProfileId = evolution.previousBasicProfileId;
      if (previousBasicProfileId == null || evolution.stage == 1) {
        return;
      }
      tourPrevious(mapping[previousBasicProfileId]!);
    }

    tourNext(Evolution evolution) {
      res[evolution.stage - 1].add(evolution);
      for (var nextStage in evolution.nextStages) {
        final nextEvolution = mapping[nextStage.basicProfileId];
        if (nextEvolution == null) {
          print('nextEvolution is null: ${nextStage.basicProfileId}');
          continue;
        }
        tourNext(nextEvolution);
      }
    }
    tourNext(baseEvolution);
    tourPrevious(baseEvolution);

    return res;
  }

}