import 'package:ephemeral_value/ephemeral_value.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'index.dart';

/// Example:
///
/// ```dart
/// late final counterListener = BlocListenerHelper<CounterBloc, CounterState>()
/// ```
class BlocListenerHelper<B extends BlocBase<S>, S> {
  const BlocListenerHelper();

  BlocListener<B, S> call<T>(
    T Function(S state) selector, {
    B? bloc,
    bool Function()? forceListen,
    Widget? child,
    String? message,
    void Function(T value)? onSuccess,
    void Function(S state)? onError,
    void Function(S state)? onUpdate,
    bool displayErrorToast = true,
  }) {
    return BlocListener<B, S>(
      bloc: bloc,
      listenWhen: (previous, current) {
        if (forceListen != null && forceListen()) return true;
        return selector(previous) != selector(current);
      },
      listener: (context, state) {
        final value = selector(state);
        if (value is Ephemeral) {
          if (value.isError) {
            if (displayErrorToast) {
              showErrorToast(context, getErrorMessage(value.getError) ?? 'Unknown error.');
            }
            onError?.call(state);
          } else if (value.isSuccess) {
            if (message != null) showSuccessToast(context, message);
            onSuccess?.call(value);
          }
        }
        onUpdate?.call(state);
      },
      child: child,
    );
  }
}
