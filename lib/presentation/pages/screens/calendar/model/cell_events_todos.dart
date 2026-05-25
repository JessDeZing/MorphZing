import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CellEventsTodos with EquatableMixin {
  final String name;
  final Color? color;

  const CellEventsTodos({
    required this.name,
    required this.color,
  });

  @override
  List<Object?> get props => [name, color];
}
