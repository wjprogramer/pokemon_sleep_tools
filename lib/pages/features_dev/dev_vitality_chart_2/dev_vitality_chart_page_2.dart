import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/features_main/vitality_info/vitality_info_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
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
    final screenSize = context.mediaQuery.size;
    var foundZero = false;

    final sleepTime = _sleepTimeField.value!;
    final getUpTime = _getUpTimeField.value!;
    final elapsedTime = _calcTimeElapsed(sleepTime, getUpTime);
    final sleepScore = ((elapsedTime.hour * 60.0 + elapsedTime.minute) / 510 * 100).clamp(0.0, 100.0);
    final tableAxisDuration = _calcTableDuration(sleepTime, getUpTime);
    final tableCounts = (tableAxisDuration.hour * 60 + tableAxisDuration.minute) ~/ 5 + 1;
    final tableSpotsLastIndex = tableCounts - 1;

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

      return VitalityChartData(
        spot: FlSpot(index.toDouble(), vitality),
        time: timeText,
        isShowBottomTitle: showBottomTitle,
        isShowTooltip: showTooltip || tableSpotsLastIndex == index,
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
                child: Text('活力曲線'),
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

class VitalityChart extends StatefulWidget {
  const VitalityChart({
    super.key,
    Color? indicatorStrokeColor,
    required this.colors,
    required this.stops,
    required this.spots,
  })  : indicatorStrokeColor = indicatorStrokeColor ?? whiteColor;

  final Color indicatorStrokeColor;
  final List<Color> colors;
  final List<double>? stops;
  final List<VitalityChartData> spots;

  @override
  State<VitalityChart> createState() => _VitalityChartState();
}

class _VitalityChartState extends State<VitalityChart> {
  final _showingTooltipOnSpots = <int>[];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.spots.length; i++) {
      if (widget.spots[i].isShowTooltip) {
        _showingTooltipOnSpots.add(i);
      }
    }
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: greyColor3,
      // fontSize: 14 * chartWidth / 500,
      fontSize: 14,
    );

    final spotIndex = value.toInt();
    if (spotIndex >= widget.spots.length || widget.spots[spotIndex].isShowBottomTitle == false) {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(widget.spots[spotIndex].time, style: style),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: greyColor3,
    );

    final nv = value.toInt() + 1;
    if (nv % 20 != 0) {
      return Container();
    }

    final text = nv.toString();
    return Text(
      text,
      style: style,
      textAlign: TextAlign.center,
    );
  }

  /// Lerps between a [LinearGradient] colors, based on [t]
  Color _lerpGradient(List<Color> colors, List<double> stops, double t) {
    if (colors.isEmpty) {
      throw ArgumentError('"colors" is empty.');
    } else if (colors.length == 1) {
      return colors[0];
    }

    if (stops.length != colors.length) {
      stops = [];

      /// provided gradientColorStops is invalid and we calculate it here
      colors.asMap().forEach((index, color) {
        final percent = 1.0 / (colors.length - 1);
        stops.add(percent * index);
      });
    }

    for (var s = 0; s < stops.length - 1; s++) {
      final leftStop = stops[s];
      final rightStop = stops[s + 1];
      final leftColor = colors[s];
      final rightColor = colors[s + 1];
      if (t <= leftStop) {
        return leftColor;
      } else if (t < rightStop) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return Color.lerp(leftColor, rightColor, sectionT)!;
      }
    }
    return colors.last;
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: _showingTooltipOnSpots,
        spots: widget.spots.map((e) => e.spot).toList(),
        isCurved: false,
        barWidth: 3,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: widget.colors.map((e) => e.withOpacity(0.4)).toList(),
            stops: widget.stops,
          ),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          colors: widget.colors,
          stops: widget.stops,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return AspectRatio(
      aspectRatio: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24, 60, 24, 10,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return LineChart(
            LineChartData(
              showingTooltipIndicators: _showingTooltipOnSpots.map((index) {
                return ShowingTooltipIndicators([
                  LineBarSpot(
                    tooltipsOnBar,
                    lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index],
                  ),
                ]);
              }).toList(),
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                  if (response == null || response.lineBarSpots == null) {
                    return;
                  }
                },
                mouseCursorResolver: (FlTouchEvent event, LineTouchResponse? response) {
                  if (response == null || response.lineBarSpots == null) {
                    return SystemMouseCursors.basic;
                  }
                  return SystemMouseCursors.click;
                },
                getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: whiteColor.withOpacity(.5),
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 6,
                              color: _lerpGradient(
                                barData.gradient!.colors,
                                barData.gradient!.stops!,
                                percent / 100,
                              ),
                              strokeWidth: 2,
                              strokeColor: widget.indicatorStrokeColor,
                            ),
                      ),
                    );
                  }).toList();
                },
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: blackColor.withOpacity(.3),
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 2, vertical: 1,
                  ),
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      final spotIndex = lineBarSpot.x.toInt();
                      final data = widget.spots[spotIndex];

                      return LineTooltipItem(
                        '${data.tooltipText ?? data.time} ',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: lineBarsData,
              minY: 0,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    '活力',
                    style: TextStyle(
                      color: greyColor3,
                    ),
                  ),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    getTitlesWidget: _leftTitleWidgets,
                    showTitles: true,
                    interval: 1,
                    reservedSize: 40,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return _bottomTitleWidgets(
                        value,
                        meta,
                        constraints.maxWidth,
                      );
                    },
                    reservedSize: 30,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                topTitles: AxisTitles(
                  axisNameWidget: Text(
                    '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: greyColor3,
                    ),
                  ),
                  axisNameSize: 0,
                  sideTitles: const SideTitles(
                    showTitles: true,
                    reservedSize: 0,
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: greyColor,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class VitalityChartData {
  VitalityChartData({
    required this.spot,
    this.isShowBottomTitle = false,
    this.isShowTooltip = false,
    required this.time,
    this.tooltipText,
  });

  final FlSpot spot;
  final bool isShowBottomTitle;
  final bool isShowTooltip;
  final String time;
  final String? tooltipText;
}

/*

# 攻略站做法

設定: (分別是起迄時間)

- 21 ~ 4/5/6.../20/21 => 結果為 4/5/6...20/21 點起床，21點睡覺





 */
