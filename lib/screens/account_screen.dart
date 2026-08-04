import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../l10n/habit_l10n.dart';
import '../services/backup_service.dart';
import '../services/monetization_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'onboarding_interests_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final TextEditingController _nameCtrl;
  DateTime? _birthDate;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _birthDate = user?.birthDate;
    _gender = user?.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      helpText: AppLocalizations.of(context).birthDate,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final mono = context.watch<MonetizationService>();
    final l10n = AppLocalizations.of(context);

    String langLabel;
    final code = app.localeOverride?.languageCode;
    if (code == 'tr') {
      langLabel = l10n.languageTr;
    } else if (code == 'en') {
      langLabel = l10n.languageEn;
    } else {
      langLabel = l10n.languageSystem;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.account)),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.pagePadding),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardAlt(context),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Text(
              l10n.autoAccountHint,
              style: TextStyle(color: AppTheme.muted(context), height: 1.4),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.appearance,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.brightness_auto, size: 18),
                label: Text(l10n.themeSystem),
                tooltip: l10n.themeSystemHint,
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined, size: 18),
                label: Text(l10n.themeLight),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined, size: 18),
                label: Text(l10n.themeDark),
              ),
            ],
            selected: {app.themeMode},
            onSelectionChanged: (set) {
              if (set.isEmpty) return;
              app.setThemeMode(set.first);
            },
          ),
          const SizedBox(height: 8),
          Text(
            l10n.themeSystemHint,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.soft(context),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(langLabel),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final choice = await showModalBottomSheet<String>(
                context: context,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(l10n.languageSystem),
                        onTap: () => Navigator.pop(ctx, 'system'),
                      ),
                      ListTile(
                        title: Text(l10n.languageTr),
                        onTap: () => Navigator.pop(ctx, 'tr'),
                      ),
                      ListTile(
                        title: Text(l10n.languageEn),
                        onTap: () => Navigator.pop(ctx, 'en'),
                      ),
                    ],
                  ),
                ),
              );
              if (choice == null) return;
              if (choice == 'system') {
                await app.setLocaleOverride(null);
              } else {
                await app.setLocaleOverride(Locale(choice));
              }
            },
          ),
          const Divider(),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.displayName),
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.birthDate),
            subtitle: Text(
              _birthDate != null
                  ? _formatDate(_birthDate!)
                  : l10n.birthDateHint,
            ),
            trailing: const Icon(Icons.calendar_today_outlined),
            onTap: _pickBirthDate,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _gender,
            decoration: InputDecoration(labelText: l10n.gender),
            items: [
              DropdownMenuItem(value: 'male', child: Text(l10n.genderMale)),
              DropdownMenuItem(value: 'female', child: Text(l10n.genderFemale)),
              DropdownMenuItem(value: 'other', child: Text(l10n.genderOther)),
              DropdownMenuItem(
                value: 'prefer_not',
                child: Text(l10n.genderPreferNot),
              ),
            ],
            onChanged: (v) => setState(() => _gender = v),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await app.updateProfile(
                displayName: _nameCtrl.text.trim().isEmpty
                    ? null
                    : _nameCtrl.text.trim(),
                birthDate: _birthDate,
                clearBirthDate: _birthDate == null,
                gender: _gender,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.profileSaved)),
                );
              }
            },
            child: Text(l10n.saveProfile),
          ),
          const SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.category_outlined),
            title: Text(l10n.interests),
            subtitle: Text(
              app.selectedInterests.isEmpty
                  ? l10n.notSelected
                  : app.selectedInterests
                      .map((e) => e.shortTitle(l10n))
                      .join(', '),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const OnboardingInterestsScreen(allowSkip: true),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              mono.adsRemoved ? Icons.verified : Icons.workspace_premium_outlined,
              color: AppTheme.brand(context),
            ),
            title: Text(mono.adsRemoved ? l10n.adsRemoved : l10n.removeAds),
            subtitle: Text(l10n.removeAdsHint),
            trailing: mono.purchasePending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : (mono.adsRemoved
                    ? null
                    : const Icon(Icons.chevron_right)),
            onTap: mono.adsRemoved
                ? null
                : () async {
                    await mono.buyRemoveAds();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          mono.adsRemoved
                              ? l10n.adsRemoved
                              : (mono.lastError ?? l10n.purchaseFailed),
                        ),
                      ),
                    );
                  },
          ),
          if (!mono.adsRemoved)
            TextButton(
              onPressed: () => mono.restore(),
              child: Text(l10n.restorePurchases),
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.backup_outlined),
            title: Text(l10n.localBackup),
            subtitle: Text(l10n.localBackupHint),
            onTap: () async {
              try {
                final result = await BackupService().exportToJson();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$e')),
                  );
                }
              }
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.dailyReminder),
            subtitle: Text(l10n.dailyReminderHint),
            value: app.notificationsEnabled,
            onChanged: (v) => app.setNotificationsEnabled(v),
          ),
          const Divider(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              AppConfig.hasAiConfigured
                  ? Icons.auto_awesome
                  : Icons.auto_awesome_outlined,
              color: AppTheme.brand(context),
            ),
            title: Text(l10n.aiMotivation),
            subtitle: Text(
              AppConfig.hasAiConfigured
                  ? l10n.aiConfigured
                  : l10n.aiTemplateMode,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.healthDisclaimerShort,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.soft(context),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}