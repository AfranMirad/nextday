// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'NextDay';

  @override
  String get appTagline => 'Her gün bir adım daha güçlüsün';

  @override
  String get account => 'Hesabım';

  @override
  String get home => 'Ana sayfa';

  @override
  String get interests => 'İlgi alanları';

  @override
  String get save => 'Kaydet';

  @override
  String get start => 'Başla';

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Cihaz dili';

  @override
  String get languageTr => 'Türkçe';

  @override
  String get languageEn => 'İngilizce';

  @override
  String get profileSaved => 'Profil kaydedildi';

  @override
  String get displayName => 'Görünen ad';

  @override
  String get age => 'Yaş';

  @override
  String get gender => 'Cinsiyet';

  @override
  String get genderMale => 'Erkek';

  @override
  String get genderFemale => 'Kadın';

  @override
  String get genderOther => 'Diğer';

  @override
  String get genderPreferNot => 'Belirtmek istemiyorum';

  @override
  String get saveProfile => 'Profili kaydet';

  @override
  String get notSelected => 'Seçilmedi';

  @override
  String get localBackup => 'Yerel yedek al';

  @override
  String get localBackupHint => 'JSON dosyası olarak cihazına kaydeder';

  @override
  String get dailyReminder => 'Günlük hatırlatma';

  @override
  String get dailyReminderHint => 'Her sabah 09:00';

  @override
  String get removeAds => 'Reklamları kaldır';

  @override
  String get removeAdsHint => 'Tek seferlik — kalıcı reklamsız kullanım';

  @override
  String get adsRemoved => 'Reklamlar kaldırıldı';

  @override
  String get purchaseFailed => 'Satın alma başarısız';

  @override
  String get restorePurchases => 'Satın almaları geri yükle';

  @override
  String get aiMotivation => 'AI motivasyon';

  @override
  String get aiConfigured => 'Yapılandırıldı (proxy veya API anahtarı)';

  @override
  String get aiTemplateMode =>
      'Şablon modu — API anahtarı / proxy eklenince hibrit açılır';

  @override
  String get healthDisclaimerShort =>
      'Sağlık uyarıları: Bu uygulama tıbbi tavsiye vermez. Ciddi bağımlılık veya sağlık sorunlarında bir uzmana başvurun.';

  @override
  String get autoAccountHint =>
      'Uygulama açıldığında otomatik yerel hesap oluşturuldu. İstersen bilgilerini tamamla; cihaz değişince veri taşınmaz (v1).';

  @override
  String get whatInterestsYou => 'Nelerle ilgileniyorsun?';

  @override
  String get interestsHint =>
      'Seçtiklerin ana ekranda görünür. İstediğin zaman Hesabım’dan değiştirebilirsin.';

  @override
  String get activeJourneys => 'Aktif yolculukların';

  @override
  String get onlySelectedVisible => 'Sadece seçtiğin başlıklar burada görünür.';

  @override
  String get noGoalsYet => 'Henüz bir hedef seçmedin.';

  @override
  String get pickGoals => 'Hedef seç';

  @override
  String get completeSetup => 'Kurulumu tamamla';

  @override
  String dayN(int day) {
    return 'Gün $day';
  }

  @override
  String get motivation => 'Motivasyon';

  @override
  String get recentDays => 'Son günler';

  @override
  String get resetCounter => 'Tekrar yaptım / sayacı sıfırla';

  @override
  String get resetCounterConfirmTitle => 'Sayacı sıfırla?';

  @override
  String get resetCounterConfirmBody =>
      'Tekrar yaptığını kaydedeceğiz. Eski ilerleme arşivlenir, yeni bir gün 1 başlar.';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get reset => 'Sıfırla';

  @override
  String get contentDisclaimer =>
      'İçerikler genel bilgilendirme amaçlıdır; tıbbi tavsiye değildir.';

  @override
  String get importantNotice => 'Önemli bilgilendirme';

  @override
  String get disclaimerBody =>
      'Bu uygulama tıbbi teşhis, tedavi veya acil müdahale sunmaz. Günlük vücut değişimi ve motivasyon metinleri genel bilgilendirme amaçlıdır; kişiye özel tıbbi tavsiye yerine geçmez.\n\nBağımlılık, diyet veya sağlık durumunuz için bir sağlık profesyoneline danışın. Acil bir durumda yerel acil servisleri arayın.\n\nVerileriniz varsayılan olarak cihazınızda saklanır.';

  @override
  String get understoodContinue => 'Anladım, devam et';

  @override
  String setupTitle(String topic) {
    return '$topic kurulumu';
  }

  @override
  String get profileForAi => 'Profil bilgileri (kişiselleştirme için)';

  @override
  String get startDate => 'Başlangıç tarihi';

  @override
  String get saveAndStart => 'Kaydet ve başla';

  @override
  String get habitSmoking => 'Sigara bırakma';

  @override
  String get habitAlcohol => 'Alkol bırakma';

  @override
  String get habitDrugs => 'Uyuşturucu bırakma';

  @override
  String get habitMasturbation => 'Mastürbasyon bırakma';

  @override
  String get habitDiet => 'Diyet';

  @override
  String get habitSports => 'Spor';

  @override
  String get habitSmokingShort => 'Sigara';

  @override
  String get habitAlcoholShort => 'Alkol';

  @override
  String get habitDrugsShort => 'Uyuşturucu';

  @override
  String get habitMasturbationShort => 'Mastürbasyon';

  @override
  String get habitDietShort => 'Diyet';

  @override
  String get habitSportsShort => 'Spor';

  @override
  String startupFailed(String error) {
    return 'Başlatılamadı: $error';
  }

  @override
  String get sourceHybrid => 'AI + şablon';

  @override
  String get sourceAi => 'AI';

  @override
  String get sourceTemplate => 'Şablon';
}
