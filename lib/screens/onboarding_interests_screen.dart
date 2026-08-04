import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../l10n/habit_l10n.dart';
import '../models/habit_catalog.dart';
import '../models/habit_type.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/habit_badge.dart';

class OnboardingInterestsScreen extends StatefulWidget {
  const OnboardingInterestsScreen({super.key, this.allowSkip = false});

  final bool allowSkip;

  @override
  State<OnboardingInterestsScreen> createState() =>
      _OnboardingInterestsScreenState();
}

class _OnboardingInterestsScreenState extends State<OnboardingInterestsScreen> {
  late Set<HabitType> _selected;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.of(context.read<AppState>().selectedInterests);
  }

  bool _matches(HabitType t, AppLocalizations l10n) {
    if (_query.trim().isEmpty) return true;
    final q = _query.trim().toLowerCase();
    return t.title(l10n).toLowerCase().contains(q) ||
        t.shortTitle(l10n).toLowerCase().contains(q);
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
                const SizedBox(height: 8),
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
                const SizedBox(height: 12),
              ],
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchTopics,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectedCount(_selected.length),
                style: TextStyle(
                  color: AppTheme.soft(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    for (final category in HabitCatalog.orderedCategories)
                      _CategoryBlock(
                        category: category,
                        selected: _selected,
                        matches: (t) => _matches(t, l10n),
                        onToggle: (t) {
                          setState(() {
                            if (_selected.contains(t)) {
                              _selected.remove(t);
                            } else {
                              _selected.add(t);
                            }
                          });
                        },
                      ),
                  ],
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

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.category,
    required this.selected,
    required this.matches,
    required this.onToggle,
  });

  final HabitCategory category;
  final Set<HabitType> selected;
  final bool Function(HabitType) matches;
  final ValueChanged<HabitType> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = HabitType.presetsIn(category).where(matches).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    final selectedInCat = items.where(selected.contains).length;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: selectedInCat > 0 ||
            category == HabitCategory.addiction ||
            category == HabitCategory.nutritionQuit,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          category.title(l10n),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        subtitle: Text(
          '${category.sectionHint(l10n)} · $selectedInCat/${items.length}',
          style: TextStyle(color: AppTheme.soft(context), fontSize: 12),
        ),
        children: [
          for (final t in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _TopicTile(
                type: t,
                selected: selected.contains(t),
                onTap: () => onToggle(t),
              ),
            ),
        ],
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final HabitType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: selected
          ? type.badgeColor.withValues(alpha: 0.18)
          : AppTheme.card(context),
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: selected
                  ? type.badgeColor
                  : Theme.of(context).dividerColor,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              HabitBadge(type: type, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  type.title(l10n),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected
                    ? AppTheme.brand(context)
                    : AppTheme.soft(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
