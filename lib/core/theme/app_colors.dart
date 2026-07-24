import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF8A00);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFEF4444);

  static const Color background = Color(0xFF0B0B13);
  static const Color surface = Color(0xFF171726);
  static const Color card = Color(0xFF202035);

  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB6B6C9);

  static const Color gold = Color(0xFFFFD700);
  static const Color danger = Color(0xFFFF4757);
  static const Color surface2 = Color(0xFF13162A);
  static const Color muted = Color(0xFF7B80A6);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF9B59FF)],
  );

  static const LinearGradient neonGlow = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );

  static const LinearGradient cardGlass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x33FFFFFF), Color(0x0DFFFFFF)],
  );
}
