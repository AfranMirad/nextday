class Milestone {
  const Milestone({
    required this.day,
    required this.title,
    required this.body,
    this.motivationHint,
  });

  final int day;
  final String title;
  final String body;
  final String? motivationHint;

  factory Milestone.fromJson(Map<String, dynamic> j) => Milestone(
        day: j['day'] as int,
        title: j['title'] as String,
        body: j['body'] as String,
        motivationHint: j['motivationHint'] as String?,
      );
}

class HabitContentPack {
  const HabitContentPack({
    required this.habitId,
    required this.disclaimer,
    required this.milestones,
    this.fallbackMotivation = const [],
  });

  final String habitId;
  final String disclaimer;
  final List<Milestone> milestones;
  final List<String> fallbackMotivation;

  Milestone resolveForDay(int day) {
    if (milestones.isEmpty) {
      return Milestone(
        day: day,
        title: 'Gün $day',
        body: 'Bugün de yolculuğuna devam ediyorsun. Küçük adımlar büyük değişim yaratır.',
      );
    }
    Milestone? exact;
    Milestone? best;
    for (final m in milestones) {
      if (m.day == day) {
        exact = m;
        break;
      }
      if (m.day <= day && (best == null || m.day > best.day)) {
        best = m;
      }
    }
    return exact ?? best ?? milestones.first;
  }

  String templateMotivation(int day) {
    if (fallbackMotivation.isEmpty) {
      return 'Gün $day — kararlılığın seni ileri taşıyor. Bugünü de tamamla.';
    }
    return fallbackMotivation[(day - 1) % fallbackMotivation.length];
  }

  factory HabitContentPack.fromJson(Map<String, dynamic> j) {
    final list = (j['milestones'] as List? ?? [])
        .map((e) => Milestone.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    final fallback = (j['fallbackMotivation'] as List? ?? [])
        .map((e) => e.toString())
        .toList();
    return HabitContentPack(
      habitId: j['habitId'] as String? ?? '',
      disclaimer: j['disclaimer'] as String? ?? '',
      milestones: list,
      fallbackMotivation: fallback,
    );
  }
}