class ExpSleepUtility {
  ExpSleepUtility._();

  /// 回傳 [level] - 1 升級到 [level] 所需的經驗
  ///
  /// [isLarvitarAndParent] 為 true
  /// 使用「班基拉斯、沙基拉斯、又基拉斯」計算公式（其經驗所需較多）
  /// (Larvitar, Pupitar, Tyranitar)
  static int getNeedExp(int level, {
    bool isLarvitarAndParent = false,
  }) {
    assert(level >= 1 && level <= 100);
    final needExpOf = (
        isLarvitarAndParent ? _larvitarNeedExp : _needExp
    );
    return needExpOf[level] ?? 0;
  }

  /// 回傳從等級 1 升級到 [level] 所需的經驗
  static int getAccumulateExp(int level, {
    bool isLarvitarAndParent = false,
  }) {
    assert(level >= 1 && level <= 100);
    final accumulateExpOf = (
        isLarvitarAndParent ? _larvitarAccumulateExp : _accumulateExp
    );
    return accumulateExpOf[level] ?? 0;
  }

}

const _needExp = <int, int>{
  1: 0,
  2: 0, // 好像保底就是從 Lv 2 開始？
  3: 71, // 代表 2 升級到 3 所需經驗為 71
  4: 108,
  5: 128,
  6: 164,
  7: 202,
  8: 244,
  9: 274,
  10: 315,
  11: 345,
  12: 376,
  13: 407,
  14: 419,
  15: 429,
  16: 440,
  17: 454,
  18: 469,
  19: 483,
  20: 497,
  21: 515,
  22: 537,
  23: 558,
  24: 579,
  25: 600,
  26: 622,
  27: 643,
  28: 665,
  29: 686,
  30: 708,
  31: 729,
  32: 748,
  33: 766,
  34: 785,
  35: 803,
  36: 821,
  37: 839,
  38: 857,
  39: 875,
  40: 893,
  41: 910,
  42: 928,
  43: 945,
  44: 963,
  45: 980,
  46: 997,
  47: 1015,
  48: 1032,
  49: 1049,
  50: 1066,
  51: 1084,
  52: 1102,
  53: 1120,
  54: 1138,
  55: 1156,
  56: 1174,
  57: 1192,
  58: 1210,
  59: 1228,
  60: 1246,
  61: 1264,
  62: 1282,
  63: 1300,
  64: 1318,
  65: 1336,
  66: 1354,
  67: 1372,
  68: 1390,
  69: 1408,
  70: 1426,
  71: 1444,
  72: 1462,
  73: 1480,
  74: 1498,
  75: 1516,
  76: 1534,
  77: 1552,
  78: 1570,
  79: 1588,
  80: 1606,
  81: 1624,
  82: 1642,
  83: 1660,
  84: 1678,
  85: 1696,
  86: 1714,
  87: 1732,
  88: 1750,
  89: 1768,
  90: 1786,
  91: 1804,
  92: 1822,
  93: 1840,
  94: 1858,
  95: 1876,
  96: 1894,
  97: 1912,
  98: 1930,
  99: 1948,
  100: 1966,
};

/// 累積經驗
const _accumulateExp = {
  1: 0,
  2: 0,
  3: 71, // 從 1 升級到 3 所需經驗
  4: 179, // 從 1 升級到 4 所需經驗
  5: 307,
  6: 471,
  7: 673,
  8: 917,
  9: 1191,
  10: 1506,
  11: 1851,
  12: 2227,
  13: 2634,
  14: 3053,
  15: 3482,
  16: 3922,
  17: 4376,
  18: 4845,
  19: 5328,
  20: 5825,
  21: 6340,
  22: 6877,
  23: 7435,
  24: 8014,
  25: 8614,
  26: 9236,
  27: 9879,
  28: 10544,
  29: 11230,
  30: 11938,
  31: 12667,
  32: 13415,
  33: 14181,
  34: 14966,
  35: 15769,
  36: 16590,
  37: 17429,
  38: 18286,
  39: 19161,
  40: 20054,
  41: 20964,
  42: 21892,
  43: 22837,
  44: 23800,
  45: 24780,
  46: 25777,
  47: 26792,
  48: 27824,
  49: 28873,
  50: 29939,
  51: 31023,
  52: 32125,
  53: 33245,
  54: 34383,
  55: 35539,
  56: 36713,
  57: 37905,
  58: 39115,
  59: 40343,
  60: 41589,
  61: 42853,
  62: 44135,
  63: 45435,
  64: 46753,
  65: 48089,
  66: 49443,
  67: 50815,
  68: 52205,
  69: 53613,
  70: 55039,
  71: 56483,
  72: 57945,
  73: 59425,
  74: 60923,
  75: 62439,
  76: 63973,
  77: 65525,
  78: 67095,
  79: 68683,
  80: 70289,
  81: 71913,
  82: 73555,
  83: 75215,
  84: 76893,
  85: 78589,
  86: 80303,
  87: 82035,
  88: 83785,
  89: 85553,
  90: 87339,
  91: 89143,
  92: 90965,
  93: 92805,
  94: 94663,
  95: 96539,
  96: 98433,
  97: 100345,
  98: 102275,
  99: 104223,
  100: 106189,
};

