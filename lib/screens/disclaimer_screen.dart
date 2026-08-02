import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

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
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.card(context),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Text(
                      '${l10n.importantNotice}\n\n${l10n.disclaimerBody}',
                      style: TextStyle(
                        height: 1.45,
                        color: AppTheme.ink(context),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<AppState>().acceptDisclaimer(),
                child: Text(l10n.understoodContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}