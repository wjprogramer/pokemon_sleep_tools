/// 睡眠類型
enum SleepType {
  st0(0, '深深入眠'),
  st1(1, '安然入睡'),
  st4(4, '淺淺入夢'),
  st99(99, '沒有特徵');

  const SleepType(this.id, this.nameI18nKey);

  final int id;
  final String nameI18nKey;
}

