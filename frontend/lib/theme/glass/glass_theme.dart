import 'package:flutter/material.dart';

import 'glass_constants.dart';

class GlassTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: GlassConstants.accent,
      brightness: brightness,
    ).copyWith(
      primary: GlassConstants.accent,
      secondary: const Color(0xFF57D4FF),
      surface: Colors.transparent,
      surfaceContainerHighest: Colors.transparent,
      outline: GlassConstants.borderColor(brightness),
    );

    final baseTextColor = GlassConstants.bodyColor(brightness);
    final titleColor = GlassConstants.titleColor(brightness);

    final textTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        color: titleColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: titleColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: titleColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: titleColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: titleColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: baseTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: GlassConstants.mutedColor(brightness),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: GlassConstants.mutedColor(brightness),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      primaryColor: GlassConstants.accent,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: titleColor),
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConstants.radiusM),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GlassConstants.surfaceColor(brightness),
        hintStyle: TextStyle(
          color: GlassConstants.mutedColor(brightness),
        ),
        labelStyle: TextStyle(
          color: GlassConstants.mutedColor(brightness),
        ),
        prefixIconColor: GlassConstants.mutedColor(brightness),
        suffixIconColor: GlassConstants.mutedColor(brightness),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConstants.radiusS),
          borderSide: BorderSide(color: GlassConstants.borderColor(brightness)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConstants.radiusS),
          borderSide: BorderSide(color: GlassConstants.borderColor(brightness)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlassConstants.radiusS),
          borderSide: BorderSide(
            color: GlassConstants.accent.withValues(alpha: 0.95),
            width: 1.6,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              GlassConstants.accent.withValues(alpha: isDark ? 0.45 : 0.85),
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlassConstants.radiusS),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: GlassConstants.borderColor(brightness)),
          foregroundColor: titleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlassConstants.radiusS),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: titleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlassConstants.radiusS),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: GlassConstants.borderColor(brightness),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GlassConstants.accent;
          }
          return isDark ? Colors.white70 : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GlassConstants.accent.withValues(alpha: 0.45);
          }
          return GlassConstants.surfaceColor(brightness);
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConstants.radiusL),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlassConstants.radiusL),
        ),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark
            ? Colors.black.withValues(alpha: 0.55)
            : Colors.white.withValues(alpha: 0.72),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: titleColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: GlassConstants.borderColor(brightness)),
        ),
      ),
    );
  }
}
