# NextDay — Ads + Remove Ads

Apple/Google do not place ads for you. The app already includes:

- Google Mobile Ads (banner, bottom, not aggressive)
- One-time IAP: `nextday_remove_ads`

## What you do once (accounts)

1. Create [AdMob](https://admob.google.com) account (same Google as Play is fine).
2. Add Android app `com.rizaaksu.nextday` and iOS app `com.rizaaksu.nextday`.
3. Create one **Banner** ad unit per platform.
4. Replace test IDs in:
   - `android/app/src/main/AndroidManifest.xml` → `APPLICATION_ID`
   - `ios/Runner/Info.plist` → `GADApplicationIdentifier`
   - Or pass at build time:
     ```
     --dart-define=ADMOB_ANDROID_APP_ID=ca-app-pub-xxxx~yyyy
     --dart-define=ADMOB_IOS_APP_ID=ca-app-pub-xxxx~yyyy
     --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-xxxx/yyyy
     --dart-define=ADMOB_BANNER_IOS=ca-app-pub-xxxx/yyyy
     ```
5. Play Console + App Store Connect: create non-consumable product id **`nextday_remove_ads`**.
6. Until products exist, debug builds can unlock ads-free locally (dev fallback).

Default IDs in the project are **Google official test IDs** (safe for development).