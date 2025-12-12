import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

enum ColorType {
  primary,
  secondary,
  tertiary,
  error,
  warn,
  success,
  none,
}

extension ColorSchemeExt on ColorScheme {
  Color getOnContainerColor(ColorType? type) {
    switch (type ?? ColorType.secondary) {
      case ColorType.primary:
        return onPrimaryContainer;
      case ColorType.secondary:
        return onSecondaryContainer;
      case ColorType.tertiary:
        return onTertiaryContainer;
      case ColorType.error:
        return onErrorContainer;
      case ColorType.warn:
        return onWarnContainer;
      case ColorType.success:
        return onSuccessContainer;
      case ColorType.none:
        return onPrimaryContainer;
    }
  }

  Color getContainerColor(ColorType? type) {
    switch (type ?? ColorType.secondary) {
      case ColorType.primary:
        return primaryContainer;
      case ColorType.secondary:
        return secondaryContainer;
      case ColorType.tertiary:
        return tertiaryContainer;
      case ColorType.error:
        return errorContainer;
      case ColorType.warn:
        return warnContainer;
      case ColorType.success:
        return successContainer;
      case ColorType.none:
        return Colors.transparent;
    }
  }

  Color getOnSurfaceColor(ColorType? type) {
    switch (type) {
      case ColorType.primary:
        return onPrimary;
      case ColorType.secondary:
        return onSecondary;
      case ColorType.tertiary:
        return onTertiary;
      case ColorType.error:
        return onError;
      case ColorType.warn:
        return onWarn;
      case ColorType.success:
        return onSuccess;
      case ColorType.none:
        return onSurface;
      case null:
        return onSurface;
    }
  }

  Color getSurfaceColor(ColorType? type) {
    switch (type) {
      case ColorType.primary:
        return primary;
      case ColorType.secondary:
        return secondary;
      case ColorType.tertiary:
        return tertiary;
      case ColorType.error:
        return error;
      case ColorType.warn:
        return warn;
      case ColorType.success:
        return success;
      case ColorType.none:
        return Colors.transparent;
      case null:
        return surface;
    }
  }
}

extension VisibleOnColor on Color {
  /// Returns black or white for the most visible color on this [Color].
  ///
  /// Calculates the luminance of this color and returns black for light
  /// colors and white for dark colors, based on a 0.5 threshold.
  Color get getMostVisibleColor => computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

// --- Success Color Definition ---
// Using CorePalette for the 'success' color as it provides the desired result.
final CorePalette successCorePalette = CorePalette.of(0xFF4CAF50);

// --- Warn Color Definition (Matching Success Vibrancy) ---
// 1. Get the chroma (vibrancy) from the successful green implementation.
final Hct successHct = Hct.fromInt(0xFF4CAF50);
final double successChroma = successHct.chroma;

// 2. Get the hue from your desired 'warn' color.
final Hct warnHct = Hct.fromInt(0xFFFF9800);
final double warnHue = warnHct.hue;

// 3. Create the 'warn' palette using the orange hue but with the green's vibrancy
//    to ensure they have a similar visual impact.
final TonalPalette warnTonalPalette = TonalPalette.of(warnHue, successChroma);

extension CustomColors on ColorScheme {
  bool get isDark => brightness == Brightness.dark;

  // Success colors from CorePalette
  Color get success => Color(successCorePalette.primary.get(isDark ? 80 : 40));
  Color get onSuccess => Color(successCorePalette.primary.get(isDark ? 20 : 100));
  Color get successContainer => Color(successCorePalette.primary.get(isDark ? 30 : 90));
  Color get onSuccessContainer => Color(successCorePalette.primary.get(isDark ? 90 : 10));

  // Warn colors from the custom, vibrant TonalPalette
  Color get warn => Color(warnTonalPalette.get(isDark ? 80 : 40));
  Color get onWarn => Color(warnTonalPalette.get(isDark ? 20 : 100));
  Color get warnContainer => Color(warnTonalPalette.get(isDark ? 30 : 90));
  Color get onWarnContainer => Color(warnTonalPalette.get(isDark ? 90 : 10));
}
