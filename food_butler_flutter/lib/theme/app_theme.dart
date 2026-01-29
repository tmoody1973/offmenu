import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Off Menu app theme configuration.
///
/// Design Philosophy: Editorial, magazine-quality inspired by Eater.com.
/// Bold typography, structured layouts with borders and boxes.
///
/// Typography:
/// - DM Sans: Geometric sans-serif for headlines and UI (similar to Degular)
/// - Literata: Elegant serif for body text and article content
/// - Strong typographic hierarchy with clear visual weight
///
/// Color Palette:
/// - Deep charcoal backgrounds (like a dimly-lit bar)
/// - Warm cream for text
/// - Burnt orange accent (the sear on a steak)
/// - Aged brass for secondary accents (like vintage fixtures)
/// - Rich photography that pops against dark backgrounds
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // COLOR PALETTE - Warm, analog, editorial
  // ═══════════════════════════════════════════════════════════════════════════

  /// Deep charcoal - primary background (like a dimly-lit bar)
  static const Color charcoal = Color(0xFF1A1A1A);

  /// Slightly lighter charcoal for cards/surfaces
  static const Color charcoalLight = Color(0xFF242424);

  /// Warm cream - primary text color
  static const Color cream = Color(0xFFF5F0E6);

  /// Muted cream for secondary text
  static const Color creamMuted = Color(0xFFA89F91);

  /// Burnt orange - accent color (the sear on a steak)
  static const Color burntOrange = Color(0xFFE85A3D);

  /// Aged brass - secondary accent (like vintage fixtures)
  static const Color agedBrass = Color(0xFFC9A962);

  /// Deep burgundy for special accents (Michelin red)
  static const Color burgundy = Color(0xFF8B0000);

  /// Success - deep sage green (booked status)
  static const Color successColor = Color(0xFF4A7C59);

  /// Error - warm red
  static const Color errorColor = Color(0xFFB54A4A);

  /// Warning - amber
  static const Color warningColor = Color(0xFFD4A84B);

  // Award badge colors
  /// James Beard - old gold
  static const Color jamesBeardGold = Color(0xFFB8860B);

  /// Michelin - deep burgundy
  static const Color michelinRed = Color(0xFF8B0000);

  /// Bib Gourmand - soft red
  static const Color bibGourmand = Color(0xFFCD5C5C);

  // Legacy colors for compatibility
  static const Color primaryColor = burntOrange;
  static const Color secondaryColor = burgundy;
  static const Color backgroundColor = charcoal;
  static const Color surfaceColor = charcoalLight;
  static const Color orangeLight = agedBrass; // Alias for compatibility

  // ═══════════════════════════════════════════════════════════════════════════
  // BREAKPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPOGRAPHY - Eater.com inspired editorial style
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bold geometric sans-serif for headlines (like Degular)
  /// Used for: Section headers, restaurant names, UI elements
  static TextStyle get headlineSans => GoogleFonts.dmSans(
        fontWeight: FontWeight.w700,
        color: cream,
      );

  /// Display headlines - extra bold for hero sections
  static TextStyle get displaySans => GoogleFonts.dmSans(
        fontWeight: FontWeight.w800,
        color: cream,
      );

  /// Editorial serif for article content and stories (Literata)
  /// Used for: Body text, descriptions, long-form content
  static TextStyle get headlineSerif => GoogleFonts.literata(
        fontWeight: FontWeight.w600,
        color: cream,
      );

  /// Body serif for article text - elegant and readable
  static TextStyle get bodySerif => GoogleFonts.literata(
        fontWeight: FontWeight.w400,
        color: cream,
        height: 1.6,
      );

  /// The Butler's voice - knowing, warm, slightly irreverent (Literata Italic)
  static TextStyle get butlerVoice => GoogleFonts.literata(
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        color: cream,
      );

  /// Clean sans-serif for UI text (DM Sans)
  static TextStyle get bodySans => GoogleFonts.dmSans(
        fontWeight: FontWeight.w400,
        color: cream,
      );

  /// Section headers - bold sans (DM Sans Bold)
  static TextStyle get sectionHeader => GoogleFonts.dmSans(
        fontWeight: FontWeight.w700,
        color: cream,
      );

  /// Labels and meta info - all caps, tracked (DM Sans Medium)
  static TextStyle get labelSans => GoogleFonts.dmSans(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: creamMuted,
      );

  /// Uppercase labels with strong tracking (Eater style)
  static TextStyle get labelCaps => GoogleFonts.dmSans(
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: creamMuted,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER & BOX STYLES - Eater.com inspired
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard border color for boxes
  static Color get borderColor => cream.withAlpha(40);

  /// Strong border color for emphasis
  static Color get borderStrong => cream.withAlpha(80);

  /// Accent border color
  static Color get borderAccent => burntOrange;

  /// Standard box border
  static BoxBorder get boxBorder => Border.all(color: borderColor, width: 1);

  /// Strong box border (2px)
  static BoxBorder get boxBorderStrong => Border.all(color: borderStrong, width: 2);

  /// Accent box border
  static BoxBorder get boxBorderAccent => Border.all(color: borderAccent, width: 2);

  /// Top border only (for list items)
  static BoxBorder get topBorder => Border(top: BorderSide(color: borderColor, width: 1));

  /// Bottom border only (for list items)
  static BoxBorder get bottomBorder => Border(bottom: BorderSide(color: borderColor, width: 1));

  /// Standard box decoration with border
  static BoxDecoration boxDecoration({
    Color? color,
    double borderRadius = 0,
    bool strongBorder = false,
    bool accentBorder = false,
  }) {
    return BoxDecoration(
      color: color ?? Colors.transparent,
      border: accentBorder
          ? boxBorderAccent
          : strongBorder
              ? boxBorderStrong
              : boxBorder,
      borderRadius: borderRadius > 0 ? BorderRadius.circular(borderRadius) : null,
    );
  }

  /// Card with bordered box style (Eater-style content box)
  static BoxDecoration cardBoxDecoration({
    Color? backgroundColor,
    bool strongBorder = false,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? charcoalLight,
      border: strongBorder ? boxBorderStrong : boxBorder,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME (Primary - the "dimly-lit bar" experience)
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: charcoal,
      colorScheme: const ColorScheme.dark(
        primary: burntOrange,
        onPrimary: cream,
        secondary: burgundy,
        onSecondary: cream,
        surface: charcoalLight,
        onSurface: cream,
        error: errorColor,
        onError: cream,
      ),
      textTheme: TextTheme(
        // Display - Big editorial headlines (DM Sans Bold - like Degular)
        displayLarge: displaySans.copyWith(fontSize: 48),
        displayMedium: displaySans.copyWith(fontSize: 36),
        displaySmall: displaySans.copyWith(fontSize: 28),
        // Headlines - Section titles, restaurant names (DM Sans Bold)
        headlineLarge: headlineSans.copyWith(fontSize: 32),
        headlineMedium: headlineSans.copyWith(fontSize: 24),
        headlineSmall: headlineSans.copyWith(fontSize: 20),
        // Titles - Content headers (DM Sans SemiBold)
        titleLarge: sectionHeader.copyWith(fontSize: 20),
        titleMedium: sectionHeader.copyWith(fontSize: 18),
        titleSmall: sectionHeader.copyWith(fontSize: 16),
        // Body - Article content, descriptions (Literata - serif)
        bodyLarge: bodySerif.copyWith(fontSize: 17),
        bodyMedium: bodySerif.copyWith(fontSize: 15),
        bodySmall: bodySerif.copyWith(fontSize: 14, color: creamMuted),
        // Labels - Meta info, tags (DM Sans - all caps style)
        labelLarge: labelSans.copyWith(fontSize: 14),
        labelMedium: labelSans.copyWith(fontSize: 12),
        labelSmall: labelCaps.copyWith(fontSize: 11),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: charcoal,
        foregroundColor: cream,
        titleTextStyle: headlineSans.copyWith(fontSize: 20),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: charcoalLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Sharp corners like Eater
          side: BorderSide(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: burntOrange,
          foregroundColor: cream,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: bodySans.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cream,
          side: const BorderSide(color: creamMuted),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: burntOrange,
          textStyle: bodySans.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: charcoalLight,
        hintStyle: bodySans.copyWith(color: creamMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cream.withAlpha(30)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: burntOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: charcoalLight,
        labelStyle: labelSans.copyWith(fontSize: 12, color: cream),
        side: BorderSide(color: cream.withAlpha(30)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: cream.withAlpha(20),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: charcoalLight,
        contentTextStyle: bodySans.copyWith(color: cream),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: charcoal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: charcoalLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      iconTheme: const IconThemeData(color: cream),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: burntOrange,
      ),
    );
  }

  // Keep lightTheme for compatibility but redirect to dark
  static ThemeData get lightTheme => darkTheme;

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(32);
    }
  }

  static double responsiveHorizontalPadding(BuildContext context) {
    if (isMobile(context)) return 16;
    if (isTablet(context)) return 24;
    return 32;
  }
}
