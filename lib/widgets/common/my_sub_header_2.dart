import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_sleep_tools/all_in_one/extensions/extensions.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';

class MySubHeader2 extends StatelessWidget {
  const MySubHeader2({
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
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 6,
      ),
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 4,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: greyColor,
            ),
          )
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                color: color,
                width: 6,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                  ),
                  child: _buildTitle(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTitle(ThemeData theme) {
    Widget result = title ?? Text(
      titleText ?? '',
    );

    result = DefaultTextStyle(
      style: (theme.textTheme.bodyMedium ?? TextStyle()).copyWith(
        fontWeight: FontWeight.bold,
      ),
      child: result,
    );

    return result;
  }
}
