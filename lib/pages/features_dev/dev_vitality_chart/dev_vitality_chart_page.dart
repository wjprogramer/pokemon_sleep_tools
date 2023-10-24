import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

const _notHide = kDebugMode && !kDebugMode;

class DevVitalityChartPage extends StatefulWidget {
  const DevVitalityChartPage._();

  static const MyPageRoute route = ('/DevVitalityChartPage', _builder);
  static Widget _builder(dynamic args) {
    return const DevVitalityChartPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DevVitalityChartPage> createState() => _DevVitalityChartPageState();
}

class _DevVitalityChartPageState extends State<DevVitalityChartPage> {
  @override
  Widget build(BuildContext context) {
    final baseTime = DateTime(2023, 10, 23, 4, 0, 0);

    MyLineChartData getSpotValue(int index) {
      final time = baseTime.add(Duration(minutes: index * 10));
      final vitality = (100.0 - (index + 1)).clamp(0.0, 100.0);
      final showBottomTitle = index % 15 == 0;
      final showTooltip = vitality == 80.0 || vitality == 60.0 || vitality == 40.0 || vitality == 20.0;

      return MyLineChartData(
        spot: FlSpot(index.toDouble(), vitality),
        time: MyFormatter.date(time, type: DateFormatType.hourMinute),
        isShowBottomTitle: showBottomTitle,
        isShowTooltip: showTooltip,
      );
    }

    return Scaffold(
      appBar: buildAppBar(
        titleText: '活力曲線'.xTr,
      ),
      body: TempVitalityChart(
        colors: const [
          Colors.blue,
          Colors.pink,
          Colors.red,
        ],
        stops: const [0.1, 0.4, 0.9],
        spots: <MyLineChartData>[
          ...<MyLineChartData>[
            for (var i = 0; i < 106; i++)
              getSpotValue(i),
          ],
        ],
      ),
    );
  }
}

class TempVitalityChart extends StatefulWidget {
  const TempVitalityChart({
    super.key,
    Color? indicatorStrokeColor,
    required this.colors,
    required this.stops,
    required this.spots,
  })  : indicatorStrokeColor = indicatorStrokeColor ?? whiteColor;

  final Color indicatorStrokeColor;
  final List<Color> colors;
  final List<double> stops;
  final List<MyLineChartData> spots;

  @override
  State<TempVitalityChart> createState() => _TempVitalityChartState();
}

class _TempVitalityChartState extends State<TempVitalityChart> {
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
      color: Colors.pink,
      fontSize: 14 * chartWidth / 500,
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

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: _showingTooltipOnSpots,
        spots: widget.spots.map((e) => e.spot).toList(),
        isCurved: false,
        barWidth: 3,
        shadow: _notHide
            ? const Shadow(blurRadius: 8)
            : const Shadow(color: Colors.transparent),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: widget.colors.map((e) => e.withOpacity(0.4)).toList(),
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
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24, 20, 24, 10,
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
                  if (event is FlTapUpEvent) {
                    /// 先暫時隱藏，這個寫法代表 tooltip 點了之後可以 toggle 顯示
                    if (_notHide) {
                      final spotIndex = response.lineBarSpots!.first.spotIndex;
                      setState(() {
                        if (_showingTooltipOnSpots.contains(spotIndex)) {
                          _showingTooltipOnSpots.remove(spotIndex);
                        } else {
                          _showingTooltipOnSpots.add(spotIndex);
                        }
                      });
                    }
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
                        color: Colors.pink.withOpacity(.5),
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
                  tooltipBgColor: Colors.pink,
                  tooltipRoundedRadius: 8,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4,
                  ),
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      return LineTooltipItem(
                        lineBarSpot.y.toString(),
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: lineBarsData,
              minY: 0,
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  axisNameWidget: Text('活力'),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
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
                  axisNameWidget: _notHide ? Text('count') : Text(''),
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 0,
                  ),
                ),
                topTitles: const AxisTitles(
                  axisNameWidget: Text(
                    '活力曲線',
                    textAlign: TextAlign.left,
                  ),
                  axisNameSize: 24,
                  sideTitles: SideTitles(
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

class MyLineChartData {
  MyLineChartData({
    required this.spot,
    this.isShowBottomTitle = false,
    this.isShowTooltip = false,
    required this.time,
  });

  final FlSpot spot;
  final bool isShowBottomTitle;
  final bool isShowTooltip;
  final String time;
}
