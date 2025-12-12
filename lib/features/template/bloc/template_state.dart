import 'package:ephemeral_value/ephemeral_value.dart';
import 'package:equatable/equatable.dart';

class TemplateState extends Equatable {
  final Ephemeral<int> counter;

  const TemplateState({
    this.counter = const InitialValue(0),
  });

  @override
  List<Object> get props => [
    counter,
  ];

  TemplateState copyWith({
    Ephemeral<int>? counter,
  }) {
    return TemplateState(
      counter: counter ?? this.counter,
    );
  }
}
