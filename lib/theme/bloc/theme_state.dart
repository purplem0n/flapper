import 'package:equatable/equatable.dart';

enum AppTheme {
  system,
  dark,
  light,
}

class ThemeState extends Equatable {
  final AppTheme appTheme;

  bool get darkMode => appTheme == AppTheme.dark;

  const ThemeState({
    this.appTheme = AppTheme.system,
  });

  @override
  List<Object> get props => [
    appTheme,
  ];

  ThemeState copyWith({
    AppTheme? appTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appTheme': appTheme.name,
    };
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(
      appTheme: AppTheme.values.byName(json['appTheme'] as String),
    );
  }
}
