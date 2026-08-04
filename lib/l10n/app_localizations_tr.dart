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
  String get appearance => 'Görünüm';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeSystemHint => 'Cihazın açık/koyu ayarını takip eder';

  @override
  String get profileSaved => 'Profil kaydedildi';

  @override
  String get displayName => 'Görünen ad';

  @override
  String get age => 'Yaş';

  @override
  String get birthDate => 'Doğum tarihi';

  @override
  String get birthDateHint => 'İçeriği kişiselleştirmek için kullanılır';

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
  String get aiConsentTitle => 'Yapay zeka ile günlük içerik';

  @override
  String get aiConsentBody =>
      'NextDay, seçtiğin alışkanlık yolculuğuna göre her gün kısa tavsiye ve motivasyon sözleri üretebilir. Bu metinler yapay zeka desteğiyle belirlenir; tıbbi teşhis veya tedavi yerine geçmez.\n\nİsim, soyisim ve seni doğrudan tanımlayan kişisel verilerin yapay zekaya gönderilmez. Yalnızca alışkanlık ilerlemen ve isteğe bağlı profil özetin (ör. yaş aralığı / cinsiyet tercihin) kişiselleştirme için kullanılabilir. Verilerin varsayılan olarak cihazında kalır.';

  @override
  String get aiConsentCheckbox =>
      'Yapay zeka ile günlük tavsiye ve motivasyon sözlerinin bu şekilde üretilmesini, isim-soyisim ve kişisel verilerimin bu kapsamda korunmasını onaylıyorum.';

  @override
  String get understoodContinue => 'Onayla ve devam et';

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
  String get habitCustom => 'Özel konu';

  @override
  String get habitCustomShort => 'Özel';

  @override
  String get newTopic => 'Yeni';

  @override
  String get newTopicHint => 'Hazır bir alışkanlık seç veya kendin oluştur';

  @override
  String get createCustomTopic => 'Kendi konunu oluştur';

  @override
  String get customTopicTitle => 'Konu adı';

  @override
  String get customTopicHint => 'Örn. Şekeri bırak, Sabah meditasyonu';

  @override
  String get pickBuiltInTopic => 'Konu seç';

  @override
  String get startCustom => 'Konuyu başlat';

  @override
  String get catAddiction => 'Bağımlılık bırakma';

  @override
  String get catNutritionQuit => 'Beslenme & sağlık (bırakma)';

  @override
  String get catDigitalDetox => 'Teknoloji & dijital detoks';

  @override
  String get catMentalQuit => 'Zihinsel & psikolojik alışkanlıklar';

  @override
  String get catHealthStart => 'Sağlık & spor (başlama)';

  @override
  String get catGrowthStart => 'Kişisel gelişim & zihin';

  @override
  String get catLifestyleStart => 'Yaşam tarzı & düzen';

  @override
  String get sectionQuitHint =>
      'Bırakmak veya azaltmak istediğin alışkanlıklar';

  @override
  String get sectionStartHint =>
      'Başlamak ve sürdürmek istediğin alışkanlıklar';

  @override
  String get searchTopics => 'Konu ara';

  @override
  String selectedCount(int count) {
    return '$count seçili';
  }

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
