import 'package:flutter/material.dart';

class UserStyles {
  // Colors (dashboard scheme)
  static const Color primaryYellow = Color(0xFF4CAF50); // Use dashboard's green
  static const Color white = Color(0xFFFFFFFF);
  static const Color darkText = Color(0xFF222222);
  static const Color lightText = Color(0xFF666666);
  static const Color placeholderText = Color(0xFFAAAAAA);
  static const Color inputBorder = Color(0xFFDDDDDD);
  static const Color successGreen = Color(0xFF388E3C);
  static const Color cardBackground = Color(0xFFF5F5F5); // Dashboard bg

  // Spacing
  static const double paddingLarge = 30.0;
  static const double paddingMedium = 20.0;
  static const double paddingSmall = 15.0;
  static const double marginLarge = 25.0;
  static const double marginMedium = 15.0;
  static const double marginSmall = 10.0;
  static const double inputHeight = 50.0;
  static const double buttonHeight = 50.0;

  // Border radius
  static const double borderRadiusLarge = 25.0;
  static const double borderRadiusMedium = 10.0;
  static const double borderRadiusSmall = 5.0;

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  // Fonts
  static const String primaryFontFamily = 'Arial';
  static const double headerFontSizeLarge = 28.0;
  static const double headerFontSizeMedium = 24.0;
  static const double headerFontSizeSmall = 18.0;
  static const double bodyFontSize = 16.0;
  static const double smallFontSize = 14.0;
  static const double buttonFontSize = 16.0;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightRegular = FontWeight.w400;
}
