import 'package:flutter/material.dart';

class GlassConstants {
  static const Color accent = Color(0xFF31A8FF);

  static const double blur = 14;
  static const double strongBlur = 22;

  static const double radiusS = 18;
  static const double radiusM = 24;
  static const double radiusL = 32;

  static const Duration motionFast = Duration(milliseconds: 220);
  static const Duration motionMedium = Duration(milliseconds: 300);

  static const EdgeInsets pagePadding = EdgeInsets.fromLTRB(16, 16, 16, 20);

  // Input field specific constants
  static const double inputBorderWidth = 1.5;
  static const double inputBorderWidthFocused = 2.0;
  static const double inputIconSize = 22.0;
  static const double inputPaddingHorizontal = 16.0;
  static const double inputPaddingVertical = 14.0;
  
  // Spacing constants
  static const double spacingXS = 8.0;
  static const double spacingS = 10.0;
  static const double spacingM = 16.0;
  static const double spacingL = 20.0;
  static const double spacingXL = 24.0;
  static const double spacingXXL = 28.0;
  static const double spacingXXXL = 32.0;
  
  // Typography
  static const double fontSizeLabel = 15.0;
  static const double fontSizePlaceholder = 14.0;
  static const double fontSizeError = 13.0;
  static const double fontSizeTitle = 28.0;
  static const double fontSizeSubtitle = 15.0;
  
  static const FontWeight fontWeightLabel = FontWeight.w600;
  static const FontWeight fontWeightTitle = FontWeight.w800;
  static const FontWeight fontWeightError = FontWeight.w500;

  static Color surfaceColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.30)
        : Colors.white.withValues(alpha: 0.20);
  }

  static Color strongSurfaceColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.38)
        : Colors.white.withValues(alpha: 0.28);
  }

  static Color borderColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.black.withValues(alpha: 0.15); // Plus visible en mode clair
  }

  static Color shadowColor(Brightness brightness) {
    return Colors.black.withValues(
      alpha: brightness == Brightness.dark ? 0.40 : 0.18,
    );
  }

  static List<Color> backgroundGradient(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const [
        Color(0xFF0E1B31),
        Color(0xFF1A2D4D),
        Color(0xFF1A1F3A),
      ];
    }

    return const [
      Color(0xFF7FC7FF),
      Color(0xFFBEE4FF),
      Color(0xFFFFE5C8),
    ];
  }

  static Color titleColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF0D1A2D);
  }

  static Color bodyColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.92)
        : const Color(0xFF1D2A3D);
  }

  static Color mutedColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.70)
        : const Color(0xFF4A5C74);
  }

  // Retourne une couleur opaque pour le mode clair, transparente pour le mode sombre
  static Color adaptiveSurfaceColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.30)  // Transparent (mode sombre)
        : Colors.white.withValues(alpha: 1.0);   // Opaque (mode clair)
  }

  static Color adaptiveStrongSurfaceColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.38)  // Transparent (mode sombre)
        : Colors.white.withValues(alpha: 1.0);   // Opaque (mode clair)
  }

  // Retourne true si le BackdropFilter doit être appliqué
  static bool shouldApplyBlur(Brightness brightness) {
    return brightness == Brightness.dark;
  }

  // Error colors
  static Color errorColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFFEF4444)
        : const Color(0xFFDC2626);
  }
  
  // Input background colors
  static Color inputBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.30)
        : Colors.white.withValues(alpha: 0.85);
  }
  
  // Input border colors with opacity
  static Color inputBorderColor(Brightness brightness) {
    return borderColor(brightness).withValues(alpha:
      brightness == Brightness.dark ? 0.3 : 0.4
    );
  }
  
  // Payment provider colors
  static const Color mtnMomoYellow = Color(0xFFFFCC00);
  static const Color orangeMoneyOrange = Color(0xFFFF6600);
  
  // Semantic colors
  static const Color successGreen = Color(0xFF34A853);
  static const Color warningOrange = Color(0xFFF2994A);
  static const Color infoBlue = Color(0xFF2F80ED);
  static const Color helpPurple = Color(0xFF9B51E0);
  
  // Primary color variants for gradients
  static const Color primaryDark = Color(0xFF1A56E8);
  static const Color primaryDarker = Color(0xFF1440C2);
}
