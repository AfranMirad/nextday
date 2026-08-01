import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../l10n/habit_l10n.dart';
import '../models/daily_entry.dart';
import '../models/habit_goal.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'habit_setup_screen.dart';

class HabitDetailScreen extends StatefulWidget {
  const HabitDetailScreen({super.key, required this.goalId});

  final String goalId;

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  DailyEntry? _today;
  List<DailyEntry> _history = [];
  bool _loading = true;
  String? _error;

  HabitGoal? _findGoal(AppState app) {
    for (final g in app.activeGoals) {
      if (g.id == widget.goalId) return g;
    }
    return null;
  }

  Future<void> _load() async {
    final app = context.read<AppState>();
    final goal = _findGoal(app);
    if (goal == null) {
      setState(() {
        _loading = false;
        _error = 'Not found';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final today = await app.ensureTodayEntry(goal);
      final history = await app.recentEntries(goal);
      if (!mounted) return;
      setState(() {
        _today = today;
        _history = history;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final l10n = AppLocalizations.of(context);
    final goal = _findGoal(app);

    return Scaffold(
      appBar: AppBar(
        title: Text(goal != null ? goal.type.title(l10n) : 'NextDay'),
        actions: [
          if (goal != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HabitSetupScreen(type: goal.type),
                  ),
                );
                await _load();
              },
            ),
        ],
      ),
      body: goal == null
          ? const Center(child: Text('—'))
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text(_error!))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsets.all(AppTheme.pagePadding),
                        children: [
                          _DayHero(
                            day: goal.currentDay,
                            typeTitle: goal.type.shortTitle(l10n),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: _today?.milestoneTitle ?? l10n.dayN(goal.currentDay),
                            child: Text(
                              _today?.milestoneBody ?? '',
                              style: const TextStyle(height: 1.45, fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _SectionCard(
                            title: l10n.motivation,
                            trailing: Text(
                              _sourceLabel(l10n, _today?.source),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSoft,
                              ),
                            ),
                            child: Text(
                              _today?.motivationText ?? '',
                              style: const TextStyle(
                                height: 1.45,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.recentDays,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._history.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface2,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${l10n.dayN(e.dayNumber)} · ${e.milestoneTitle ?? ''}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    if ((e.motivationText ?? '').isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        e.motivationText!,
                                        style: const TextStyle(
                                          color: AppTheme.textMuted,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(l10n.resetCounterConfirmTitle),
                                  content: Text(l10n.resetCounterConfirmBody),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text(l10n.cancel),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text(l10n.reset),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true && context.mounted) {
                                final fresh = await app.relapse(goal);
                                if (context.mounted) {
                                  await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          HabitDetailScreen(goalId: fresh.id),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.restart_alt),
                            label: Text(l10n.resetCounter),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.danger,
                              side: const BorderSide(color: AppTheme.danger),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.contentDisclaimer,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  String _sourceLabel(AppLocalizations l10n, String? source) {
    switch (source) {
      case 'hybrid':
        return l10n.sourceHybrid;
      case 'ai':
        return l10n.sourceAi;
      default:
        return l10n.sourceTemplate;
    }
  }
}

class _DayHero extends StatelessWidget {
  const _DayHero({required this.day, required this.typeTitle});

  final int day;
  final String typeTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D7377), Color(0xFF14919B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            typeTitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.dayN(day),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}