import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../l10n/habit_l10n.dart';
import '../models/habit_type.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_badge.dart';
import 'habit_detail_screen.dart';
import 'habit_setup_screen.dart';
import 'onboarding_interests_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final l10n = AppLocalizations.of(context);
    final interests = HabitTypeX.presets
        .where(app.selectedInterests.contains)
        .toList();
    final customGoals =
        app.activeGoals.where((g) => g.type == HabitType.custom).toList();

    final hasCards = interests.isNotEmpty || customGoals.isNotEmpty;

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNewTopic(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.newTopic),
      ),
      body: !hasCards
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.pagePadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.noGoalsYet, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      l10n.newTopicHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.muted(context)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _openNewTopic(context),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.newTopic),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.pagePadding,
                AppTheme.pagePadding,
                AppTheme.pagePadding,
                96,
              ),
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
                  style: TextStyle(color: AppTheme.muted(context)),
                ),
                const SizedBox(height: 16),
                ...interests.map((type) {
                  final goal = app.goalFor(type);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HabitCard(
                      title: type.title(l10n),
                      type: type,
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
                ...customGoals.map((goal) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HabitCard(
                      title: goal.displayTitle(l10n),
                      type: HabitType.custom,
                      dayLabel: l10n.dayN(goal.currentDay),
                      configured: true,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HabitDetailScreen(goalId: goal.id),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
    );
  }

  Future<void> _openNewTopic(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final app = context.read<AppState>();
    final choice = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final unused = HabitTypeX.presets
            .where((t) => !app.selectedInterests.contains(t))
            .toList();
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.paddingOf(ctx).bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.newTopic,
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.newTopicHint,
                  style: TextStyle(color: AppTheme.muted(ctx)),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const HabitBadge(type: HabitType.custom, size: 44),
                  title: Text(l10n.createCustomTopic),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pop(ctx, 'custom'),
                ),
                if (unused.isNotEmpty) ...[
                  const Divider(),
                  Text(
                    l10n.pickBuiltInTopic,
                    style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...unused.map(
                    (t) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: HabitBadge(type: t, size: 44),
                      title: Text(t.title(l10n)),
                      onTap: () => Navigator.pop(ctx, t),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted || choice == null) return;

    if (choice == 'custom') {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const HabitSetupScreen(type: HabitType.custom),
        ),
      );
      return;
    }

    if (choice is HabitType) {
      await app.addInterest(choice);
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HabitSetupScreen(type: choice),
        ),
      );
    }
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.title,
    required this.type,
    required this.onTap,
    required this.configured,
    required this.dayLabel,
  });

  final String title;
  final HabitType type;
  final VoidCallback onTap;
  final bool configured;
  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.card(context),
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              HabitBadge(type: type),
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
                            ? AppTheme.brand(context)
                            : AppTheme.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppTheme.soft(context)),
            ],
          ),
        ),
      ),
    );
  }
}
