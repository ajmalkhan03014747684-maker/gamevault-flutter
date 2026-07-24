import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography system: Orbitron for headings, Rajdhani for body, Inter for numbers.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading1 = GoogleFonts.orbitron(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );

  static TextStyle heading2 = GoogleFonts.orbitron(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );

  static TextStyle heading3 = GoogleFonts.orbitron(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.rajdhani(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySecondary = GoogleFonts.rajdhani(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle button = GoogleFonts.rajdhani(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.8,
  );

  static TextStyle number = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle numberLarge = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.rajdhani(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );
}
