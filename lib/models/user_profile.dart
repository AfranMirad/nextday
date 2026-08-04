class UserProfile {
  const UserProfile({
    required this.id,
    this.displayName,
    this.birthDate,
    this.age,
    this.gender,
    this.onboardingDone = false,
    this.disclaimerAccepted = false,
    required this.createdAt,
  });

  final String id;
  final String? displayName;
  final DateTime? birthDate;
  /// Legacy stored age; prefer [computedAge] from [birthDate].
  final int? age;
  final String? gender; // male | female | other | prefer_not
  final bool onboardingDone;
  final bool disclaimerAccepted;
  final DateTime createdAt;

  /// Age from birth date when available, otherwise legacy [age].
  int? get computedAge {
    if (birthDate != null) {
      final now = DateTime.now();
      var years = now.year - birthDate!.year;
      final hadBirthday = now.month > birthDate!.month ||
          (now.month == birthDate!.month && now.day >= birthDate!.day);
      if (!hadBirthday) years -= 1;
      return years < 0 ? 0 : years;
    }
    return age;
  }

  UserProfile copyWith({
    String? displayName,
    DateTime? birthDate,
    int? age,
    String? gender,
    bool? onboardingDone,
    bool? disclaimerAccepted,
    bool clearDisplayName = false,
    bool clearBirthDate = false,
    bool clearAge = false,
    bool clearGender = false,
  }) {
    return UserProfile(
      id: id,
      displayName: clearDisplayName ? null : (displayName ?? this.displayName),
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      age: clearAge ? null : (age ?? this.age),
      gender: clearGender ? null : (gender ?? this.gender),
      onboardingDone: onboardingDone ?? this.onboardingDone,
      disclaimerAccepted: disclaimerAccepted ?? this.disclaimerAccepted,
      createdAt: createdAt,
    );
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'display_name': displayName,
        'birth_date': birthDate?.toIso8601String(),
        'age': computedAge,
        'gender': gender,
        'onboarding_done': onboardingDone ? 1 : 0,
        'disclaimer_accepted': disclaimerAccepted ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory UserProfile.fromMap(Map<String, Object?> m) {
    DateTime? birth;
    final rawBirth = m['birth_date'] as String?;
    if (rawBirth != null && rawBirth.isNotEmpty) {
      birth = DateTime.tryParse(rawBirth);
    }
    final legacyRaw = m['age'];
    final legacyAge = legacyRaw is int
        ? legacyRaw
        : (legacyRaw is num ? legacyRaw.toInt() : null);
    // Migrate old profiles that only stored age.
    if (birth == null && legacyAge != null && legacyAge > 0) {
      final now = DateTime.now();
      birth = DateTime(now.year - legacyAge, 1, 1);
    }
    return UserProfile(
      id: m['id'] as String,
      displayName: m['display_name'] as String?,
      birthDate: birth,
      age: legacyAge,
      gender: m['gender'] as String?,
      onboardingDone: (m['onboarding_done'] as int? ?? 0) == 1,
      disclaimerAccepted: (m['disclaimer_accepted'] as int? ?? 0) == 1,
      createdAt: DateTime.parse(m['created_at'] as String),
    );
  }
}
