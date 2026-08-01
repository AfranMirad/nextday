class DailyEntry {
  const DailyEntry({
    required this.id,
    required this.goalId,
    required this.dayNumber,
    required this.entryDate,
    this.milestoneTitle,
    this.milestoneBody,
    this.motivationText,
    this.source = 'template',
    required this.createdAt,
  });

  final String id;
  final String goalId;
  final int dayNumber;
  final DateTime entryDate;
  final String? milestoneTitle;
  final String? milestoneBody;
  final String? motivationText;
  final String source; // template | ai | hybrid
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
        'id': id,
        'goal_id': goalId,
        'day_number': dayNumber,
        'entry_date': entryDate.toIso8601String(),
        'milestone_title': milestoneTitle,
        'milestone_body': milestoneBody,
        'motivation_text': motivationText,
        'source': source,
        'created_at': createdAt.toIso8601String(),
      };

  factory DailyEntry.fromMap(Map<String, Object?> m) => DailyEntry(
        id: m['id'] as String,
        goalId: m['goal_id'] as String,
        dayNumber: m['day_number'] as int,
        entryDate: DateTime.parse(m['entry_date'] as String),
        milestoneTitle: m['milestone_title'] as String?,
        milestoneBody: m['milestone_body'] as String?,
        motivationText: m['motivation_text'] as String?,
        source: m['source'] as String? ?? 'template',
        createdAt: DateTime.parse(m['created_at'] as String),
      );
}