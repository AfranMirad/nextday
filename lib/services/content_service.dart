import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/habit_type.dart';
import '../models/milestone.dart';

class ContentService {
  final Map<String, HabitContentPack> _cache = {};

  Future<HabitContentPack> load(HabitType type) async {
    final cached = _cache[type.id];
    if (cached != null) return cached;
    try {
      final raw = await rootBundle.loadString(type.contentAssetPath);
      final pack = HabitContentPack.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
      _cache[type.id] = pack;
      return pack;
    } catch (_) {
      final fallback = HabitContentPack(
        habitId: type.id,
        disclaimer:
            'Bu içerikler genel bilgilendirme amaçlıdır; tıbbi tavsiye yerine geçmez.',
        milestones: [
          const Milestone(
            day: 1,
            title: 'İlk gün',
            body:
                'Bugün yolculuğuna başladın. Küçük adımlar birikir; kendine nazik ol.',
            motivationHint: 'Başlangıç cesaret ister.',
          ),
          const Milestone(
            day: 3,
            title: 'Üçüncü gün',
            body:
                'Vücudun ve zihnin yeni düzene uyum sağlamaya başlıyor. Devam et.',
          ),
          const Milestone(
            day: 7,
            title: 'Bir hafta',
            body:
                'Bir haftalık süre, alışkanlık döngüsünü kırmada önemli bir eşiktir.',
          ),
        ],
        fallbackMotivation: [
          'Bugün de seçiminle gurur duyabilirsin.',
          'Zor anlar geçer; sen kalırsın.',
          'Her temiz gün, geleceğine yatırım.',
        ],
      );
      _cache[type.id] = fallback;
      return fallback;
    }
  }
}