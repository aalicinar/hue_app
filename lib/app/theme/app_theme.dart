import 'package:flutter/material.dart';
import 'tokens.dart';

ThemeData buildHueDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: HueColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF8C42),
      secondary: Color(0xFF6C3483),
      surface: HueColors.bgCard,
      onSurface: HueColors.textPrimary,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    dividerColor: HueColors.borderSubtle,
    appBarTheme: const AppBarTheme(
      backgroundColor: HueColors.bgPrimary,
      elevation: 0,
      centerTitle: true,
      foregroundColor: HueColors.textPrimary,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: HueColors.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(HueRadius.xl)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: HueColors.textSecondary,
      size: 24,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
      },
    ),
  );
}

ThemeData buildHueLightTheme() {
  const bg = Color(0xFFF5F6FA);
  const card = Color(0xFFECEFF5);
  const textPrimary = Color(0xFF111827);
  const textSecondary = Color(0xFF6B7280);
  const border = Color(0xFFDDE1EB);
  const bgSec = Color(0xFFFFFFFF);

  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFF8C42),
      secondary: Color(0xFF6C3483),
      surface: card,
      onSurface: textPrimary,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    dividerColor: border,
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      centerTitle: true,
      foregroundColor: textPrimary,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: bgSec,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(HueRadius.xl)),
      ),
    ),
    iconTheme: const IconThemeData(
      color: textSecondary,
      size: 24,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
      },
    ),
  );
}

// Keep old name for any existing callers
ThemeData buildHueTheme() => buildHueDarkTheme();
