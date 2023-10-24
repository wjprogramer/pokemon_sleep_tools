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
  /// 開始睡覺時間
  late FormControl<TimeOfDay> _sleepTimeField;
  /// 起床時間
  late FormControl<TimeOfDay> _getUpTimeField;
  /// 要用睡覺分數來計算睡覺的起迄時間？
  // late FormControl<int> _sleepScoreField;
  /// 睡覺前的活力值
  late FormControl<int> _initVitalityField;

  // Table Data (By form fields)

  @override
  void initState() {
    super.initState();
    _sleepTimeField = FormControl(
      value: _fixOffsetTimeOfDay(const TimeOfDay(hour: 21, minute: 0)),
      validators: [ Validators.required ],
    )..valueChanges.listen((event) {
      setState(() { });
    });
    _getUpTimeField = FormControl(
      value: _fixOffsetTimeOfDay(const TimeOfDay(hour: 5, minute: 0)),
      validators: [ Validators.required ],
    )..valueChanges.listen((event) {
      setState(() { });
    });
    // _sleepScoreField = FormControl();
    _initVitalityField = FormControl(
      validators: [
        Validators.required,
        Validators.max(300),
        Validators.min(0),
      ],
    );
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
    final sleepMinutes = sleepTime.hour * 60 + sleepTime.minute;
    final getUpMinutes = getUpTime.hour * 60 + getUpTime.minute;
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

  @override
  Widget build(BuildContext context) {
    var foundZero = false;

    final sleepTime = _sleepTimeField.value!;
    final getUpTime = _getUpTimeField.value!;
    final elapsedTime = _calcTimeElapsed(sleepTime, getUpTime);
    final sleepScore = ((elapsedTime.hour * 60.0 + elapsedTime.minute) / 510 * 100).clamp(0.0, 100.0);
    final tableAxisDuration = _calcTableDuration(sleepTime, getUpTime);
    final tableCounts = (tableAxisDuration.hour * 60 + tableAxisDuration.minute) ~/ 5 + 1;
    final tableSpotsLastIndex = tableCounts - 1;
    final showingTooltipIndexOnSpots = <int>[];

    final stops = <double>[];
    final colors = <Color>[];

    int? tmpVitalityThreshold;

    VitalityChartData getSpotValue(TimeOfDay initTime, int index) {
      final time = initTime.add(minute: index * _spotStepValue);

      final vitality = (
          100.0 - (index * _spotStepValue) / 10
      ).clamp(0.0, 100.0);
      final (vitalityThreshold, vitalityColor) = _getVitalityThreshold(vitality);
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

      showTooltip = showTooltip || tableSpotsLastIndex == index;
      if (showTooltip) {
        showingTooltipIndexOnSpots.add(index);
      }

      return VitalityChartData(
        spot: FlSpot(index.toDouble(), vitality),
        time: timeText,
        isShowBottomTitle: showBottomTitle,
        isShowTooltip: showTooltip,
        tooltipText: index == 0 ? '$timeText 起床'
            : index == tableSpotsLastIndex ? '$timeText 睡覺'
            : null
      );
    }

    final tableDataList = List.generate(tableCounts, (index) => getSpotValue(getUpTime, index));

    return Scaffold(
      appBar: buildAppBar(
        titleText: '活力曲線 v2',
        // VitalityInfoPage
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('圖例'.xTr),
                    content: DataTable(
                      columns: [
                        DataColumn(label: Text('')),
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
                              ? '${moodValues.$2} 以上'
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
            },
            icon: Icon(Icons.info_outline),
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
                      colors: colors,
                      stops: stops,
                      spots: tableDataList,
                      showingTooltipIndexOnSpots: showingTooltipIndexOnSpots,
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
                            formControl: _sleepTimeField,
                            wrapFieldBuilder: (context, field) {
                              return InkWell(
                                onTap: () async {
                                  final newTime = await _pickTime(initialTime: _sleepTimeField.value);
                                  if (newTime != null) {
                                    _sleepTimeField.value = newTime;
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
                            formControl: _getUpTimeField,
                            wrapFieldBuilder: (context, field) {
                              return InkWell(
                                onTap: () async {
                                  final newTime = await _pickTime(initialTime: _getUpTimeField.value);
                                  if (newTime != null) {
                                    _getUpTimeField.value = newTime;
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
                      '睡覺時間: ${MyFormatter.time(elapsedTime)} (睡眠分數: ${Display.numInt(sleepScore)})',
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
                        onPressed: () {
                          testTime(int sleepHour, int sleepMinute, int getUpHour, int getUpMinute) {
                            final sleepTime = TimeOfDay(hour: sleepHour, minute: sleepMinute);
                            final getUpTime = TimeOfDay(hour: getUpHour, minute: getUpMinute);

                            final elapsed = _calcTimeElapsed(sleepTime, getUpTime);
                            const display = MyFormatter.time;
                            debugPrint('${display(sleepTime)} 睡覺 , 經過 ${display(elapsed)} 後，起床 ${display(getUpTime)}');
                          }
                          // _calcTimeElapsed(
                          //   _sleepTimeField.value!,
                          //   _getUpTimeField.value!,
                          // );
                          for (var h1 = 0; h1 <= 24; h1++) {
                            for (var h2 = 0; h2 <= 24; h2++) {
                              testTime(h1, 0, h2, 0);
                            }
                          }
                          debugPrint('====================');
                        },
                        child: const Text('測試經過時間'),
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

/*

# 攻略站做法

設定: (分別是起迄時間)

- 21 ~ 4/5/6.../20/21 => 結果為 4/5/6...20/21 點起床，21點睡覺

 */
