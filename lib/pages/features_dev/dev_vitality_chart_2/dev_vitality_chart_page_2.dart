import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/vitality_info/vitality_info_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/charts/vitality_chart/vitality_chart.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/images.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// 每一個 table spot step 代表 5 分鐘
const _spotStepValue = 5;

/// TODO: 增加放大縮小的按鈕，控制 table 寬度
class DevVitalityChartPage2 extends StatefulWidget {
  const DevVitalityChartPage2._();

  static const MyPageRoute route = ('/DevVitalityChartPage2', _builder);
  static Widget _builder(dynamic args) {
    return const DevVitalityChartPage2._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DevVitalityChartPage2> createState() => _DevVitalityChartPage2State();
}

class _DevVitalityChartPage2State extends State<DevVitalityChartPage2> {

  // Form
  late FormGroup _form;

  // Form fields
  /// (一睡) 開始睡覺時間
  late FormControl<TimeOfDay> _mainSleepTimeField;
  /// (一睡) 起床時間
  late FormControl<TimeOfDay> _mainGetUpTimeField;
  /// 要用睡覺分數來計算睡覺的起迄時間？
  // late FormControl<int> _sleepScoreField;
  /// 睡覺前的活力值 (TODO: 這邊變成可切換狀態，睡覺前活力，或上次起床時的活力
  late FormControl<int> _initVitalityField;

  // Table Data
  var _colors = <Color>[];
  var _stops = <double>[];
  var _tableDataList = <VitalityChartData>[];
  var _showingTooltipSpotIndexList = <int>[];
  var _sleepElapsed = const TimeOfDay(hour: 0, minute: 0);
  /// 一睡分數
  var _mainSleepScore = 0.0;
  /// 二睡分數，加上一睡分數不可超過 100
  var _subSleepScore = 0.0;

  @override
  void initState() {
    super.initState();
    _mainSleepTimeField = FormControl(
      value: _fixOffsetTimeOfDay(const TimeOfDay(hour: 21, minute: 0)),
      validators: [ Validators.required ],
    )..valueChanges.listen((event) {
      _prepareChartData();
      setState(() { });
    });
    _mainGetUpTimeField = FormControl(
      value: _fixOffsetTimeOfDay(const TimeOfDay(hour: 5, minute: 0)),
      validators: [ Validators.required ],
    )..valueChanges.listen((event) {
      _prepareChartData();
      setState(() { });
    });
    // _sleepScoreField = FormControl();
    _initVitalityField = FormControl(
      validators: [
        Validators.required,
        Validators.max(MAX_VITALITY),
        Validators.min(0),
      ],
    );

    _prepareChartData();
  }

  Future<TimeOfDay?> _pickTime({
    TimeOfDay? initialTime,
  }) async {
    final res = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    return _fixOffsetTimeOfDay(res);
  }

  TimeOfDay? _fixOffsetTimeOfDay(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    return TimeOfDay(
      hour: time.hour,
      minute: time.minute - time.minute % 5,
    );
  }

  TimeOfDay _calcTimeElapsed(TimeOfDay sleepTime, TimeOfDay getUpTime) {
    final sleepMinutes = sleepTime.toMinutes();
    final getUpMinutes = getUpTime.toMinutes();
    const minutesOfDay = 24 * 60;

    int sleepElapsed;
    if (sleepMinutes == getUpMinutes) {
      sleepElapsed = 0;
    } else if (sleepMinutes > getUpMinutes) {
      // 僅列小時: 22 ~ 6, 10,6
      sleepElapsed = minutesOfDay - sleepMinutes + getUpMinutes;
    } else {
      // 僅列小時: 6 ~ 10
      sleepElapsed = getUpMinutes - sleepMinutes;
    }

    if (sleepElapsed < 0) {
      sleepElapsed += minutesOfDay;
    }

    return TimeOfDay(hour: sleepElapsed ~/ 60, minute: sleepElapsed % 60);
  }

