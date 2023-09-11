import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

/// Firebase Timestamp타입과 Dart DateTime타입을 변환하는 컨버터
class ColorConverter implements JsonConverter<Color, String?> {
  const ColorConverter();

  @override
  Color fromJson(String? color) {
    if (color == null) {
      return Colors.white;
    }

    return Color(int.parse(color));
  }

  @override
  String toJson(Color _) => _.toString();
}
