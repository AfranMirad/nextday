import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../config.dart';
import '../data/repositories.dart';
import '../models/daily_entry.dart';
import '../models/habit_goal.dart';
import '../models/habit_type.dart';
import '../models/user_profile.dart';
import '../services/ai_motivation_service.dart';
import '../services/content_service.dart';
import '../services/notification_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    AppRepository? repository,
    ContentService? contentService,
    AiMotivationService? aiService,
    NotificationService? notificationService,
  })  : _repo = repository ?? AppRepository(),
        _content = contentService ?? ContentService(),
        _ai = aiService ?? AiMotivationService(),
        notifications = notificationService ?? NotificationService();

  final AppRepository _repo;
  final ContentService _content;
  final AiMotivationService _ai;
  final NotificationService notifications;

  bool ready = false;
  String? error;
  UserProfile? user;
  Set<HabitType> selectedInterests = {};
  List<HabitGoal> activeGoals = [];
  bool notificationsEnabled = true;

  /// null = follow device language
  Locale? localeOverride;

  /// system | light | dark
  ThemeMode themeMode = ThemeMode.system;

  Future<void> init() async {
    try {
      user = await _repo.ensureAnonymousUser();
      selectedInterests = await _repo.getSelectedInterests();
      activeGoals = await _repo.getActiveGoals();
      final notif = await _repo.getSetting('notifications_enabled');
      notificationsEnabled = notif != '0';
      final lang = await _repo.getSetting('locale_override');
      if (lang == 'tr' || lang == 'en') {
        localeOverride = Locale(lang!);
      }
      final theme = await _repo.getSetting('theme_mode');
      themeMode = switch (theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      try {
        await notifications.init();
        if (notificationsEnabled) {
          await notifications.scheduleDailyReminder();
        }
      } catch (_) {}
      ready = true;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      ready = true;
      notifyListeners();
    }
  }

  Future<void> setLocaleOverride(Locale? locale) async {
    localeOverride = locale;
    if (locale == null) {
      await _repo.setSetting('locale_override', '');
    } else {
      await _repo.setSetting('locale_override', locale.languageCode);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _repo.setSetting('theme_mode', value);
    notifyListeners();
  }

  Future<void> acceptDisclaimer() async {
    if (user == null) return;
    user = await _repo.updateUser(user!.copyWith(disclaimerAccepted: true));
    notifyListeners();
  }

  Future<void> completeOnboarding(Set<HabitType> interests) async {
    selectedInterests = Set.of(interests);
    await _repo.setSelectedInterests(selectedInterests);
    if (user != null) {
      user = await _repo.updateUser(user!.copyWith(onboardingDone: true));
    }
    notifyListeners();
  }

  Future<void> updateInterests(Set<HabitType> interests) async {
    selectedInterests = Set.of(interests);
    await _repo.setSelectedInterests(selectedInterests);
    for (final g in List<HabitGoal>.from(activeGoals)) {
      if (g.type == HabitType.custom) continue;
      if (!selectedInterests.contains(g.type)) {
        await _repo.deactivateGoal(g);
      }
    }
    activeGoals = await _repo.getActiveGoals();
    notifyListeners();
  }

  Future<void> addInterest(HabitType type) async {
    if (type == HabitType.custom) return;
    if (selectedInterests.contains(type)) return;
    selectedInterests = {...selectedInterests, type};
    await _repo.setSelectedInterests(selectedInterests);
    notifyListeners();
  }

  Future<void> updateProfile({
    String? displayName,
    int? age,
    String? gender,
  }) async {
    if (user == null) return;
    user = await _repo.updateUser(
      user!.copyWith(
        displayName: displayName,
        age: age,
        gender: gender,
      ),
    );
    notifyListeners();
  }

  Future<HabitGoal> saveGoalSetup({
    required HabitType type,
    required DateTime startDate,
    required Map<String, dynamic> extra,
  }) async {
    final goal = await _repo.upsertActiveGoal(
      type: type,
      startDate: startDate,
      extra: extra,
    );
    activeGoals = await _repo.getActiveGoals();
    notifyListeners();
    return goal;
  }

  HabitGoal? goalFor(HabitType type) {
    for (final g in activeGoals) {
      if (g.type == type) return g;
    }
    return null;
  }

  Future<HabitGoal> relapse(HabitGoal goal) async {
    final fresh = await _repo.relapse(goal);
    activeGoals = await _repo.getActiveGoals();
    notifyListeners();
    return fresh;
  }

  Future<DailyEntry> ensureTodayEntry(HabitGoal goal) async {
    final day = goal.currentDay;
    final existing = await _repo.getEntry(goal.id, day);
    if (existing != null) return existing;

    final pack = await _content.load(goal.type);
    final milestone = pack.resolveForDay(day);
    final template = milestone.motivationHint ?? pack.templateMotivation(day);
    final recent = await _repo.getRecentEntries(
      goal.id,
      limit: AppConfig.aiHistoryDays,
    );

    final ai = await _ai.generate(
      user: user!,
      goal: goal,
      dayNumber: day,
      milestone: milestone,
      templateMotivation: template,
      recentEntries: recent,
    );

    final entry = DailyEntry(
      id: const Uuid().v4(),
      goalId: goal.id,
      dayNumber: day,
      entryDate: DateTime.now(),
      milestoneTitle: milestone.title,
      milestoneBody: milestone.body,
      motivationText: ai.text,
      source: ai.source,
      createdAt: DateTime.now(),
    );
    return _repo.saveEntry(entry);
  }

  Future<List<DailyEntry>> recentEntries(HabitGoal goal) {
    return _repo.getRecentEntries(goal.id, limit: 14);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    notificationsEnabled = enabled;
    await _repo.setSetting('notifications_enabled', enabled ? '1' : '0');
    if (enabled) {
      await notifications.requestPermissions();
      await notifications.scheduleDailyReminder();
    } else {
      await notifications.cancelDailyReminder();
    }
    notifyListeners();
  }
}