  TimeOfDay _toTimeFromMinutes(int minutes) {
    var newMinutes = minutes % (24 * 60);
    return TimeOfDay(hour: newMinutes ~/ 60, minute: newMinutes % 60);
  }

  TimeOfDay _calcTableDuration(TimeOfDay sleepTime, TimeOfDay getUpTime) {
    final sleepMinutes = sleepTime.toMinutes();
    final getUpMinutes = getUpTime.toMinutes();
    const minutesOfDay = 24 * 60;

    return _toTimeFromMinutes(minutesOfDay - getUpMinutes + sleepMinutes);
  }

  (int, Color) _getVitalityThreshold(num vitality) {
    return vitality >= 100 ? (100, moodColor80)
        : vitality >= 80 ? (80, moodColor80)
        : vitality >= 60 ? (60, moodColor60)
        : vitality >= 40 ? (40, moodColor40)
        : vitality >= 20 ? (20, moodColor20)
        : (0, moodColor0);
  }

  Color _getVitalityColor(num vitality) {
    return vitality >= 100 ? moodColor80
        : vitality >= 80 ? moodColor80
        : vitality >= 60 ? moodColor60
        : vitality >= 40 ? moodColor40
        : vitality >= 20 ? moodColor20
        : moodColor0;
  }

  void _showLegendInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('圖例'.xTr),
          content: DataTable(
            columns: [
              const DataColumn(label: Text('')),
              DataColumn(label: Text('活力範圍'.xTr)),
              DataColumn(label: Text('效率'.xTr)),
            ],
            rows: [
              ...<(int, int, int, double)>[
                (-1, 81, 80, 2.2),
                (80, 61, 60, 1.9),
                (60, 41, 40, 1.6),
                (40, 21, 20, 1.4),
                (20, 0, 0, 1),
              ].map((moodValues) {
                final rangeText = moodValues.$1 == -1
                    ? '${moodValues.$2} 以上\n(或睡覺時)'
                    : '${moodValues.$1} ~ ${moodValues.$2}';

                return DataRow(
                  cells: [
                    DataCell(
                        MyEnv.USE_DEBUG_IMAGE ? MoodImage(
                          value: moodValues.$3,
                          width: 16,
                        ) : Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getVitalityColor(moodValues.$3),
                          ),
                        )
                    ),
                    DataCell(
                      Text(
                        rangeText,
                      ),
                    ),
                    DataCell(
                      Text(
                        'x${moodValues.$4}',
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showInfoDialog() {
    DialogUtility.text(
      context,
      barrierDismissible: true,
      title: Text('說明'.xTr),
      content: Text('1. 此表假設每天作息一樣'.xTr),
    );
  }

  void _prepareChartData() {
    var foundZero = false;
    var sleeping = false;
    final initVitality = _initVitalityField.value?.toDouble();
    double lastVitalitySpotValue;
    final sleepTime = _mainSleepTimeField.value!;
    final getUpTime = _mainGetUpTimeField.value!;
    var lastTimeSpot = const TimeOfDay(hour: 0, minute: 0);
    var lastTimeSpotIndex = 0;

    if (initVitality == null) {
      sleeping = false;
      lastTimeSpot = getUpTime;
      lastVitalitySpotValue = 100.0;
    } else {
      sleeping = true;
      lastTimeSpot = sleepTime;
      lastVitalitySpotValue = initVitality;
    }

    final elapsedTime = _calcTimeElapsed(sleepTime, getUpTime);
    final mainSleepScore = ((elapsedTime.hour * 60.0 + elapsedTime.minute) / 510 * 100).clamp(0.0, 100.0);

    // final tableAxisDuration = _calcTableDuration(sleepTime, getUpTime);
    final tableAxisDuration = TimeOfDay(hour: 24, minute: 0);
    final tableCounts = (tableAxisDuration.hour * 60 + tableAxisDuration.minute) ~/ 5 + 1;
    final tableSpotsLastIndex = tableCounts - 1;
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
            lastVitalitySpotValue + (_calcTimeElapsed(lastTimeSpot, time).toMinutes() / 510 * 100)
        ).clamp(0, 100);
        lastTimeSpot = time;
        lastTimeSpotIndex = index;
        sleeping = false;
      }

      final vitality = sleeping ? (
        lastVitalitySpotValue + (_calcTimeElapsed(lastTimeSpot, time).toMinutes() / 510 * 100)
      ): (
          lastVitalitySpotValue - ((index - lastTimeSpotIndex) * _spotStepValue) / 10
      ).clamp(0.0, 100.0);
      final (vitalityThreshold, vitalityColor) = isSleepTooltipSpot || sleeping
          ? (100, moodColor80)
          : _getVitalityThreshold(vitality);
      final showBottomTitle = index % 30 == 0;

      var showTooltip = (vitality != 0 && vitality % 20.0 == 0) ||
          (vitality == 0 && !foundZero);
      if (vitality == 0) {
        foundZero = true;
      }
      showTooltip = showTooltip || index == 0;
      if (tmpVitalityThreshold != vitalityThreshold) {
        final stopValue = (index - 1).clamp(0, double.infinity) / (tableCounts - 1);
        if (tmpVitalityThreshold != null) {
          colors.add(_getVitalityColor(tmpVitalityThreshold!));
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

      if (index == tableSpotsLastIndex) {
        print(1234);
        print(1234);
      }

      return VitalityChartData(
          spot: FlSpot(index.toDouble(), vitality),
          time: timeText,
          isShowBottomTitle: showBottomTitle,
          isShowTooltip: showTooltip,
          tooltipText: isGetUpTooltipSpot ? '$timeText 起床'
              : isSleepTooltipSpot ? '$timeText 睡覺'
              : null
      );
    }

    final tableDataList = List.generate(tableCounts, (index) => getSpotValue(getUpTime, index));

    _showingTooltipSpotIndexList = showingTooltipSpotIndexList;
    _tableDataList = tableDataList;
    _stops = stops;
    _colors = colors;
    _sleepElapsed = elapsedTime;
    _mainSleepScore = mainSleepScore;
  }

  void _test() {
    testTime(int sleepHour, int sleepMinute, int getUpHour, int getUpMinute) {
      final sleepTime = TimeOfDay(hour: sleepHour, minute: sleepMinute);
      final getUpTime = TimeOfDay(hour: getUpHour, minute: getUpMinute);

      final elapsed = _calcTimeElapsed(sleepTime, getUpTime);
      const display = MyFormatter.time;
      debugPrint('${display(sleepTime)} 睡覺 , 經過 ${display(elapsed)} 後，起床 ${display(getUpTime)}');
    }

    for (var h1 = 0; h1 <= 24; h1++) {
      for (var h2 = 0; h2 <= 24; h2++) {
        testTime(h1, 0, h2, 0);
      }
    }
    debugPrint('====================');
  }

  void _testWithAssert() {
    testTime(_TestData data) {
      final sleepTime = data.sleepTime;
      final getUpTime = data.getUpTime;
      const minutesOfDay = 24 * 60;
      final elapsed = _calcTimeElapsed(sleepTime, getUpTime);
      final elapsedMinutes = elapsed.toMinutes();

      var result = false;
      var newGt = getUpTime.hour == 24 && getUpTime.minute == 0
          ? 0
          : getUpTime.toMinutes();
      var newSt = sleepTime.hour == 24 && sleepTime.minute == 0
          ? 0
          : sleepTime.toMinutes();

      if (newSt == newGt) {
        result = elapsedMinutes == 0 || elapsedMinutes == minutesOfDay;
      } else if (newSt > newGt) {
        result = (newSt + elapsedMinutes) % minutesOfDay == newGt;
      } else {
        // newSt < newGt
        var tv = newSt + elapsedMinutes;
        if (tv == minutesOfDay) {
          tv = 0;
        }
        result = tv == newGt;
      }

      const display = MyFormatter.time;

      final debugText = '${display(sleepTime)} 睡覺 , 經過 ${display(elapsed)} 後，起床 ${display(getUpTime)}';
      if (!result) {
        debugPrint('[計算錯誤] $debugText');
      }
    }

    for (var h1 = 0; h1 <= 24; h1++) {
      for (var m1 = 0; m1 < 2; m1++) {
        for (var h2 = 0; h2 <= 24; h2++) {
          testTime(_TestData(TimeOfDay(hour: h1, minute: (m1 * 20) % 60), TimeOfDay(hour: h2, minute: 0)));
        }
      }
    }
    debugPrint('====================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: '活力曲線 v2',
        actions: [
          IconButton(
            onPressed: () => _showInfoDialog(),
            tooltip: '說明'.xTr,
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () => _showLegendInfoDialog(),
            tooltip: '圖例'.xTr,
            icon: const Icon(Icons.legend_toggle),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text('活力曲線'.xTr),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Hp(
                  child: SizedBox(
                    height: 250,
                    child: VitalityChart(
                      colors: _colors,
                      stops: _stops,
                      spots: _tableDataList,
                      showingTooltipIndexOnSpots: _showingTooltipSpotIndexList,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: buildListView(
              children: [
                ...Hp.list(
                  children: [
                    MySubHeader(
                      titleText: '必要資訊'.xTr,
                    ),
                    // Text('初始活力、技能發動與次數'),
                    MySubHeader2(titleText: '主要睡眠'.xTr,),
                    Gap.sm,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ReactiveMyTextField(
                            label: '睡覺時間'.xTr,
                            formControl: _mainSleepTimeField,
                            wrapFieldBuilder: (context, field) {
                              return InkWell(
                                onTap: () async {
                                  final newTime = await _pickTime(initialTime: _mainSleepTimeField.value);
                                  if (newTime != null) {
                                    _mainSleepTimeField.value = newTime;
                                  }
                                },
                                child: IgnorePointer(
                                  child: field,
                                ),
                              );
                            },
                          ),
                        ),
                        Gap.md,
                        Expanded(
                          child: ReactiveMyTextField(
                            label: '起床時間'.xTr,
                            formControl: _mainGetUpTimeField,
                            wrapFieldBuilder: (context, field) {
                              return InkWell(
                                onTap: () async {
                                  final newTime = await _pickTime(initialTime: _mainGetUpTimeField.value);
                                  if (newTime != null) {
                                    _mainGetUpTimeField.value = newTime;
                                  }
                                },
                                child: IgnorePointer(
                                  child: field,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Gap.sm,
                    Text(
                      '睡覺時間: ${MyFormatter.time(_sleepElapsed)} (睡眠分數: ${Display.numInt(_mainSleepScore)})',
                      style: TextStyle(color: greyColor3),
                    ),
                    MySubHeader(titleText: '額外資訊'.xTr,),
                    ReactiveMyTextField(
                      label: '初始活力'.xTr,
                      formControl: _initVitalityField,
                    ),
                    if (kDebugMode) ...[
                      const MySubHeader(titleText: '測試區'),
                      MyElevatedButton(
                        onPressed: () => _test(),
                        child: const Text('測試睡覺時間'),
                      ),
                      MyElevatedButton(
                        onPressed: () => _testWithAssert(),
                        child: const Text('驗算睡覺時間 (with assert)'),
                      ),
                    ],
                    MySubHeader(
                      titleText: 't_advanced'.xTr,
                      color: advancedColor,
                    ),
                  ],
                ),
                ...ListTile.divideTiles(
                  context: context,
                  tiles: [
                    ListTile(
                      onTap: () {
                        VitalityInfoPage.go(context);
                      },
                      title: Text('活力資訊'.xTr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TestData {
  _TestData(
      this.sleepTime,
      this.getUpTime,
  );

  final TimeOfDay sleepTime;
  final TimeOfDay getUpTime;
}

/*

# 攻略站做法

設定: (分別是起迄時間)

- 21 ~ 4/5/6.../20/21 => 結果為 4/5/6...20/21 點起床，21點睡覺

 */
