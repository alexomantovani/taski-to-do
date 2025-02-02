import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  const Styles._();

  static const Color kPrimaryBlue = Color(0xFF007FFF);
  static const Color kPrimaryBlueWithOpacity = Color(0xFFE5F2FF);
  static const Color kPrimaryPurple = Color(0xFF3F3D56);
  static const Color kPrimaryDelete = Color(0xFFFF5E5E);
  static const Color kPrimarySlateBlue = Color(0xFF8D9CB8);
  static const Color kPrimaryPale = Color(0xFFF5F7F9);
  static const Color kStandardWhite = Color(0xFFFFFFFF);
  static const Color kStandardBlack = Color(0xFF000000);

  static TextStyle titleLarge = GoogleFonts.urbanist(
    color: kPrimaryPurple,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle titleMedium = GoogleFonts.urbanist(
    color: kPrimaryPurple,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleSmall = GoogleFonts.urbanist(
    color: kPrimaryPurple,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bodyMedium = GoogleFonts.urbanist(
    color: kPrimarySlateBlue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodySmall = GoogleFonts.urbanist(
    color: kPrimarySlateBlue,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
