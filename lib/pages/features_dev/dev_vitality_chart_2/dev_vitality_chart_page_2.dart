import 'dart:async';

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

part 'src/vitality_utils.dart';

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

  // Form helper
  final _vitalityHelper = _VitalityHelper();

  // Form
  late FormGroup _form;

  // Form fields
  /// (一睡) 開始睡覺時間
  late FormControl<TimeOfDay> _mainSleepTimeField;
  /// (一睡) 起床時間
  late FormControl<TimeOfDay> _mainGetUpTimeField;
  /// (二睡) 開始睡覺時間
  late FormControl<TimeOfDay> _extraSleepTimeField;
  /// (二睡) 起床時間
  late FormControl<TimeOfDay> _extraGetUpTimeField;
  /// 要用睡覺分數來計算睡覺的起迄時間？
  // late FormControl<int> _sleepScoreField;
  /// 睡覺前的活力值
  late FormControl<int> _initVitalityField;
  Timer? _initVitalityDebounce;

  // Form other options
  var _isInitVitalityWhenGetUp = true;

  // Table Data
  var _colors = <Color>[];
  var _stops = <double>[];
  var _tableDataList = <VitalityChartData>[];
  var _showingTooltipSpotIndexList = <int>[];
  var _sleepElapsed = const TimeOfDay(hour: 0, minute: 0);
  /// 一睡分數
  var _mainSleepScore = 0.0;
  /// 二睡分數，加上一睡分數不可超過 100
  var _extraSleepScore = 0.0;

  @override
  void initState() {
    super.initState();
    _mainSleepTimeField = FormControl(
      value: _fixOffsetTimeOfDay(const TimeOfDay(hour: 21, minute: 0)),
      validators: [ Validators.required ],
    )..valueChanges.listen((event) {
      prepareData();
      setState(() { });
    });
    _mainGetUpTimeField = FormControl(
      value: _fixOffsetTimeOfDay(const TimeOfDay(hour: 5, minute: 0)),
      validators: [ Validators.required ],
    )..valueChanges.listen((event) {
      prepareData();
      setState(() { });
    });
    _extraSleepTimeField = FormControl(
      validators: [],
    )..valueChanges.listen((event) {
      prepareData();
      setState(() { });
    });
    _extraGetUpTimeField = FormControl(
      validators: [],
    )..valueChanges.listen((event) {
      prepareData();
      setState(() { });
    });
    // _sleepScoreField = FormControl();
    _initVitalityField = FormControl(
      validators: [
        Validators.max(MAX_VITALITY),
        Validators.min(0),
      ],
    )..valueChanges.listen((event) {
      if (_initVitalityDebounce?.isActive ?? false) {
        _initVitalityDebounce?.cancel();
      }
      _initVitalityDebounce = Timer(const Duration(milliseconds: 200), () {
        prepareData();
        setState(() { });
      });
    });

    prepareData();
  }

  void prepareData() {
    final res = _vitalityHelper.prepareData(
      mainSleepTime: _mainSleepTimeField.value!,
      mainGetUpTime: _mainGetUpTimeField.value!,
      initVitality: _initVitalityField.value?.clamp(0.0, MAX_VITALITY).toDouble(),
      isInitVitalityWhenGetUp: _isInitVitalityWhenGetUp,
    );

    _showingTooltipSpotIndexList = res.showingTooltipSpotIndexList;
    _tableDataList = res.tableDataList;
    _stops = res.stops;
    _colors = res.colors;
    _sleepElapsed = res.sleepElapsed;
    _mainSleepScore = res.mainSleepScore;
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

  // TimeOfDay _toTimeFromMinutes(int minutes) {
  //   var newMinutes = minutes % (24 * 60);
  //   return TimeOfDay(hour: newMinutes ~/ 60, minute: newMinutes % 60);
  // }

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
                        MyEnv.USE_DEBUG_IMAGE ? MoodIcon(
                          value: moodValues.$3,
                          width: 16,
                        ) : Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MoodIcon.getColorBy(moodValues.$3),
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

  void _test() {
    testTime(int sleepHour, int sleepMinute, int getUpHour, int getUpMinute) {
      final sleepTime = TimeOfDay(hour: sleepHour, minute: sleepMinute);
      final getUpTime = TimeOfDay(hour: getUpHour, minute: getUpMinute);

      final elapsed = _vitalityHelper.calcTimeElapsed(sleepTime, getUpTime);
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
      final elapsed = _vitalityHelper.calcTimeElapsed(sleepTime, getUpTime);
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
                    MySubHeader2(
                      titleText: '初始活力'.xTr,
                    ),
                    Gap.sm,
                    Row(
                      children: [
                        Expanded(
                          child: MyElevatedButton(
                            onPressed: () {
                              if (_isInitVitalityWhenGetUp) {
                                return;
                              }
                              _isInitVitalityWhenGetUp = true;
                              prepareData();
                              setState(() { });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedOpacity(
                                  opacity: _isInitVitalityWhenGetUp ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(Icons.check),
                                ),
                                Gap.md,
                                Text('起床時'.xTr),
                              ],
                            ),
                          ),
                        ),
                        Gap.md,
                        Expanded(
                          child: MyElevatedButton(
                            onPressed: () {
                              if (!_isInitVitalityWhenGetUp) {
                                return;
                              }
                              _isInitVitalityWhenGetUp = false;
                              prepareData();
                              setState(() { });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedOpacity(
                                  opacity: !_isInitVitalityWhenGetUp ? 1 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: const Icon(Icons.check),
                                ),
                                Gap.md,
                                Text('睡覺前'.xTr),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap.sm,
                    ReactiveMyTextField(
                      formControl: _initVitalityField,
                    ),
                    MySubHeader2(
                      titleText: '額外睡眠'.xTr,
                    ),
                    Gap.sm,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ReactiveMyTextField(
                            label: '睡覺時間'.xTr,
                            formControl: _extraSleepTimeField,
                            wrapFieldBuilder: (context, field) {
                              return InkWell(
                                onTap: () async {
                                  final newTime = await _pickTime(initialTime: _extraSleepTimeField.value);
                                  if (newTime != null) {
                                    _extraSleepTimeField.value = newTime;
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
                            formControl: _extraGetUpTimeField,
                            wrapFieldBuilder: (context, field) {
                              return InkWell(
                                onTap: () async {
                                  final newTime = await _pickTime(initialTime: _extraGetUpTimeField.value);
                                  if (newTime != null) {
                                    _extraGetUpTimeField.value = newTime;
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
                ...Hp.list(
                  children: [
                    // MySubHeader(),
                  ],
                ),
                Gap.trailing,
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
