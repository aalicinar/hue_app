import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────
// DYNAMIC COLOR HELPERS  (context-aware)
// ─────────────────────────────────────────────────────────

/// Convenience extension so we can write `context.hue` everywhere.
extension HueThemeContext on BuildContext {
  HueColorTokens get hue => HueColorTokens.of(this);
}

class HueColorTokens {
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgCard;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color borderSubtle;
  final Color success;
  final Color error;
  final Color info;
  final bool isDark;

  const HueColorTokens._({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgCard,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.borderSubtle,
    required this.success,
    required this.error,
    required this.info,
    required this.isDark,
  });

  static HueColorTokens of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? _dark : _light;
  }

  static const _dark = HueColorTokens._(
    bgPrimary: Color(0xFF0F1724),
    bgSecondary: Color(0xFF141D2B),
    bgCard: Color(0xFF1A2234),
    textPrimary: Color(0xFFE8ECF4),
    textSecondary: Color(0xFF7A8399),
    textDisabled: Color(0xFF3D4A60),
    borderSubtle: Color(0xFF1F2D42),
    success: Color(0xFF1E8449),
    error: Color(0xFFC0392B),
    info: Color(0xFF2471A3),
    isDark: true,
  );

  static const _light = HueColorTokens._(
    bgPrimary: Color(0xFFF5F6FA),
    bgSecondary: Color(0xFFFFFFFF),
    bgCard: Color(0xFFECEFF5),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    textDisabled: Color(0xFFB0B8C8),
    borderSubtle: Color(0xFFDDE1EB),
    success: Color(0xFF1E8449),
    error: Color(0xFFC0392B),
    info: Color(0xFF2471A3),
    isDark: false,
  );
}

// ─────────────────────────────────────────────────────────
// STATIC COLORS (keep for backward compat / const contexts)
// ─────────────────────────────────────────────────────────
class HueColors {
  // dark defaults (widgets that cannot easily access context)
  static const bgPrimary = Color(0xFF0F1724);
  static const bgSecondary = Color(0xFF141D2B);
  static const bgCard = Color(0xFF1A2234);
  static const textPrimary = Color(0xFFE8ECF4);
  static const textSecondary = Color(0xFF7A8399);
  static const textDisabled = Color(0xFF3D4A60);
  static const borderSubtle = Color(0xFF1F2D42);
  static const success = Color(0xFF1E8449);
  static const error = Color(0xFFC0392B);
  static const info = Color(0xFF2471A3);
}

// ─────────────────────────────────────────────────────────
// SPACING / RADIUS / SIZES
// ─────────────────────────────────────────────────────────

class HueSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class HueRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 20.0;
  static const double xl = 28.0;
  static const double pill = 999.0;
}

class HueSizes {
  static const double avatarLg = 80.0;
  static const double avatarMd = 56.0;
  static const double avatarSm = 32.0;
  static const double huePrimary = 72.0;
  static const double huePreset = 48.0;
  static const double touchMin = 44.0;
  static const double presenceDot = 10.0;
  static const double swatchW = 30.0;
  static const double swatchH = 12.0;
  static const double orbPreview = 96.0;
}
