import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../index.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  TemplateBloc(this.repository) : super(const TemplateState()) {
    on<IncrementEvent>(_onIncrementEvent);
    on<DecrementEvent>(_onDecrementEvent);
  }

  final TemplateRepository repository;

  FutureOr<void> _onIncrementEvent(IncrementEvent event, Emitter<TemplateState> emit) async {
    try {
      emit(state.copyWith(counter: state.counter.toLoading()));
      final count = await repository.increment(state.counter.value!);
      emit(state.copyWith(counter: state.counter.toSuccess(count)));
    } catch (e) {
      emit(state.copyWith(counter: state.counter.toError(null, e)));
    }
  }

  FutureOr<void> _onDecrementEvent(DecrementEvent event, Emitter<TemplateState> emit) async {
    try {
      emit(state.copyWith(counter: state.counter.toLoading()));
      final count = await repository.decrement(state.counter.value!);
      emit(state.copyWith(counter: state.counter.toSuccess(count)));
    } catch (e) {
      emit(state.copyWith(counter: state.counter.toError(null, e)));
    }
  }
}
