import 'package:flutter/material.dart';
import 'package:wafy/core/utils/font_constants.dart';

class AppTypography {
  static TextTheme cairoTextTheme([TextTheme? base]) {
    final TextTheme resolved = base ?? const TextTheme();
    // استخدام الخط المحلي بدلاً من Google Fonts
    return resolved.copyWith(
      displayLarge: resolved.displayLarge?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      displayMedium: resolved.displayMedium?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      displaySmall: resolved.displaySmall?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      headlineLarge: resolved.headlineLarge?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      headlineMedium: resolved.headlineMedium?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      headlineSmall: resolved.headlineSmall?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      titleLarge: resolved.titleLarge?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      titleMedium: resolved.titleMedium?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      titleSmall: resolved.titleSmall?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      bodyLarge: resolved.bodyLarge?.copyWith(fontFamily: FontConstants.cairo),
      bodyMedium: resolved.bodyMedium?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      bodySmall: resolved.bodySmall?.copyWith(fontFamily: FontConstants.cairo),
      labelLarge: resolved.labelLarge?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      labelMedium: resolved.labelMedium?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
      labelSmall: resolved.labelSmall?.copyWith(
        fontFamily: FontConstants.cairo,
      ),
    );
  }

  static TextStyle poppinsNumberStyle([TextStyle? base]) {
    return FontConstants.poppinsStyle(
      weight: FontConstants.poppinsRegular,
      fontSize: base?.fontSize,
      color: base?.color,
      style: base?.fontStyle,
    ).merge(base);
  }

  static TextStyle poppinsTextStyle([TextStyle? base]) {
    return FontConstants.poppinsStyle(
      weight: FontConstants.poppinsRegular,
      fontSize: base?.fontSize,
      color: base?.color,
      style: base?.fontStyle,
    ).merge(base);
  }
}
