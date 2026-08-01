import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/monetization_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');
  await initializeDateFormatting('en_US');
  final appState = AppState();
  final monetization = MonetizationService();
  await appState.init();
  await monetization.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: appState),
        ChangeNotifierProvider<MonetizationService>.value(value: monetization),
      ],
      child: const NextDayApp(),
    ),
  );
}