import 'package:flutter/cupertino.dart';
import 'package:pokemon_sleep_tools/all_in_one/constants/ui.dart';

class UiUtility {
  UiUtility._();
  
  static double getChildWidthInRowBy({
    required double baseChildWidth,
    required double containerWidth,
    required double spacing,
  }) {
    // containerWidth = count * realWidth + spacing * (count - 1)
    // => containerWidth =  count * (realWidth + spacing) - spacing
    // => count = (containerWidth + spacing) / (realWidth + spacing)
    final count = (containerWidth + spacing) ~/ (baseChildWidth + spacing);
    print('$count, $containerWidth');
    
    final remainWidth = containerWidth - (count * baseChildWidth + (count - 1) * spacing);
    return baseChildWidth + (remainWidth / count);
  }

  static (double, double) getCommonWidthInRowBy(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final mainWidth = screenSize.width - 2 * HORIZON_PADDING;
    const spacing = 12.0;

    final childWidth = getChildWidthInRowBy(
      baseChildWidth: 150.0,
      containerWidth: mainWidth,
      spacing: spacing,
    );

    return (childWidth, spacing);
  }
  
}

typedef CommonWidthResults = (double, double);
extension CommonWidthResultsX on CommonWidthResults {
  double get childWidth => this.$1;
  double get spacing => this.$2;
}



