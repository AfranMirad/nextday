import 'package:flutter/material.dart';

import 'habit_catalog.dart';

@immutable
class HabitType {
  const HabitType._(this.id);

  final String id;

  static const custom = HabitType._('custom');

  static const smoking = HabitType._('smoking');
  static const alcohol = HabitType._('alcohol');
  static const drugs = HabitType._('drugs');
  static const masturbation = HabitType._('masturbation');
  static const diet = HabitType._('diet');
  static const sports = HabitType._('sports');

  bool get isCustom => id == 'custom' || id.startsWith('custom');

  bool get isBuiltIn => !isCustom;

  HabitDefinition? get definition =>
      isCustom ? null : HabitCatalog.byId(id);

  HabitDefinition get def =>
      definition ??
      const HabitDefinition(
        id: 'custom',
        category: HabitCategory.lifestyleStart,
        kind: HabitKind.start,
        titleTr: 'Özel konu',
        titleEn: 'Custom topic',
        shortTr: 'Özel',
        shortEn: 'Custom',
        icon: Icons.flag_outlined,
        badgeColor: Color(0xFF8FA89A),
      );

  bool get isQuitHabit => isCustom ? true : def.kind == HabitKind.quit;

  bool get hasDetailedSetup => definition?.hasDetailedSetup ?? false;

  IconData get icon => def.icon;

  Color get badgeColor => def.badgeColor;

  HabitCategory? get category => definition?.category;

  String get contentAssetPath => 'assets/content/$id/milestones.json';

  static HabitType? fromId(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw == 'custom' || raw.startsWith('custom')) return custom;
    if (HabitCatalog.byId(raw) != null) return HabitType._(raw);
    return null;
  }

  static HabitType of(String id) => fromId(id) ?? HabitType._(id);

  static List<HabitType> get presets =>
      HabitCatalog.all.map((d) => HabitType._(d.id)).toList(growable: false);

  static List<HabitType> presetsIn(HabitCategory category) => HabitCatalog
      .byCategory(category)
      .map((d) => HabitType._(d.id))
      .toList(growable: false);

  @override
  bool operator ==(Object other) =>
      other is HabitType && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'HabitType($id)';
}

/// Compatibility alias used by older call sites.
typedef HabitTypeX = HabitType;