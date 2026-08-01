import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<String> saveBackupJson(String json) async {
  final bytes = Uint8List.fromList(json.codeUnits);
  final data = bytes.buffer.toJS;
  final parts = [data].toJS;
  final blob = web.Blob(parts, web.BlobPropertyBag(type: 'application/json'));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download =
      'gun_sayac_backup_${DateTime.now().millisecondsSinceEpoch}.json';
  web.document.body!.appendChild(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
  return 'Indirme baslatildi';
}