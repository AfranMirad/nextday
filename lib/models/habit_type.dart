import 'package:flutter/material.dart';

enum HabitType {
  smoking,
  alcohol,
  drugs,
  masturbation,
  diet,
  sports,
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
    }
  }

  String get titleTr {
    switch (this) {
      case HabitType.smoking:
        return 'Sigara bırakma';
      case HabitType.alcohol:
        return 'Alkol bırakma';
      case HabitType.drugs:
        return 'Uyuşturucu bırakma';
      case HabitType.masturbation:
        return 'Mastürbasyon bırakma';
      case HabitType.diet:
        return 'Diyet';
      case HabitType.sports:
        return 'Spor';
    }
  }

  String get shortTitleTr {
    switch (this) {
      case HabitType.smoking:
        return 'Sigara';
      case HabitType.alcohol:
        return 'Alkol';
      case HabitType.drugs:
        return 'Uyuşturucu';
      case HabitType.masturbation:
        return 'Mastürbasyon';
      case HabitType.diet:
        return 'Diyet';
      case HabitType.sports:
        return 'Spor';
    }
  }

  String get subtitleTr {
    switch (this) {
      case HabitType.smoking:
        return 'Nefes almak ve vücudunu yenilemek için';
      case HabitType.alcohol:
        return 'Zihin berraklığı ve kontrol için';
      case HabitType.drugs:
        return 'Sağlıklı bir yaşam için destek';
      case HabitType.masturbation:
        return 'Öz disiplin ve odak için';
      case HabitType.diet:
        return 'Beslenme ve enerji dengen için';
      case HabitType.sports:
        return 'Hareket ve güç için';
    }
  }

  IconData get icon {
    switch (this) {
      case HabitType.smoking:
        return Icons.smoke_free;
      case HabitType.alcohol:
        return Icons.no_drinks;
      case HabitType.drugs:
        return Icons.medication_liquid;
      case HabitType.masturbation:
        return Icons.self_improvement;
      case HabitType.diet:
        return Icons.restaurant;
      case HabitType.sports:
        return Icons.fitness_center;
    }
  }

  bool get isQuitHabit =>
      this == HabitType.smoking ||
      this == HabitType.alcohol ||
      this == HabitType.drugs ||
      this == HabitType.masturbation;

  String get contentAssetPath => 'assets/content/$id/milestones.json';

  static HabitType? fromId(String id) {
    for (final t in HabitType.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}