// ============================================================
// FOOD TOUR BUTLER - DESIGN SYSTEM
// Complete visual specifications for hackathon implementation
// ============================================================

import 'package:flutter/material.dart';

// ============================================================
// COLOR PALETTE
// ============================================================

class AppColors {
  // Background Colors
  static const Color background = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF242424);
  static const Color cardBackgroundLight = Color(0xFF2D2D2D);
  
  // Text Colors
  static const Color cream = Color(0xFFF5F0E6);
  static const Color creamMuted = Color(0xFFF5F0E6);
  static const Color textSecondary = Color(0xFFB8B0A0);
  
  // Accent Colors
  static const Color burntOrange = Color(0xFFE85A3D);
  static const Color burntOrangeDark = Color(0xFFD44A2D);
  static const Color brass = Color(0xFFC9A962);
  static const Color brassMuted = Color(0xFF9A7B3D);
  
  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);
  
  // Utility
  static Color get shimmerBase => cardBackground;
  static Color get shimmerHighlight => brass.withOpacity(0.2);
}

// ============================================================
// TYPOGRAPHY
// ============================================================

class AppTypography {
  // Headlines - Playfair Display (Serif)
  static const TextStyle hero = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.cream,
    height: 1.1,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.cream,
    height: 1.2,
    letterSpacing: -0.3,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.cream,
    height: 1.2,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.cream,
    height: 1.3,
  );
  
  static const TextStyle h4 = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.cream,
    height: 1.3,
  );
  
  // Body - Inter (Sans-serif)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.cream,
    height: 1.6,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.cream,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  // Labels & UI
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.cream,
    letterSpacing: 0.3,
  );
  
  static const TextStyle label = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.cream,
    letterSpacing: 0.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );
  
  // Special
  static const TextStyle button = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.cream,
    letterSpacing: 0.5,
  );
  
  static const TextStyle tag = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.cream,
    letterSpacing: 1.0,
  );
  
  static const TextStyle greeting = TextStyle(
    fontFamily: 'Playfair Display',
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.cream,
    fontStyle: FontStyle.italic,
  );
}

// ============================================================
// SPACING
// ============================================================

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  
  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: 24);
}

// ============================================================
// BORDER RADIUS
// ============================================================

class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;
}

// ============================================================
// SHADOWS
// ============================================================

