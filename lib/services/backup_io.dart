import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> saveBackupJson(String json) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(
    p.join(
      dir.path,
      'gun_sayac_backup_${DateTime.now().millisecondsSinceEpoch}.json',
    ),
  );
  await file.writeAsString(json);
  return file.path;
}