import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../index.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc([this.appTheme])
    : super(
        ThemeState(appTheme: appTheme ?? AppTheme.system),
      ) {
    on<SetAppThemeEvent>(_onSetAppTheme);
  }

  final AppTheme? appTheme;

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toJson();
  }

  FutureOr<void> _onSetAppTheme(SetAppThemeEvent event, Emitter<ThemeState> emit) {
    emit(
      state.copyWith(
        appTheme: event.appTheme,
      ),
    );
  }
}
