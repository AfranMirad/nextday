import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Web + mobil ortak yerel depolama (SharedPreferences / IndexedDB uzerinden).
/// sqflite web FFI sorunlarini onlemek icin kullanilir.
class PrefsStore {
  PrefsStore._();
  static final PrefsStore instance = PrefsStore._();

  static const _key = 'gun_sayac_store_v1';

  SharedPreferences? _prefs;
  Map<String, dynamic> _root = {
    'user_profile': <Map<String, dynamic>>[],
    'selected_interests': <Map<String, dynamic>>[],
    'habit_goals': <Map<String, dynamic>>[],
    'daily_entries': <Map<String, dynamic>>[],
    'settings': <Map<String, dynamic>>[],
  };

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_key);
    if (raw == null || raw.isEmpty) {
      await _persist();
      return;
    }
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      _root = {
        'user_profile': _asMapList(decoded['user_profile']),
        'selected_interests': _asMapList(decoded['selected_interests']),
        'habit_goals': _asMapList(decoded['habit_goals']),
        'daily_entries': _asMapList(decoded['daily_entries']),
        'settings': _asMapList(decoded['settings']),
      };
    }
  }

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> _persist() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(_key, jsonEncode(_root));
  }

  List<Map<String, dynamic>> table(String name) {
    final list = _root[name];
    if (list is List<Map<String, dynamic>>) return list;
    final converted = _asMapList(list);
    _root[name] = converted;
    return converted;
  }

  Future<void> replaceTable(
    String name,
    List<Map<String, dynamic>> rows,
  ) async {
    _root[name] = rows;
    await _persist();
  }

  Future<void> upsertById(
    String name,
    Map<String, dynamic> row, {
    String idKey = 'id',
  }) async {
    final rows = table(name);
    final id = row[idKey];
    final idx = rows.indexWhere((r) => r[idKey] == id);
    if (idx >= 0) {
      rows[idx] = row;
    } else {
      rows.add(row);
    }
    await _persist();
  }

  Map<String, dynamic> exportAll() => {
        'user_profile': table('user_profile'),
        'selected_interests': table('selected_interests'),
        'habit_goals': table('habit_goals'),
        'daily_entries': table('daily_entries'),
        'settings': table('settings'),
      };
}