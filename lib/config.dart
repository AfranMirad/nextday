import 'package:flutter/foundation.dart';

class AppConfig {
  static const String appName = 'NextDay';
  static const String appTaglineKey = 'appTagline';

  // --- AI ---
  static const String aiProxyUrl = String.fromEnvironment(
    'AI_PROXY_URL',
    defaultValue: '',
  );
  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );
  static const String openAiModel = String.fromEnvironment(
    'OPENAI_MODEL',
    defaultValue: 'gpt-4o-mini',
  );
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  static const String geminiModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.0-flash',
  );
  static const int aiHistoryDays = 7;

  static bool get hasAiConfigured =>
      aiProxyUrl.isNotEmpty ||
      openAiApiKey.isNotEmpty ||
      geminiApiKey.isNotEmpty;

  // --- Ads (Google sample/test IDs by default; replace via --dart-define for prod) ---
  static const String admobAndroidAppId = String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
    defaultValue: 'ca-app-pub-3940256099942544~3347511713',
  );
  static const String admobIosAppId = String.fromEnvironment(
    'ADMOB_IOS_APP_ID',
    defaultValue: 'ca-app-pub-3940256099942544~1458002511',
  );
  static const String bannerAdUnitAndroid = String.fromEnvironment(
    'ADMOB_BANNER_ANDROID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );
  static const String bannerAdUnitIos = String.fromEnvironment(
    'ADMOB_BANNER_IOS',
    defaultValue: 'ca-app-pub-3940256099942544/2934735716',
  );

  static String get bannerAdUnitId {
    if (kIsWeb) return bannerAdUnitAndroid;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return bannerAdUnitIos;
      default:
        return bannerAdUnitAndroid;
    }
  }

  static String get admobAppId {
    if (kIsWeb) return admobAndroidAppId;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return admobIosAppId;
      default:
        return admobAndroidAppId;
    }
  }

  /// Play Console / App Store Connect product id
  static const String removeAdsProductId = String.fromEnvironment(
    'IAP_REMOVE_ADS_ID',
    defaultValue: 'nextday_remove_ads',
  );

  static bool get adsEnabled => !kIsWeb;
}