/// 幼基拉斯、沙基拉斯、班基拉斯所需經驗會比較高
const _larvitarNeedExp = {
  1: 0,
  2: 0,
  3: 107,
  4: 162,
  5: 192,
  6: 246,
  7: 303,
  8: 366,
  9: 411,
  10: 472,
  11: 518,
  12: 564,
  13: 610,
  14: 629,
  15: 643,
  16: 660,
  17: 681,
  18: 704,
  19: 724,
  20: 746,
  21: 772,
  22: 806,
  23: 837,
  24: 868,
  25: 900,
  26: 933,
  27: 965,
  28: 997,
  29: 1029,
  30: 1062,
  31: 1094,
  32: 1122,
  33: 1149,
  34: 1177,
  35: 1205,
  36: 1231,
  37: 1259,
  38: 1285,
  39: 1313,
  40: 1339,
  41: 1365,
  42: 1392,
  43: 1418,
  44: 1444,
  45: 1470,
  46: 1496,
  47: 1522,
  48: 1548,
  49: 1574,
  50: 1599,
  51: 1626,
  52: 1653,
  53: 1680,
  54: 1707,
  55: 1734,
  56: 1761,
  57: 1788,
  58: 1815,
  59: 1842,
  60: 1869,
  61: 1896,
  62: 1923,
  63: 1950,
  64: 1977,
  65: 2004,
  66: 2031,
  67: 2058,
  68: 2085,
  69: 2112,
  70: 2139,
  71: 2166,
  72: 2193,
  73: 2220,
  74: 2247,
  75: 2274,
  76: 2301,
  77: 2328,
  78: 2355,
  79: 2382,
  80: 2409,
  81: 2436,
  82: 2463,
  83: 2490,
  84: 2517,
  85: 2544,
  86: 2571,
  87: 2598,
  88: 2625,
  89: 2652,
  90: 2679,
  91: 2706,
  92: 2733,
  93: 2760,
  94: 2787,
  95: 2814,
  96: 2841,
  97: 2868,
  98: 2895,
  99: 2922,
  100: 2949,
};

/// 幼基拉斯、沙基拉斯、班基拉斯所需經驗會比較高
const _larvitarAccumulateExp = {
  1: 0,
  2: 0,
  3: 107,
  4: 269,
  5: 461,
  6: 707,
  7: 1010,
  8: 1376,
  9: 1787,
  10: 2259,
  11: 2777,
  12: 3341,
  13: 3951,
  14: 4580,
  15: 5223,
  16: 5883,
  17: 6564,
  18: 7268,
  19: 7992,
  20: 8738,
  21: 9510,
  22: 10316,
  23: 11153,
  24: 12021,
  25: 12921,
  26: 13854,
  27: 14819,
  28: 15816,
  29: 16845,
  30: 17907,
  31: 19001,
  32: 20123,
  33: 21272,
  34: 22449,
  35: 23654,
  36: 24885,
  37: 26144,
  38: 27429,
  39: 28742,
  40: 30081,
  41: 31446,
  42: 32838,
  43: 34256,
  44: 35700,
  45: 37170,
  46: 38666,
  47: 40188,
  48: 41736,
  49: 43310,
  50: 44909,
  51: 46535,
  52: 48188,
  53: 49868,
  54: 51575,
  55: 53309,
  56: 55070,
  57: 56858,
  58: 58673,
  59: 60515,
  60: 62384,
  61: 64280,
  62: 66203,
  63: 68153,
  64: 70130,
  65: 72134,
  66: 74165,
  67: 76223,
  68: 78308,
  69: 80420,
  70: 82559,
  71: 84725,
  72: 86918,
  73: 89138,
  74: 91385,
  75: 93659,
  76: 95960,
  77: 98288,
  78: 100643,
  79: 103025,
  80: 105434,
  81: 107870,
  82: 110333,
  83: 112823,
  84: 115340,
  85: 117884,
  86: 120455,
  87: 123053,
  88: 125678,
  89: 128330,
  90: 131009,
  91: 133715,
  92: 136448,
  93: 139208,
  94: 141995,
  95: 144809,
  96: 147650,
  97: 150518,
  98: 153413,
  99: 156335,
  100: 159284,
};

