import '../index.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class SetAppThemeEvent extends ThemeEvent {
  final AppTheme appTheme;
  const SetAppThemeEvent([this.appTheme = AppTheme.system]);
}
