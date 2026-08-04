import 'dart:convert';

import 'habit_type.dart';

class HabitGoal {
  const HabitGoal({
    required this.id,
    required this.type,
    required this.startDate,
    required this.createdAt,
    this.archivedAt,
    this.extra = const {},
    this.isActive = true,
  });

  final String id;
  final HabitType type;
  final DateTime startDate;
  final DateTime createdAt;
  final DateTime? archivedAt;
  final Map<String, dynamic> extra;
  final bool isActive;

  String? get customTitle {
    final t = extra['title'] ?? extra['customTitle'];
    if (t is String && t.trim().isNotEmpty) return t.trim();
    return null;
  }

  /// Current streak day number (1-based), calendar days since startDate.
  int get currentDay {
    final now = DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(start).inDays;
    return diff < 0 ? 0 : diff + 1;
  }

  HabitGoal copyWith({
    DateTime? startDate,
    DateTime? archivedAt,
    Map<String, dynamic>? extra,
    bool? isActive,
    bool clearArchived = false,
  }) {
    return HabitGoal(
      id: id,
      type: type,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt,
      archivedAt: clearArchived ? null : (archivedAt ?? this.archivedAt),
      extra: extra ?? this.extra,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'type': type.id,
        'start_date': startDate.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'archived_at': archivedAt?.toIso8601String(),
        'extra_json': jsonEncode(extra),
        'is_active': isActive ? 1 : 0,
      };

  factory HabitGoal.fromMap(Map<String, Object?> m) {
    final type = HabitType.fromId(m['type'] as String) ?? HabitType.custom;
    final extraRaw = m['extra_json'] as String? ?? '{}';
    return HabitGoal(
      id: m['id'] as String,
      type: type,
      startDate: DateTime.parse(m['start_date'] as String),
      createdAt: DateTime.parse(m['created_at'] as String),
      archivedAt: m['archived_at'] != null
          ? DateTime.parse(m['archived_at'] as String)
          : null,
      extra: Map<String, dynamic>.from(jsonDecode(extraRaw) as Map),
      isActive: (m['is_active'] as int? ?? 1) == 1,
    );
  }
}