import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class HueTextStyles {
  static TextStyle get title => GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: HueColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get subtitle => GoogleFonts.dmSans(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: HueColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get label => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: HueColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get body => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: HueColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get meta => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: HueColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: HueColors.textSecondary,
        height: 1.3,
      );

  static TextStyle get tagline => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: HueColors.textSecondary,
        letterSpacing: 0.5,
      );
}
