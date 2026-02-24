import 'package:flutter/material.dart';
import 'tokens.dart';

ThemeData buildHueTheme() {
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
      },
    ),
  );
}
