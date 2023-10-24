import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class VitalityChart extends StatefulWidget {
  const VitalityChart({
    super.key,
    Color? indicatorStrokeColor,
    required this.colors,
    required this.stops,
    required this.spots,
    required this.showingTooltipIndexOnSpots,
  })  : indicatorStrokeColor = indicatorStrokeColor ?? whiteColor;

  final Color indicatorStrokeColor;
  final List<Color> colors;
  final List<double>? stops;
  final List<VitalityChartData> spots;
  final List<int> showingTooltipIndexOnSpots;

  @override
  State<VitalityChart> createState() => _VitalityChartState();
}

class _VitalityChartState extends State<VitalityChart> {
  Widget _bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: greyColor3,
      // fontSize: 14 * chartWidth / 500,
      fontSize: 10,
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
        showingIndicators: widget.showingTooltipIndexOnSpots,
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
              showingTooltipIndicators: widget.showingTooltipIndexOnSpots.map((index) {
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
                  tooltipBgColor: greyColor2.withOpacity(.8),
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