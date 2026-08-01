import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../data/repositories.dart';
import 'backup_io.dart' if (dart.library.html) 'backup_web.dart' as backup_impl;

class BackupService {
  BackupService({AppRepository? repository})
      : _repo = repository ?? AppRepository();

  final AppRepository _repo;

  Future<String> exportToJson() async {
    final payload = {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': 1,
      'platform': kIsWeb ? 'web' : 'io',
      ...await _repo.exportSnapshot(),
    };
    final json = const JsonEncoder.withIndent('  ').convert(payload);
    return backup_impl.saveBackupJson(json);
  }

  Future<String> exportToJsonFile() => exportToJson();
}