class AppShadows {
  static BoxShadow get card => BoxShadow(
    color: Colors.black.withOpacity(0.3),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow get cardElevated => BoxShadow(
    color: Colors.black.withOpacity(0.4),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );
  
  static BoxShadow get button => BoxShadow(
    color: AppColors.burntOrange.withOpacity(0.4),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow get polaroid => BoxShadow(
    color: Colors.black.withOpacity(0.3),
    blurRadius: 10,
    offset: const Offset(3, 5),
  );
}

// ============================================================
// GRADIENTS
// ============================================================

class AppGradients {
  static LinearGradient get primary => const LinearGradient(
    colors: [AppColors.burntOrange, AppColors.burntOrangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get brassAccent => LinearGradient(
    colors: [
      AppColors.brass.withOpacity(0.2),
      AppColors.brass.withOpacity(0.1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get overlay => LinearGradient(
    colors: [
      Colors.transparent,
      Colors.black.withOpacity(0.3),
      Colors.black.withOpacity(0.85),
    ],
    stops: const [0.2, 0.5, 0.9],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static LinearGradient get card => LinearGradient(
    colors: [
      AppColors.cardBackground,
      AppColors.cardBackgroundLight,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// ============================================================
// ANIMATION DURATIONS
// ============================================================

class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 800);
  
  // Stagger delays
  static const Duration staggerFast = Duration(milliseconds: 50);
  static const Duration staggerNormal = Duration(milliseconds: 100);
  static const Duration staggerSlow = Duration(milliseconds: 150);
}

// ============================================================
// CURVES
// ============================================================

class AppCurves {
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounce = Curves.elasticOut;
  static const Curve snap = Curves.fastOutSlowIn;
}

// ============================================================
// COMPONENT STYLES
// ============================================================

class AppComponents {
  // Card Style
  static BoxDecoration get card => BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    boxShadow: [AppShadows.card],
  );
  
  static BoxDecoration get cardElevated => BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppRadius.lg),
    boxShadow: [AppShadows.cardElevated],
  );
  
  // Button Styles
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.burntOrange,
    foregroundColor: AppColors.cream,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
    textStyle: AppTypography.button,
    elevation: 0,
  );
  
  static ButtonStyle get secondaryButton => ElevatedButton.styleFrom(
    backgroundColor: AppColors.cardBackground,
    foregroundColor: AppColors.cream,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      side: BorderSide(
        color: AppColors.brass.withOpacity(0.5),
      ),
    ),
    textStyle: AppTypography.button,
    elevation: 0,
  );
  
  // Input Style
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: AppColors.cardBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.brass, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: AppTypography.body.copyWith(
      color: AppColors.textSecondary,
    ),
  );
  
  // Chip Style
  static BoxDecoration get chip => BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(AppRadius.full),
    border: Border.all(
      color: AppColors.brass.withOpacity(0.3),
    ),
  );
  
  static BoxDecoration get chipActive => BoxDecoration(
    color: AppColors.brass.withOpacity(0.2),
    borderRadius: BorderRadius.circular(AppRadius.full),
    border: Border.all(
      color: AppColors.brass,
    ),
  );
  
  // Tag Style
  static BoxDecoration get tag => BoxDecoration(
    color: AppColors.burntOrange,
    borderRadius: BorderRadius.circular(AppRadius.full),
  );
  
  // Award Badge Style
  static BoxDecoration get awardBadge => BoxDecoration(
    gradient: AppGradients.brassAccent,
    border: Border.all(color: AppColors.brass, width: 1.5),
    borderRadius: BorderRadius.circular(AppRadius.sm),
  );
}

// ============================================================
// THEME DATA
// ============================================================

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    
    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.burntOrange,
      secondary: AppColors.brass,
      surface: AppColors.cardBackground,
      background: AppColors.background,
      onPrimary: AppColors.cream,
      onSecondary: AppColors.cream,
      onSurface: AppColors.cream,
      onBackground: AppColors.cream,
    ),
    
    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.h4,
      iconTheme: const IconThemeData(color: AppColors.cream),
    ),
    
    // Cards
    cardTheme: CardTheme(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    
    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppComponents.primaryButton,
    ),
    
    // Input
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    
    // Bottom Navigation
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.brass,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.burntOrange,
      foregroundColor: AppColors.cream,
    ),
    
    // Text
    textTheme: TextTheme(
      displayLarge: AppTypography.hero,
      displayMedium: AppTypography.h1,
      displaySmall: AppTypography.h2,
      headlineMedium: AppTypography.h3,
      headlineSmall: AppTypography.h4,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.label,
      labelSmall: AppTypography.caption,
    ),
  );
}

// ============================================================
// BREAKPOINTS (for responsive)
// ============================================================

class AppBreakpoints {
  static const double mobile = 375;
  static const double mobileLarge = 414;
  static const double tablet = 768;
  static const double desktop = 1024;
}

// ============================================================
// ICONS (commonly used)
// ============================================================

class AppIcons {
  // Navigation
  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData search = Icons.search;
  static const IconData map = Icons.map_outlined;
  static const IconData journal = Icons.book_outlined;
  static const IconData profile = Icons.person_outline;
  
  // Actions
  static const IconData add = Icons.add;
  static const IconData close = Icons.close;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData more = Icons.more_vert;
  static const IconData share = Icons.share_outlined;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteOutline = Icons.favorite_outline;
  static const IconData bookmark = Icons.bookmark;
  static const IconData bookmarkOutline = Icons.bookmark_outline;
  
  // Restaurant
  static const IconData restaurant = Icons.restaurant;
  static const IconData star = Icons.star;
  static const IconData starOutline = Icons.star_outline;
  static const IconData location = Icons.location_on;
  static const IconData phone = Icons.phone;
  static const IconData website = Icons.language;
  static const IconData clock = Icons.access_time;
  static const IconData price = Icons.attach_money;
  
  // Tour
  static const IconData walking = Icons.directions_walk;
  static const IconData driving = Icons.directions_car;
  static const IconData transit = Icons.directions_transit;
  static const IconData calendar = Icons.calendar_today;
  static const IconData time = Icons.schedule;
  
  // Butler/AI
  static const IconData butler = Icons.support_agent;
  static const IconData chat = Icons.chat_bubble_outline;
  static const IconData microphone = Icons.mic;
  static const IconData send = Icons.send;
  
  // Awards
  static const IconData award = Icons.emoji_events;
  static const IconData trophy = Icons.military_tech;
  
  // Misc
  static const IconData info = Icons.info_outline;
  static const IconData warning = Icons.warning_amber;
  static const IconData check = Icons.check_circle;
  static const IconData camera = Icons.camera_alt;
  static const IconData photo = Icons.photo;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete_outline;
}
