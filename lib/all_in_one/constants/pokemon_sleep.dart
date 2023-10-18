import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

// ignore_for_file: constant_identifier_names

/// 寶可夢最高進化階數，根據個人經驗，目前最高就到 3
const MAX_POKEMON_EVOLUTION_STAGE = 3;

/// 每個隊伍容納最多的寶可夢數量
const MAX_TEAM_POKEMON_COUNT = 5;

/// 最多可以儲存多少隊伍數量
const MAX_TEAM_COUNT = 10;

/// 照理來說不會變啦，各世代好像都是 100 為上限
/// 如果真的變了，[ExpSleepUtility] 需要特別注意
const MAX_POKEMON_LEVEL = 100;

/// 食譜等級
const MAX_RECIPE_LEVEL = 50;

// region Pot (注意每個 list 的長度)
/// 鍋子容量
const POT_CAPACITIES_OPTIONS = [15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81];
/// 鍋子的需花費夢之碎片，數量需與 [POT_CAPACITIES_OPTIONS] 一致
const POT_DREAM_CHIPS = [0, 1200, 2700, 4100, 6600, 8600, 13300, 15300, 15700, 18100, 22000, 24000, 30000, 33000, 41000, 45000, 55000, 61000, 73000, 80000, 98000, 108000, 130000];
// endregion
