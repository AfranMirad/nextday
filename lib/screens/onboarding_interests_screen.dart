import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/habit_badge.dart';
import '../l10n/app_localizations.dart';
import '../l10n/habit_l10n.dart';
import '../models/habit_type.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class OnboardingInterestsScreen extends StatefulWidget {
  const OnboardingInterestsScreen({super.key, this.allowSkip = false});

  final bool allowSkip;

  @override
  State<OnboardingInterestsScreen> createState() =>
      _OnboardingInterestsScreenState();
}

class _OnboardingInterestsScreenState extends State<OnboardingInterestsScreen> {
  late Set<HabitType> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.of(context.read<AppState>().selectedInterests);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: widget.allowSkip
          ? AppBar(title: Text(l10n.interests))
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!widget.allowSkip) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.whatInterestsYou,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.interestsHint,
                  style: TextStyle(color: AppTheme.muted(context), height: 1.4),
                ),
                const SizedBox(height: 20),
              ],
              Expanded(
                child: ListView(
                  children: HabitTypeX.presets.map((t) {
                    final on = _selected.contains(t);
                    final brand = AppTheme.brand(context);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: on
                            ? t.badgeColor.withValues(alpha: 0.18)
                            : AppTheme.card(context),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMd),
                          onTap: () {
                            setState(() {
                              if (on) {
                                _selected.remove(t);
                              } else {
                                _selected.add(t);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMd),
                              border: Border.all(
                                color: on
                                    ? t.badgeColor
                                    : Theme.of(context).dividerColor,
                                width: on ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                HabitBadge(type: t, size: 44),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    t.title(l10n),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Icon(
                                  on
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: on
                                      ? brand
                                      : AppTheme.soft(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: _selected.isEmpty
                    ? null
                    : () async {
                        final app = context.read<AppState>();
                        if (widget.allowSkip) {
                          await app.updateInterests(_selected);
                          if (context.mounted) Navigator.pop(context);
                        } else {
                          await app.completeOnboarding(_selected);
                        }
                      },
                child: Text(widget.allowSkip ? l10n.save : l10n.start),
              ),
            ],
          ),
        ),
      ),
    );
  }
}