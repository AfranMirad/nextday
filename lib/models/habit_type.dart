import 'package:flutter/material.dart';

enum HabitType {
  smoking,
  alcohol,
  drugs,
  masturbation,
  diet,
  sports,
  custom,
}

extension HabitTypeX on HabitType {
  String get id {
    switch (this) {
      case HabitType.smoking:
        return 'smoking';
      case HabitType.alcohol:
        return 'alcohol';
      case HabitType.drugs:
        return 'drugs';
      case HabitType.masturbation:
        return 'masturbation';
      case HabitType.diet:
        return 'diet';
      case HabitType.sports:
        return 'sports';
      case HabitType.custom:
        return 'custom';
    }
  }

  bool get isBuiltIn => this != HabitType.custom;

  bool get isQuitHabit =>
      this == HabitType.smoking ||
      this == HabitType.alcohol ||
      this == HabitType.drugs ||
      this == HabitType.masturbation;

  IconData get icon {
    switch (this) {
      case HabitType.smoking:
        return Icons.smoking_rooms_outlined;
      case HabitType.alcohol:
        return Icons.wine_bar_outlined;
      case HabitType.drugs:
        return Icons.medication_outlined;
      case HabitType.masturbation:
        return Icons.self_improvement_outlined;
      case HabitType.diet:
        return Icons.eco_outlined;
      case HabitType.sports:
        return Icons.directions_run_outlined;
      case HabitType.custom:
        return Icons.flag_outlined;
    }
  }

  /// Capsule accent inspired by brand logo (coral / sand / sage).
  Color get badgeColor {
    switch (this) {
      case HabitType.smoking:
        return const Color(0xFFE59A94);
      case HabitType.alcohol:
        return const Color(0xFFEBCB93);
      case HabitType.drugs:
        return const Color(0xFFD4A5A5);
      case HabitType.masturbation:
        return const Color(0xFFC4B5D4);
      case HabitType.diet:
        return const Color(0xFF98B48D);
      case HabitType.sports:
        return const Color(0xFF7FA88A);
      case HabitType.custom:
        return const Color(0xFF8FA89A);
    }
  }

  String get contentAssetPath => 'assets/content/$id/milestones.json';

  static HabitType? fromId(String id) {
    if (id.startsWith('custom')) return HabitType.custom;
    for (final t in HabitType.values) {
      if (t.id == id) return t;
    }
    return null;
  }

  static List<HabitType> get presets => HabitType.values
      .where((t) => t != HabitType.custom)
      .toList(growable: false);
}