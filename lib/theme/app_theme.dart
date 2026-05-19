import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2A7F7F);
  static const Color primaryLight = Color(0xFFE8F4F4);
  static const Color background = Color(0xFFF5F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputBg = Color(0xFFEEF2F5);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color logout = Color(0xFFE07B39);
  static const Color cardBg = Color(0xFFEFF6F6);
  static const Color border = Color(0xFFE5E7EB);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: -0.5,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle distance = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

class AppDecorations {
  static BoxDecoration inputDecoration = BoxDecoration(
    color: AppColors.inputBg,
    borderRadius: BorderRadius.circular(16),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBg,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(16),
  );

  static BoxDecoration secondaryButtonDecoration = BoxDecoration(
    color: AppColors.inputBg,
    borderRadius: BorderRadius.circular(16),
  );

  static BoxDecoration outlineButtonDecoration = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border, width: 1.5),
  );
}
