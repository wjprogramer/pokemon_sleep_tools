import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

// ignore_for_file: constant_identifier_names

/// 每個隊伍容納最多的寶可夢數量
const MAX_TEAM_POKEMON_COUNT = 5;

/// 最多可以儲存多少隊伍數量
const MAX_TEAM_COUNT = 10;

/// 照理來說不會變啦，各世代好像都是 100 為上限
/// 如果真的變了，[ExpSleepUtility] 需要特別注意
const MAX_POKEMON_LEVEL = 100;

/// 食譜等級
const MAX_RECIPE_LEVEL = 50;

/// 鍋子容量
const POT_CAPACITIES_OPTIONS = [15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81];
