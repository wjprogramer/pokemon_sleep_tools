class UiUtility {
  UiUtility._();
  
  static getChildWidthInRowBy({
    required double baseChildWidth,
    required double containerWidth,
    required double spacing,
  }) {
    // containerWidth = count * realWidth + spacing * (count - 1)
    // => containerWidth =  count * (realWidth + spacing) - spacing
    // => count = (containerWidth + spacing) / (realWidth + spacing)
    final count = (containerWidth + spacing) ~/ (baseChildWidth + spacing);
    
    final remainWidth = containerWidth - (count * baseChildWidth + (count - 1) * spacing);
    return baseChildWidth + (remainWidth / count);
  }
  
}