import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'l10n/app_localizations.dart';
import 'screens/disclaimer_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_interests_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class NextDayApp extends StatelessWidget {
  const NextDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: app.themeMode,
      locale: app.localeOverride,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (deviceLocale, supported) {
        if (app.localeOverride != null) return app.localeOverride;
        if (deviceLocale == null) return const Locale('en');
        for (final l in supported) {
          if (l.languageCode == deviceLocale.languageCode) return l;
        }
        return const Locale('en');
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const _AppGate(),
    );
  }
}

class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Consumer<AppState>(
      builder: (context, app, _) {
        if (!app.ready) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }
        if (app.error != null && app.user == null) {
          return Scaffold(
            body: Center(child: Text(l10n.startupFailed(app.error!))),
          );
        }
        final user = app.user!;
        if (!user.disclaimerAccepted) {
          return const DisclaimerScreen();
        }
        if (!user.onboardingDone) {
          return const OnboardingInterestsScreen();
        }
        return const HomeShell();
      },
    );
  }
}