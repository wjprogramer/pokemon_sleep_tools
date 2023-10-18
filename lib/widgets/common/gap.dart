import 'package:gap/gap.dart' as gap;
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';

class Gap {
  Gap._();

  static const xsV = 4.0;
  static const smV = 8.0;
  static const mdV = 12.0;
  static const lgV = 16.0;
  static const xlV = 20.0;
  static const xxlV = 24.0;

  static const xs = gap.Gap(xsV);
  static const sm = gap.Gap(smV);
  static const md = gap.Gap(mdV);
  static const lg = gap.Gap(lgV);
  static const xl = gap.Gap(xlV);
  static const xxl = gap.Gap(xxlV);

  static const h = gap.Gap(HORIZON_PADDING);
  static const hV = HORIZON_PADDING;

  static const trailing = gap.Gap(60);
}