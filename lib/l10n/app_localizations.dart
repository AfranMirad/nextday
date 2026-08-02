import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NextDay'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'One more day stronger'**
  String get appTagline;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get languageSystem;

  /// No description provided for @languageTr.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTr;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystemHint.
  ///
  /// In en, this message translates to:
  /// **'Match device light/dark setting'**
  String get themeSystemHint;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @genderPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get genderPreferNot;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @localBackup.
  ///
  /// In en, this message translates to:
  /// **'Local backup'**
  String get localBackup;

  /// No description provided for @localBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Saves a JSON file to your device'**
  String get localBackupHint;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderHint.
  ///
  /// In en, this message translates to:
  /// **'Every morning at 09:00'**
  String get dailyReminderHint;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get removeAds;

  /// No description provided for @removeAdsHint.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase — ad-free forever'**
  String get removeAdsHint;

  /// No description provided for @adsRemoved.
  ///
  /// In en, this message translates to:
  /// **'Ads removed'**
  String get adsRemoved;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @aiMotivation.
  ///
  /// In en, this message translates to:
  /// **'AI motivation'**
  String get aiMotivation;

  /// No description provided for @aiConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured (proxy or API key)'**
  String get aiConfigured;

  /// No description provided for @aiTemplateMode.
  ///
  /// In en, this message translates to:
  /// **'Template mode — enable hybrid with API key / proxy'**
  String get aiTemplateMode;

  /// No description provided for @healthDisclaimerShort.
  ///
  /// In en, this message translates to:
  /// **'Health notice: This app does not provide medical advice. Seek a professional for serious addiction or health issues.'**
  String get healthDisclaimerShort;

  /// No description provided for @autoAccountHint.
  ///
  /// In en, this message translates to:
  /// **'A local account was created automatically. Complete your profile anytime; data stays on this device (v1).'**
  String get autoAccountHint;

  /// No description provided for @whatInterestsYou.
  ///
  /// In en, this message translates to:
  /// **'What are you working on?'**
  String get whatInterestsYou;

  /// No description provided for @interestsHint.
  ///
  /// In en, this message translates to:
  /// **'Only selected topics appear on Home. You can change them later in Account.'**
  String get interestsHint;

  /// No description provided for @activeJourneys.
  ///
  /// In en, this message translates to:
  /// **'Your active journeys'**
  String get activeJourneys;

  /// No description provided for @onlySelectedVisible.
  ///
  /// In en, this message translates to:
  /// **'Only the topics you selected are shown here.'**
  String get onlySelectedVisible;

  /// No description provided for @noGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'You have not selected a goal yet.'**
  String get noGoalsYet;

  /// No description provided for @pickGoals.
  ///
  /// In en, this message translates to:
  /// **'Pick goals'**
  String get pickGoals;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete setup'**
  String get completeSetup;

  /// No description provided for @dayN.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayN(int day);

  /// No description provided for @motivation.
  ///
  /// In en, this message translates to:
  /// **'Motivation'**
  String get motivation;

  /// No description provided for @recentDays.
  ///
  /// In en, this message translates to:
  /// **'Recent days'**
  String get recentDays;

  /// No description provided for @resetCounter.
  ///
  /// In en, this message translates to:
  /// **'I slipped / reset counter'**
  String get resetCounter;

  /// No description provided for @resetCounterConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset the counter?'**
  String get resetCounterConfirmTitle;

  /// No description provided for @resetCounterConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'We will archive this streak and start again at Day 1.'**
  String get resetCounterConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @contentDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Content is for general information only and is not medical advice.'**
  String get contentDisclaimer;

  /// No description provided for @importantNotice.
  ///
  /// In en, this message translates to:
  /// **'Important notice'**
  String get importantNotice;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'This app does not provide medical diagnosis, treatment, or emergency care. Daily body-change and motivation texts are general information; they are not personalized medical advice.\n\nFor addiction, diet, or health conditions, consult a professional. In an emergency, call local emergency services.\n\nYour data is stored on your device by default.'**
  String get disclaimerBody;

  /// No description provided for @understoodContinue.
  ///
  /// In en, this message translates to:
  /// **'I understand, continue'**
  String get understoodContinue;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'{topic} setup'**
  String setupTitle(String topic);

  /// No description provided for @profileForAi.
  ///
  /// In en, this message translates to:
  /// **'Profile (for personalization)'**
  String get profileForAi;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @saveAndStart.
  ///
  /// In en, this message translates to:
  /// **'Save and start'**
  String get saveAndStart;

  /// No description provided for @habitSmoking.
  ///
  /// In en, this message translates to:
  /// **'Quit smoking'**
  String get habitSmoking;

  /// No description provided for @habitAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Quit alcohol'**
  String get habitAlcohol;

  /// No description provided for @habitDrugs.
  ///
  /// In en, this message translates to:
  /// **'Quit drugs'**
  String get habitDrugs;

  /// No description provided for @habitMasturbation.
  ///
  /// In en, this message translates to:
  /// **'Quit masturbation'**
  String get habitMasturbation;

  /// No description provided for @habitDiet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get habitDiet;

  /// No description provided for @habitSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get habitSports;

  /// No description provided for @habitSmokingShort.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get habitSmokingShort;

  /// No description provided for @habitAlcoholShort.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get habitAlcoholShort;

  /// No description provided for @habitDrugsShort.
  ///
  /// In en, this message translates to:
  /// **'Drugs'**
  String get habitDrugsShort;

  /// No description provided for @habitMasturbationShort.
  ///
  /// In en, this message translates to:
  /// **'Masturbation'**
  String get habitMasturbationShort;

  /// No description provided for @habitDietShort.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get habitDietShort;

  /// No description provided for @habitSportsShort.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get habitSportsShort;

  /// No description provided for @habitCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom topic'**
  String get habitCustom;

  /// No description provided for @habitCustomShort.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get habitCustomShort;

  /// No description provided for @newTopic.
  ///
  /// In en, this message translates to:
  /// **'New topic'**
  String get newTopic;

  /// No description provided for @newTopicHint.
  ///
  /// In en, this message translates to:
  /// **'Start a built-in habit or create your own'**
  String get newTopicHint;

  /// No description provided for @createCustomTopic.
  ///
  /// In en, this message translates to:
  /// **'Create my own topic'**
  String get createCustomTopic;

  /// No description provided for @customTopicTitle.
  ///
  /// In en, this message translates to:
  /// **'Topic name'**
  String get customTopicTitle;

  /// No description provided for @customTopicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Quit sugar, Morning meditation'**
  String get customTopicHint;

  /// No description provided for @pickBuiltInTopic.
  ///
  /// In en, this message translates to:
  /// **'Choose a topic'**
  String get pickBuiltInTopic;

  /// No description provided for @startCustom.
  ///
  /// In en, this message translates to:
  /// **'Start topic'**
  String get startCustom;

  /// No description provided for @startupFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start: {error}'**
  String startupFailed(String error);

  /// No description provided for @sourceHybrid.
  ///
  /// In en, this message translates to:
  /// **'AI + template'**
  String get sourceHybrid;

  /// No description provided for @sourceAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get sourceAi;

  /// No description provided for @sourceTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get sourceTemplate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
