import '../models/habit_type.dart';
import 'app_localizations.dart';

extension HabitTypeL10n on HabitType {
  String title(AppLocalizations l10n) {
    switch (this) {
      case HabitType.smoking:
        return l10n.habitSmoking;
      case HabitType.alcohol:
        return l10n.habitAlcohol;
      case HabitType.drugs:
        return l10n.habitDrugs;
      case HabitType.masturbation:
        return l10n.habitMasturbation;
      case HabitType.diet:
        return l10n.habitDiet;
      case HabitType.sports:
        return l10n.habitSports;
    }
  }

  String shortTitle(AppLocalizations l10n) {
    switch (this) {
      case HabitType.smoking:
        return l10n.habitSmokingShort;
      case HabitType.alcohol:
        return l10n.habitAlcoholShort;
      case HabitType.drugs:
        return l10n.habitDrugsShort;
      case HabitType.masturbation:
        return l10n.habitMasturbationShort;
      case HabitType.diet:
        return l10n.habitDietShort;
      case HabitType.sports:
        return l10n.habitSportsShort;
    }
  }
}