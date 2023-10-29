part of '../dev_vitality_chart_page_2.dart';

const _chartDuration = TimeOfDay(hour: 24, minute: 0);

/// 每一個 table spot step 代表 5 分鐘
const _spotStepValue = 5;

class _VitalityHelper {
  _VitalityHelper();

  _VitalityChartResult prepareData({
    required TimeOfDay mainSleepTime,
    required TimeOfDay mainGetUpTime,
    required TimeOfDay? extraSleepTime,
    required TimeOfDay? extraGetUpTime,
    required double? initVitality,
    required bool isInitVitalityWhenGetUp,
  }) {
    // # declare / fixed data
    final sleepElapsed = calcTimeElapsed(mainSleepTime, mainGetUpTime);
    final mainSleepScore = ((sleepElapsed.hour * 60.0 + sleepElapsed.minute) / 510 * 100).clamp(0.0, 100.0).ceil().toInt();
    final extraMaxSleepScore = (100 - mainSleepScore).toInt();

    // # declare / logic data
    var sleeping = isInitVitalityWhenGetUp;
    int? lastTooltipIndex;

    var preVitality = 0.0;
    var tableInitTime = isInitVitalityWhenGetUp ? mainGetUpTime : mainSleepTime;
    int? preVitalityThreshold;

    // # declare / logic data / key point
    var lastKeyPointTime = tableInitTime;
    var lastKeyPointIndex = 0;
    var lastKeyPointVitality = initVitality ?? (isInitVitalityWhenGetUp ? 100.0 : 0.0);

    // # declare / ui data
    final stops = <double>[];
    final colors = <Color>[];

    final counts = (_chartDuration.hour * 60 + _chartDuration.minute) ~/ 5 + 1;
    final showingTooltipIndices = <int>[];
    final showingKeyTooltipIndices = <int>[];

    VitalityChartData buildChartData(TimeOfDay initTime, int index) {
      final time = initTime.add(minute: index * _spotStepValue);

      // Utils
      double calcVitality(bool isSleeping, bool isKeyPoint) {
        double res;
        if (sleeping) {
          res = lastKeyPointVitality + (calcTimeElapsed(lastKeyPointTime, time).toMinutes() / 510 * 100);
        } else {
          final x = isKeyPoint ? lastKeyPointIndex + 1 : lastKeyPointIndex + 1;
          res = lastKeyPointVitality - ((index - x) * _spotStepValue) / 10;
        }
        return res.clamp(0, 100.0);
      }

      // [TimePoint] Time to start sleeping
      final isSleepTimePoint = time == mainSleepTime || time == extraSleepTime;
      if (isSleepTimePoint) {
        if (index > 0) {
          lastKeyPointVitality = calcVitality(false, true);
        }
        sleeping = true;
      }

      // [TimePoint] Time to wake up
      final isGetUpTimePoint = time == mainGetUpTime || time == extraGetUpTime;
      if (isGetUpTimePoint) {
        lastKeyPointVitality = calcVitality(true, true);
        sleeping = false;
      }

      // [TimePoint] Time to start sleeping or wake up
      final isKeyPoint = isSleepTimePoint || isGetUpTimePoint || time == extraGetUpTime || time == extraSleepTime;
      if (isKeyPoint) {
        lastKeyPointTime = time;
        lastKeyPointIndex = index;
      }

      // Calculate
      final vitality = calcVitality(sleeping, false);
      final (vitalityThreshold, vitalityColor) = isSleepTimePoint || sleeping
          ? (100, moodColor80)
          : MoodIcon.getVitalityThresholdAndColor(vitality);

      // Build chart data / Threshold stops & colors
      if (preVitalityThreshold != null && preVitalityThreshold != vitalityThreshold) {
        final stopValue = (index - 0).clamp(0, double.infinity) / (counts - 1);
        if (preVitalityThreshold != null) {
          colors.add(MoodIcon.getColorBy(preVitalityThreshold!));
          stops.add(stopValue);
        }
        colors.add(vitalityColor);
        stops.add(stopValue);
      }

      // Build chart data / tooltip
      final showTooltip = index == 0  ||
          isGetUpTimePoint ||
          isSleepTimePoint ||
          (preVitalityThreshold != vitalityThreshold);
      if (showTooltip) {
        showingTooltipIndices.add(index);
        lastTooltipIndex = index;
      }

      // Assign pre values
      preVitality = vitality;
      preVitalityThreshold = vitalityThreshold;

      // Result
      final timeText = MyFormatter.time(time);
      return VitalityChartData(
        spot: FlSpot(index.toDouble(), vitality),
        time: timeText,
        isShowBottomTitle: index % 30 == 0,
        isShowTooltip: showTooltip,
        tooltipText: isGetUpTimePoint ? '$timeText\n起床\n${vitality.toInt()}'
            : isSleepTimePoint ? '$timeText\n睡覺\n${vitality.toInt()}'
            : '$timeText\n${vitality.toInt()}',
      );
    }
    
    // Showing tooltip indices
    // final tooltipIsKeypointOf = showingTooltipIndices.toMap((i) => i, (_) => false);
    // for (final keyIndex in showingKeyTooltipIndices) {
    //   tooltipIsKeypointOf[keyIndex] = true;
    // }
    // final tooltipIndices = tooltipIsKeypointOf.entries.map((e) => (e.key, e.value)).sorted((a, b) {
    //   return a.$1 - b.$1;
    // });
    // final resultTooltipIndices = <int>[];
    // for (var i = 0; i < tooltipIndices.length; i++) {
    //
    // }

    // final newSet = <int>{}
    //   ..addAll(showingKeyTooltipIndices)
    //   ..addAll(showingTooltipIndices);

    print('${showingKeyTooltipIndices.length}, ${showingTooltipIndices.length}');

    return _VitalityChartResult(
      showingTooltipSpotIndexList: showingTooltipIndices,
      tableDataList: List.generate(counts, (index) => buildChartData(
        tableInitTime, index,
      )),
      stops: stops,
      colors: colors,
      sleepElapsed: sleepElapsed,
      mainSleepScore: mainSleepScore,
    );
  }

  TimeOfDay calcTimeElapsed(TimeOfDay sleepTime, TimeOfDay getUpTime) {
    final sleepMinutes = sleepTime.toMinutes();
    final getUpMinutes = getUpTime.toMinutes();
    const minutesOfDay = 24 * 60;

    int sleepElapsedMinutes;
    if (sleepMinutes == getUpMinutes) {
      sleepElapsedMinutes = 0;
    } else if (sleepMinutes > getUpMinutes) {
      // 僅列小時: 22 ~ 6, 10,6
      sleepElapsedMinutes = minutesOfDay - sleepMinutes + getUpMinutes;
    } else {
      // 僅列小時: 6 ~ 10
      sleepElapsedMinutes = getUpMinutes - sleepMinutes;
    }

    if (sleepElapsedMinutes < 0) {
      sleepElapsedMinutes += minutesOfDay;
    }

    return TimeOfDay(hour: sleepElapsedMinutes ~/ 60, minute: sleepElapsedMinutes % 60);
  }

}

class _VitalityChartResult {
  _VitalityChartResult({
    required this.showingTooltipSpotIndexList,
    required this.tableDataList,
    required this.stops,
    required this.colors,
    required this.sleepElapsed,
    required this.mainSleepScore,
  });

  List<int> showingTooltipSpotIndexList;
  List<VitalityChartData> tableDataList;
  List<double> stops;
  List<Color> colors;
  TimeOfDay sleepElapsed;
  int mainSleepScore;
}
