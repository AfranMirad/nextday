import 'package:uuid/uuid.dart';

import '../models/daily_entry.dart';
import '../models/habit_goal.dart';
import '../models/habit_type.dart';
import '../models/user_profile.dart';
import 'prefs_store.dart';

const _uuid = Uuid();

class AppRepository {
  AppRepository({PrefsStore? store}) : _store = store ?? PrefsStore.instance;

  final PrefsStore _store;
  bool _ready = false;

  Future<void> _ensure() async {
    if (_ready) return;
    await _store.init();
    _ready = true;
  }

  Future<UserProfile> ensureAnonymousUser() async {
    await _ensure();
    final rows = _store.table('user_profile');
    if (rows.isNotEmpty) {
      return UserProfile.fromMap(_toObjectMap(rows.first));
    }
    final user = UserProfile(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
    );
    await _store.upsertById('user_profile', Map<String, dynamic>.from(user.toMap()));
    return user;
  }

  Future<UserProfile> updateUser(UserProfile user) async {
    await _ensure();
    await _store.upsertById(
      'user_profile',
      Map<String, dynamic>.from(user.toMap()),
    );
    return user;
  }

  Future<Set<HabitType>> getSelectedInterests() async {
    await _ensure();
    final out = <HabitType>{};
    for (final r in _store.table('selected_interests')) {
      final t = HabitTypeX.fromId(r['habit_type'] as String);
      if (t != null) out.add(t);
    }
    return out;
  }

  Future<void> setSelectedInterests(Set<HabitType> types) async {
    await _ensure();
    await _store.replaceTable(
      'selected_interests',
      types.map((t) => <String, dynamic>{'habit_type': t.id}).toList(),
    );
  }

  Future<List<HabitGoal>> getActiveGoals() async {
    await _ensure();
    final rows = _store
        .table('habit_goals')
        .where((r) => (r['is_active'] as num? ?? 1) == 1)
        .toList()
      ..sort((a, b) => '${a['created_at']}'.compareTo('${b['created_at']}'));
    return rows.map((r) => HabitGoal.fromMap(_toObjectMap(r))).toList();
  }

  Future<List<HabitGoal>> getAllGoals() async {
    await _ensure();
    final rows = List<Map<String, dynamic>>.from(_store.table('habit_goals'))
      ..sort((a, b) => '${b['created_at']}'.compareTo('${a['created_at']}'));
    return rows.map((r) => HabitGoal.fromMap(_toObjectMap(r))).toList();
  }

  Future<HabitGoal?> getActiveGoalForType(HabitType type) async {
    await _ensure();
    for (final r in _store.table('habit_goals')) {
      final active = (r['is_active'] as num? ?? 1) == 1;
      if (active && r['type'] == type.id) {
        return HabitGoal.fromMap(_toObjectMap(r));
      }
    }
    return null;
  }

  Future<HabitGoal> upsertActiveGoal({
    required HabitType type,
    required DateTime startDate,
    required Map<String, dynamic> extra,
  }) async {
    await _ensure();
    final existing = await getActiveGoalForType(type);
    if (existing != null) {
      final updated = existing.copyWith(startDate: startDate, extra: extra);
      await _store.upsertById(
        'habit_goals',
        Map<String, dynamic>.from(updated.toMap()),
      );
      return updated;
    }
    final goal = HabitGoal(
      id: _uuid.v4(),
      type: type,
      startDate: startDate,
      createdAt: DateTime.now(),
      extra: extra,
    );
    await _store.upsertById(
      'habit_goals',
      Map<String, dynamic>.from(goal.toMap()),
    );
    return goal;
  }

  Future<void> deactivateGoal(HabitGoal goal) async {
    await _ensure();
    final archived = goal.copyWith(
      isActive: false,
      archivedAt: DateTime.now(),
    );
    await _store.upsertById(
      'habit_goals',
      Map<String, dynamic>.from(archived.toMap()),
    );
  }

  Future<HabitGoal> relapse(HabitGoal goal, {DateTime? newStart}) async {
    await _ensure();
    await deactivateGoal(goal);
    final fresh = HabitGoal(
      id: _uuid.v4(),
      type: goal.type,
      startDate: newStart ?? DateTime.now(),
      createdAt: DateTime.now(),
      extra: goal.extra,
    );
    await _store.upsertById(
      'habit_goals',
      Map<String, dynamic>.from(fresh.toMap()),
    );
    return fresh;
  }

  Future<DailyEntry?> getEntry(String goalId, int dayNumber) async {
    await _ensure();
    for (final r in _store.table('daily_entries')) {
      if (r['goal_id'] == goalId && (r['day_number'] as num).toInt() == dayNumber) {
        return DailyEntry.fromMap(_toObjectMap(r));
      }
    }
    return null;
  }

  Future<List<DailyEntry>> getRecentEntries(
    String goalId, {
    int limit = 7,
  }) async {
    await _ensure();
    final rows = _store
        .table('daily_entries')
        .where((r) => r['goal_id'] == goalId)
        .toList()
      ..sort(
        (a, b) => (b['day_number'] as num).compareTo(a['day_number'] as num),
      );
    return rows
        .take(limit)
        .map((r) => DailyEntry.fromMap(_toObjectMap(r)))
        .toList();
  }

  Future<DailyEntry> saveEntry(DailyEntry entry) async {
    await _ensure();
    final rows = _store.table('daily_entries');
    final idx = rows.indexWhere(
      (r) =>
          r['goal_id'] == entry.goalId &&
          (r['day_number'] as num).toInt() == entry.dayNumber,
    );
    final map = Map<String, dynamic>.from(entry.toMap());
    if (idx >= 0) {
      rows[idx] = map;
    } else {
      rows.add(map);
    }
    await _store.replaceTable('daily_entries', rows);
    return entry;
  }

  Future<String?> getSetting(String key) async {
    await _ensure();
    for (final r in _store.table('settings')) {
      if (r['key'] == key) return r['value'] as String?;
    }
    return null;
  }

  Future<void> setSetting(String key, String value) async {
    await _ensure();
    final rows = _store.table('settings');
    final idx = rows.indexWhere((r) => r['key'] == key);
    final row = <String, dynamic>{'key': key, 'value': value};
    if (idx >= 0) {
      rows[idx] = row;
    } else {
      rows.add(row);
    }
    await _store.replaceTable('settings', rows);
  }

  Future<Map<String, dynamic>> exportSnapshot() async {
    await _ensure();
    return _store.exportAll();
  }

  Map<String, Object?> _toObjectMap(Map<String, dynamic> raw) {
    return raw.map((k, v) => MapEntry(k, v as Object?));
  }
}