class UserProfile {
  const UserProfile({
    required this.id,
    this.displayName,
    this.age,
    this.gender,
    this.onboardingDone = false,
    this.disclaimerAccepted = false,
    required this.createdAt,
  });

  final String id;
  final String? displayName;
  final int? age;
  final String? gender; // male | female | other | prefer_not
  final bool onboardingDone;
  final bool disclaimerAccepted;
  final DateTime createdAt;

  UserProfile copyWith({
    String? displayName,
    int? age,
    String? gender,
    bool? onboardingDone,
    bool? disclaimerAccepted,
    bool clearDisplayName = false,
    bool clearAge = false,
    bool clearGender = false,
  }) {
    return UserProfile(
      id: id,
      displayName: clearDisplayName ? null : (displayName ?? this.displayName),
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
        'age': age,
        'gender': gender,
        'onboarding_done': onboardingDone ? 1 : 0,
        'disclaimer_accepted': disclaimerAccepted ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory UserProfile.fromMap(Map<String, Object?> m) => UserProfile(
        id: m['id'] as String,
        displayName: m['display_name'] as String?,
        age: m['age'] as int?,
        gender: m['gender'] as String?,
        onboardingDone: (m['onboarding_done'] as int? ?? 0) == 1,
        disclaimerAccepted: (m['disclaimer_accepted'] as int? ?? 0) == 1,
        createdAt: DateTime.parse(m['created_at'] as String),
      );
}