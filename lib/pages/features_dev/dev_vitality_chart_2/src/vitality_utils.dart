part of '../dev_vitality_chart_page_2.dart';

class _VitalityHelper {
  _VitalityHelper();

  _VitalityChartResult prepareData({
    required TimeOfDay mainSleepTime,
    required TimeOfDay mainGetUpTime,
    required double? initVitality,
    required bool isInitVitalityWhenGetUp,
  }) {
    var foundZero = false;
    var sleeping = false;
    double lastVitalitySpotValue;
    final sleepTime = mainSleepTime;
    final getUpTime = mainGetUpTime;
    var lastTimeSpot = const TimeOfDay(hour: 0, minute: 0);
    var lastTimeSpotIndex = 0;
    TimeOfDay tableInitTime;
    var preVitality = 0.0;

    if (isInitVitalityWhenGetUp) {
      sleeping = false;
      lastTimeSpot = getUpTime;
      lastVitalitySpotValue = initVitality ?? 100.0;
      tableInitTime = getUpTime;
    } else {
      sleeping = true;
      lastTimeSpot = sleepTime;
      lastVitalitySpotValue = initVitality ?? 100.0;
      tableInitTime = sleepTime;
    }

    final elapsedTime = calcTimeElapsed(sleepTime, getUpTime);
    final mainSleepScore = ((elapsedTime.hour * 60.0 + elapsedTime.minute) / 510 * 100).clamp(0.0, 100.0);

    const tableAxisDuration = TimeOfDay(hour: 24, minute: 0);
    final tableCounts = (tableAxisDuration.hour * 60 + tableAxisDuration.minute) ~/ 5 + 1;
    final showingTooltipSpotIndexList = <int>[];

    final stops = <double>[];
    final colors = <Color>[];

    int? tmpVitalityThreshold;

    VitalityChartData getSpotValue(TimeOfDay initTime, int index) {
      final time = initTime.add(minute: index * _spotStepValue);

      // 開始睡覺
      final isSleepTooltipSpot = time == sleepTime;
      if (isSleepTooltipSpot) {
        sleeping = true;
        lastTimeSpot = time;
        lastTimeSpotIndex = index;
        if (index != 0) {
          lastVitalitySpotValue = (
              lastVitalitySpotValue - ((index - 1) * _spotStepValue) / 10
          ).clamp(0.0, 100.0);
        }
      }

      // 起床
      final isGetUpTooltipSpot = time == getUpTime;
      if (isGetUpTooltipSpot) {
        lastVitalitySpotValue = (
            lastVitalitySpotValue + (calcTimeElapsed(lastTimeSpot, time).toMinutes() / 510 * 100)
        ).clamp(0, 100);
        lastTimeSpot = time;
        lastTimeSpotIndex = index;
        sleeping = false;
      }

      final vitality = sleeping ? (
          lastVitalitySpotValue + (calcTimeElapsed(lastTimeSpot, time).toMinutes() / 510 * 100)
      ).clamp(0.0, 100.0) : (
          lastVitalitySpotValue - ((index - lastTimeSpotIndex) * _spotStepValue) / 10
      ).clamp(0.0, 100.0);
      final (vitalityThreshold, vitalityColor) = isSleepTooltipSpot || sleeping
          ? (100, moodColor80)
          : MoodIcon.getVitalityThresholdAndColor(vitality);
      final showBottomTitle = index % 30 == 0;


      var showTooltip = (vitality != 0 && vitality % 20.0 == 0 && preVitality != vitality) ||
          (vitality == 0 && !foundZero);
      preVitality = vitality;
      if (vitality == 0) {
        foundZero = true;
      }
      showTooltip = showTooltip || index == 0;
      if (tmpVitalityThreshold != vitalityThreshold) {
        final stopValue = (index - 1).clamp(0, double.infinity) / (tableCounts - 1);
        if (tmpVitalityThreshold != null) {
          colors.add(MoodIcon.getColorBy(tmpVitalityThreshold!));
          stops.add(stopValue);
        }
        colors.add(vitalityColor);
        stops.add(stopValue);
      }
      tmpVitalityThreshold = vitalityThreshold;
      final timeText = MyFormatter.time(time);

      showTooltip = showTooltip || isGetUpTooltipSpot || isSleepTooltipSpot;
      if (showTooltip) {
        showingTooltipSpotIndexList.add(index);
      }

      return VitalityChartData(
        spot: FlSpot(index.toDouble(), vitality),
        time: timeText,
        isShowBottomTitle: showBottomTitle,
        isShowTooltip: showTooltip,
        tooltipText: isGetUpTooltipSpot ? '$timeText 起床\n${vitality.toInt()}'
            : isSleepTooltipSpot ? '$timeText 睡覺\n${vitality.toInt()}'
            : null,
      );
    }

    final tableDataList = List.generate(tableCounts, (index) => getSpotValue(
      tableInitTime, index,
    ));

    return _VitalityChartResult(
      showingTooltipSpotIndexList: showingTooltipSpotIndexList,
      tableDataList: tableDataList,
      stops: stops,
      colors: colors,
      sleepElapsed: elapsedTime,
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
  double mainSleepScore;

}
