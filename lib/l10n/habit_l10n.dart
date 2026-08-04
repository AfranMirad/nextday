import '../models/habit_catalog.dart';
import '../models/habit_goal.dart';
import '../models/habit_type.dart';
import 'app_localizations.dart';

extension HabitCategoryL10n on HabitCategory {
  String title(AppLocalizations l10n) {
    switch (this) {
      case HabitCategory.addiction:
        return l10n.catAddiction;
      case HabitCategory.nutritionQuit:
        return l10n.catNutritionQuit;
      case HabitCategory.digitalDetox:
        return l10n.catDigitalDetox;
      case HabitCategory.mentalQuit:
        return l10n.catMentalQuit;
      case HabitCategory.healthStart:
        return l10n.catHealthStart;
      case HabitCategory.growthStart:
        return l10n.catGrowthStart;
      case HabitCategory.lifestyleStart:
        return l10n.catLifestyleStart;
    }
  }

  String sectionHint(AppLocalizations l10n) {
    switch (this) {
      case HabitCategory.addiction:
      case HabitCategory.nutritionQuit:
      case HabitCategory.digitalDetox:
      case HabitCategory.mentalQuit:
        return l10n.sectionQuitHint;
      case HabitCategory.healthStart:
      case HabitCategory.growthStart:
      case HabitCategory.lifestyleStart:
        return l10n.sectionStartHint;
    }
  }
}

extension HabitTypeL10n on HabitType {
  String title(AppLocalizations l10n) {
    if (isCustom) return l10n.habitCustom;
    final lang = l10n.localeName.toLowerCase();
    return lang.startsWith('tr') ? def.titleTr : def.titleEn;
  }

  String shortTitle(AppLocalizations l10n) {
    if (isCustom) return l10n.habitCustomShort;
    final lang = l10n.localeName.toLowerCase();
    return lang.startsWith('tr') ? def.shortTr : def.shortEn;
  }
}

extension HabitGoalL10n on HabitGoal {
  String displayTitle(AppLocalizations l10n) {
    if (type.isCustom) return customTitle ?? l10n.habitCustom;
    return type.title(l10n);
  }

  String displayShort(AppLocalizations l10n) {
    if (type.isCustom) return customTitle ?? l10n.habitCustomShort;
    return type.shortTitle(l10n);
  }
}