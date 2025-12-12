import 'dart:convert';

import 'package:equatable/equatable.dart';

/// DON'T USE THIS
class SampleModel extends Equatable {
  final String id;
  final String name;

  const SampleModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory SampleModel.fromMap(Map<String, dynamic> map) {
    return SampleModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SampleModel.fromJson(String source) => SampleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [id, name];
}
