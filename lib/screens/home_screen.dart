import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../l10n/habit_l10n.dart';
import '../models/habit_type.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'habit_detail_screen.dart';
import 'habit_setup_screen.dart';
import 'onboarding_interests_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final l10n = AppLocalizations.of(context);
    final interests = app.selectedInterests.toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appName),
        actions: [
          IconButton(
            tooltip: l10n.interests,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const OnboardingInterestsScreen(allowSkip: true),
                ),
              );
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: interests.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.pagePadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.noGoalsYet, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const OnboardingInterestsScreen(
                              allowSkip: true,
                            ),
                          ),
                        );
                      },
                      child: Text(l10n.pickGoals),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppTheme.pagePadding),
              children: [
                Text(
                  l10n.activeJourneys,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.onlySelectedVisible,
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
                const SizedBox(height: 16),
                ...interests.map((type) {
                  final goal = app.goalFor(type);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HabitCard(
                      title: type.title(l10n),
                      icon: type.icon,
                      dayLabel: goal != null
                          ? l10n.dayN(goal.currentDay)
                          : l10n.completeSetup,
                      configured: goal != null,
                      onTap: () async {
                        if (goal == null) {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => HabitSetupScreen(type: type),
                            ),
                          );
                        } else {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  HabitDetailScreen(goalId: goal.id),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.configured,
    required this.dayLabel,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool configured;
  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayLabel,
                      style: TextStyle(
                        color: configured
                            ? AppTheme.primary
                            : AppTheme.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textSoft),
            ],
          ),
        ),
      ),
    );
  }
}