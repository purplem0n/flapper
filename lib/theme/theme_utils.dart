import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

extension ThemeUtils on BuildContext {
  ColorScheme get scheme => Theme.of(this).colorScheme;

  // Primary group
  Color get primary => scheme.primary;
  Color get onPrimary => scheme.onPrimary;
  Color get primaryContainer => scheme.primaryContainer;
  Color get onPrimaryContainer => scheme.onPrimaryContainer;

  // Secondary group
  Color get secondary => scheme.secondary;
  Color get onSecondary => scheme.onSecondary;
  Color get secondaryContainer => scheme.secondaryContainer;
  Color get onSecondaryContainer => scheme.onSecondaryContainer;

  // Tertiary group (Material 3)
  Color get tertiary => scheme.tertiary;
  Color get onTertiary => scheme.onTertiary;
  Color get tertiaryContainer => scheme.tertiaryContainer;
  Color get onTertiaryContainer => scheme.onTertiaryContainer;

  // Error group
  Color get error => scheme.error;
  Color get onError => scheme.onError;
  Color get errorContainer => scheme.errorContainer;
  Color get onErrorContainer => scheme.onErrorContainer;

  // Background / Surface
  Color get surface => scheme.surface;
  Color get onSurface => scheme.onSurface;

  // Variant & Outline
  Color get onSurfaceVariant => scheme.onSurfaceVariant;
  Color get outline => scheme.outline;

  // Inverse colors
  Color get inverseSurface => scheme.inverseSurface;
  Color get onInverseSurface => scheme.onInverseSurface;
  Color get inversePrimary => scheme.inversePrimary;

  // Surface tint for elevation overlays (Material 3)
  Color get surfaceTint => scheme.surfaceTint;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  void toggleThemeMode() {
    final bloc = read<ThemeBloc>();
    final currentTheme = bloc.state.appTheme;

    // Cycle through: system -> light -> dark -> system
    final nextTheme = switch (currentTheme) {
      AppTheme.system => AppTheme.light,
      AppTheme.light => AppTheme.dark,
      AppTheme.dark => AppTheme.system,
    };

    bloc.add(SetAppThemeEvent(nextTheme));
  }
}

extension AppThemeExt on AppTheme {
  Brightness brightness(BuildContext context) {
    switch (this) {
      case AppTheme.system:
        return MediaQuery.of(context).platformBrightness;
      case AppTheme.dark:
        return Brightness.dark;
      case AppTheme.light:
        return Brightness.light;
    }
  }

  ThemeMode get themeMode {
    switch (this) {
      case AppTheme.system:
        return ThemeMode.system;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.light:
        return ThemeMode.light;
    }
  }
}

extension BrightnessExt on Brightness {
  AppTheme get appTheme {
    switch (this) {
      case Brightness.light:
        return AppTheme.light;
      case Brightness.dark:
        return AppTheme.dark;
    }
  }
}
