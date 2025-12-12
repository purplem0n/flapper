import 'package:flutter/material.dart';

import '../theme/index.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.label,
    required this.scheme,
    super.key,
    this.onPressed,
    this.type,
    this.noTheme = false,
    this.fontSize,
    this.radius,
    this.isLoading = false,
    this.padding,
  });

  final String label;
  final double? fontSize;
  final double? radius;
  final void Function()? onPressed;
  final ColorType? type;
  final bool noTheme;
  final bool isLoading;
  final ColorScheme scheme;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: noTheme
          ? null
          : TextButton.styleFrom(
              shape: radius == null
                  ? null
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(radius!),
                    ),
              backgroundColor: scheme.getSurfaceColor(type),
              foregroundColor: scheme.getOnSurfaceColor(type),
              disabledBackgroundColor: scheme.getSurfaceColor(type).withAlpha(150),
              disabledForegroundColor: scheme.getOnSurfaceColor(type).withAlpha(150),
              padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
            ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  scheme.getOnSurfaceColor(type),
                ),
              ),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
    );
  }
}

class CustomTextIconButton extends StatelessWidget {
  const CustomTextIconButton({
    required this.label,
    required this.icon,
    required this.scheme,
    super.key,
    this.onPressed,
    this.type,
    this.noTheme = false,
    this.height,
    this.padding,
    this.shape,
  });

  final String label;
  final Widget icon;
  final void Function()? onPressed;
  final ColorType? type;
  final bool noTheme;
  final double? height;
  final ColorScheme scheme;
  final EdgeInsetsGeometry? padding;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton.icon(
        onPressed: onPressed,
        style: noTheme
            ? null
            : TextButton.styleFrom(
                backgroundColor: scheme.getSurfaceColor(type),
                foregroundColor: scheme.getOnSurfaceColor(type),
                disabledBackgroundColor: scheme.getSurfaceColor(type).withAlpha(150),
                disabledForegroundColor: scheme.getOnSurfaceColor(type).withAlpha(150),
                padding: padding,
                shape: shape,
              ),
        label: Text(label),
        icon: icon,
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.scheme,
    super.key,
    this.onPressed,
    this.onLongPress,
    this.type,
    this.backgroundOpacity = 1.0,
    this.noTheme = false,
    this.density = VisualDensity.standard,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget icon;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final ColorType? type;
  final bool noTheme;
  final ColorScheme scheme;
  final VisualDensity density;
  final double backgroundOpacity;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      onLongPress: onLongPress,
      visualDensity: density,
      style: noTheme
          ? null
          : TextButton.styleFrom(
              backgroundColor: backgroundColor ?? scheme.getSurfaceColor(type).withAlpha((255 * backgroundOpacity).toInt()),
              foregroundColor: foregroundColor ?? scheme.getOnSurfaceColor(type),
              disabledBackgroundColor: scheme.getSurfaceColor(type).withAlpha(150),
              disabledForegroundColor: scheme.getOnSurfaceColor(type).withAlpha(150),
            ),
      icon: icon,
    );
  }
}
