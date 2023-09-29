import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/widgets/main/gap.dart';

typedef MyOutlinedButtonIconBuilder = Widget Function(Color color, double? size);
typedef MyOutlinedButtonBuilder = Widget Function(BuildContext context, Widget? icon, Widget child);

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.color,
    this.borderColor,
    this.iconBuilder,
    this.builder,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color color;
  final Color? borderColor;
  final MyOutlinedButtonIconBuilder? iconBuilder;
  final MyOutlinedButtonBuilder? builder;

  static Widget builderUnboundWidth(BuildContext context, Widget? icon, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) icon,
        Gap.xl,
        Expanded(child: child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    var icon = iconBuilder?.call(color, 30);
    if (icon != null) {
      icon = Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints.tightFor(width: 30),
        child: icon,
      );
    }

    Widget buttonChild = child;

    if (builder != null) {
      buttonChild = builder!(context, icon, buttonChild);
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(
          color: borderColor ?? color,
          width: 1.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: textColor),
        child: buttonChild,
      ),
    );
  }
}
