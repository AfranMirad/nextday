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
  late final TextEditingController _ageCtrl;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().user;
    _nameCtrl = TextEditingController(text: user?.displayName ?? '');
    _ageCtrl = TextEditingController(
      text: user?.age != null ? '${user!.age}' : '',
    );
    _gender = user?.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

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
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Text(
              l10n.autoAccountHint,
              style: const TextStyle(color: AppTheme.textMuted, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),
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
          TextField(
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.age),
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
                age: int.tryParse(_ageCtrl.text.trim()),
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
              color: AppTheme.primary,
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
              color: AppTheme.primary,
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
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSoft,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}