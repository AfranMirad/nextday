// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'NextDay';

  @override
  String get appTagline => 'One more day stronger';

  @override
  String get account => 'Account';

  @override
  String get home => 'Home';

  @override
  String get interests => 'Interests';

  @override
  String get save => 'Save';

  @override
  String get start => 'Start';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get languageTr => 'Turkish';

  @override
  String get languageEn => 'English';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystemHint => 'Match device light/dark setting';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get displayName => 'Display name';

  @override
  String get age => 'Age';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get birthDateHint => 'Used to personalize content';

  @override
  String get gender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get genderPreferNot => 'Prefer not to say';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get notSelected => 'Not selected';

  @override
  String get localBackup => 'Local backup';

  @override
  String get localBackupHint => 'Saves a JSON file to your device';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderHint => 'Every morning at 09:00';

  @override
  String get removeAds => 'Remove ads';

  @override
  String get removeAdsHint => 'One-time purchase — ad-free forever';

  @override
  String get adsRemoved => 'Ads removed';

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get aiMotivation => 'AI motivation';

  @override
  String get aiConfigured => 'Configured (proxy or API key)';

  @override
  String get aiTemplateMode =>
      'Template mode — enable hybrid with API key / proxy';

  @override
  String get healthDisclaimerShort =>
      'Health notice: This app does not provide medical advice. Seek a professional for serious addiction or health issues.';

  @override
  String get autoAccountHint =>
      'A local account was created automatically. Complete your profile anytime; data stays on this device (v1).';

  @override
  String get whatInterestsYou => 'What are you working on?';

  @override
  String get interestsHint =>
      'Only selected topics appear on Home. You can change them later in Account.';

  @override
  String get activeJourneys => 'Your active journeys';

  @override
  String get onlySelectedVisible =>
      'Only the topics you selected are shown here.';

  @override
  String get noGoalsYet => 'You have not selected a goal yet.';

  @override
  String get pickGoals => 'Pick goals';

  @override
  String get completeSetup => 'Complete setup';

  @override
  String dayN(int day) {
    return 'Day $day';
  }

  @override
  String get motivation => 'Motivation';

  @override
  String get recentDays => 'Recent days';

  @override
  String get resetCounter => 'I slipped / reset counter';

  @override
  String get resetCounterConfirmTitle => 'Reset the counter?';

  @override
  String get resetCounterConfirmBody =>
      'We will archive this streak and start again at Day 1.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get contentDisclaimer =>
      'Content is for general information only and is not medical advice.';

  @override
  String get importantNotice => 'Important notice';

  @override
  String get disclaimerBody =>
      'This app does not provide medical diagnosis, treatment, or emergency care. Daily body-change and motivation texts are general information; they are not personalized medical advice.\n\nFor addiction, diet, or health conditions, consult a professional. In an emergency, call local emergency services.\n\nYour data is stored on your device by default.';

  @override
  String get aiConsentTitle => 'Daily content with AI';

  @override
  String get aiConsentBody =>
      'NextDay can generate short daily tips and motivational lines for the habit journey you choose. These texts may be produced with AI support and are not medical diagnosis or treatment.\n\nYour first name, last name, and directly identifying personal data are not sent to AI. Only your habit progress and optional profile summary (e.g. age range / gender preference) may be used for personalization. Your data stays on your device by default.';

  @override
  String get aiConsentCheckbox =>
      'I agree that daily tips and motivation may be generated with AI as described, and that my name and personal data are protected in this scope.';

  @override
  String get understoodContinue => 'Agree and continue';

  @override
  String setupTitle(String topic) {
    return '$topic setup';
  }

  @override
  String get profileForAi => 'Profile (for personalization)';

  @override
  String get startDate => 'Start date';

  @override
  String get saveAndStart => 'Save and start';

  @override
  String get habitSmoking => 'Quit smoking';

  @override
  String get habitAlcohol => 'Quit alcohol';

  @override
  String get habitDrugs => 'Quit drugs';

  @override
  String get habitMasturbation => 'Quit masturbation';

  @override
  String get habitDiet => 'Diet';

  @override
  String get habitSports => 'Sports';

  @override
  String get habitSmokingShort => 'Smoking';

  @override
  String get habitAlcoholShort => 'Alcohol';

  @override
  String get habitDrugsShort => 'Drugs';

  @override
  String get habitMasturbationShort => 'Masturbation';

  @override
  String get habitDietShort => 'Diet';

  @override
  String get habitSportsShort => 'Sports';

  @override
  String get habitCustom => 'Custom topic';

  @override
  String get habitCustomShort => 'Custom';

  @override
  String get newTopic => 'New';

  @override
  String get newTopicHint => 'Start a built-in habit or create your own';

  @override
  String get createCustomTopic => 'Create my own topic';

  @override
  String get customTopicTitle => 'Topic name';

  @override
  String get customTopicHint => 'e.g. Quit sugar, Morning meditation';

  @override
  String get pickBuiltInTopic => 'Choose a topic';

  @override
  String get startCustom => 'Start topic';

  @override
  String get catAddiction => 'Addiction quitting';

  @override
  String get catNutritionQuit => 'Nutrition & health (quit)';

  @override
  String get catDigitalDetox => 'Technology & digital detox';

  @override
  String get catMentalQuit => 'Mental & psychological habits';

  @override
  String get catHealthStart => 'Health & sports (start)';

  @override
  String get catGrowthStart => 'Personal growth & mind';

  @override
  String get catLifestyleStart => 'Lifestyle & organization';

  @override
  String get sectionQuitHint => 'Habits to quit or reduce';

  @override
  String get sectionStartHint => 'Habits to start and sustain';

  @override
  String get searchTopics => 'Search topics';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String startupFailed(String error) {
    return 'Could not start: $error';
  }

  @override
  String get sourceHybrid => 'AI + template';

  @override
  String get sourceAi => 'AI';

  @override
  String get sourceTemplate => 'Template';
}
