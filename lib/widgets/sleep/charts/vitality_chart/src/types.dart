import 'package:fl_chart/fl_chart.dart';

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

enum VitalityChartDataType {
  /// 起床
  getUp,
  /// 睡覺
  sleep,
}
