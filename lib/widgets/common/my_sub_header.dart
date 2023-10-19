import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class MySubHeader extends StatelessWidget {
  const MySubHeader({
    super.key,
    this.titleText,
    this.title,
    Color? color,
  }) : color = color ?? primaryColor;

  final String? titleText;
  final Widget? title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 6,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 6),
              color: color,
              width: 6,
            ),
            Expanded(
              child: CustomPaint(
                painter: _Painter(color),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4,
                  ),
                  child: _buildTitle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTitle() {
    Widget result = title ?? Text(
      titleText ?? '',
    );

    result = IconTheme(
      data: IconThemeData(
        color: color.fgColor,
        size: 14,
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: color.fgColor,
          fontWeight: FontWeight.bold,
        ),
        child: result,
      ),
    );

    return result;
  }
}

class _Painter extends CustomPainter {
  _Painter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 8, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

