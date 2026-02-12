import 'package:flutter/material.dart';

class AppConstants {
  // --- Couleurs ---
  static const Color backgroundColor = Color(0xFF121212);
  static const Color primaryTextColor = Color(0xFFFFFFFF);
  static const Color secondaryTextColor = Color(0xFFB3B3B3);
  static const Color accentColor = Color(0xFFE50914);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);

  // --- Styles de Texte ---
  static const TextStyle headlineStyle = TextStyle(
    color: primaryTextColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleStyle = TextStyle(
    color: primaryTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    color: secondaryTextColor,
    fontSize: 14,
  );
}