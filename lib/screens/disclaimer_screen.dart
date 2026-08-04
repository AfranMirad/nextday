import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _aiConsent = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  Image.asset(
                    'assets/brand/nextday_icon.png',
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppConfig.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.brand(context),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.appTagline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.muted(context),
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoCard(
                        title: l10n.aiConsentTitle,
                        body: l10n.aiConsentBody,
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: l10n.importantNotice,
                        body: l10n.disclaimerBody,
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _aiConsent,
                        onChanged: (v) =>
                            setState(() => _aiConsent = v ?? false),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.aiConsentCheckbox,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: AppTheme.ink(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _aiConsent
                    ? () => context.read<AppState>().acceptDisclaimer()
                    : null,
                child: Text(l10n.understoodContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              height: 1.45,
              color: AppTheme.ink(context),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
