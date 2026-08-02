import 'package:flutter/material.dart';

class AppTheme {
  // Brand pastels from capsule logo
  static const Color coral = Color(0xFFE59A94);
  static const Color sand = Color(0xFFEBCB93);
  static const Color sage = Color(0xFF98B48D);
  static const Color sageDeep = Color(0xFF6F8F66);
  static const Color inkBrand = Color(0xFF3D4F45);

  static const Color primary = sageDeep;
  static const Color primaryHover = Color(0xFF5A7553);
  static const Color onPrimary = Color(0xFFF7FFF4);
  static const Color accent = coral;
  static const Color success = sage;
  static const Color danger = Color(0xFFB42318);
  static const Color warning = Color(0xFFB54708);

  static const Color bg = Color(0xFFFBF8F4);
  static const Color surface = Color(0xFFFFFDFB);
  static const Color surface2 = Color(0xFFF3EEE6);
  static const Color border = Color(0x1A3D4F45);
  static const Color text = Color(0xFF2A342F);
  static const Color textMuted = Color(0xFF5C6B63);
  static const Color textSoft = Color(0xFF7A8A82);

  static const Color bgDark = Color(0xFF141A17);
  static const Color surfaceDark = Color(0xFF1C2420);
  static const Color surface2Dark = Color(0xFF27312C);
  static const Color borderDark = Color(0x33FFFFFF);
  static const Color textDark = Color(0xFFF4F7F5);
  static const Color textMutedDark = Color(0xFFB0BDB6);
  static const Color textSoftDark = Color(0xFF8A9992);
  static const Color primaryDark = Color(0xFFA8C49A);

  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double pagePadding = 20;

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color scaffoldBg(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color card(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color cardAlt(BuildContext context) =>
      isDark(context) ? surface2Dark : surface2;

  static Color ink(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color muted(BuildContext context) =>
      isDark(context) ? textMutedDark : textMuted;

  static Color soft(BuildContext context) =>
      isDark(context) ? textSoftDark : textSoft;

  static Color brand(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static ThemeData light() => _build(
        brightness: Brightness.light,
        scaffold: bg,
        surface: surface,
        surfaceAlt: surface2,
        onSurface: text,
        onSurfaceVariant: textMuted,
        borderColor: border,
        brand: primary,
        onBrand: onPrimary,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        scaffold: bgDark,
        surface: surfaceDark,
        surfaceAlt: surface2Dark,
        onSurface: textDark,
        onSurfaceVariant: textMutedDark,
        borderColor: borderDark,
        brand: primaryDark,
        onBrand: onPrimary,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color scaffold,
    required Color surface,
    required Color surfaceAlt,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color borderColor,
    required Color brand,
    required Color onBrand,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brand,
        brightness: brightness,
        primary: brand,
        onPrimary: onBrand,
        secondary: coral,
        tertiary: sand,
        surface: surface,
      ),
      scaffoldBackgroundColor: scaffold,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: BorderSide(color: borderColor),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: brand,
        foregroundColor: onBrand,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brand,
          foregroundColor: onBrand,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brand,
          side: BorderSide(color: brand),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: brand, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceAlt,
        selectedColor: brand.withValues(alpha: 0.18),
        labelStyle: TextStyle(color: onSurface),
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dividerTheme: DividerThemeData(color: borderColor),
      listTileTheme: ListTileThemeData(
        iconColor: onSurfaceVariant,
        textColor: onSurface,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: brand,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          side: WidgetStatePropertyAll(BorderSide(color: borderColor)),
        ),
      ),
    );
  }
}