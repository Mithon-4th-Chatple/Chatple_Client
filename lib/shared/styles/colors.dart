import 'package:flutter/material.dart';

class ThemeColors {
  final Color light;
  final Color lightHover;
  final Color lightActive;
  final Color normal;
  final Color normalHover;
  final Color normalActive;
  final Color dark;
  final Color darkHover;
  final Color darkActive;
  final Color darker;
  final Color gray0;
  final Color gray10;
  final Color gray20;
  final Color gray30;
  final Color gray40;
  final Color gray50;
  final Color gray60;
  final Color gray70;
  final Color gray80;
  final Color gray90;
  final Color gray100;
  final Color gray200;
  final Color gray300;
  final Color gray400;
  final Color gray500;
  final Color gray600;
  final Color gray700;
  final Color gray800;
  final Color gray900;

  ThemeColors({
    required this.light,
    required this.lightHover,
    required this.lightActive,
    required this.normal,
    required this.normalHover,
    required this.normalActive,
    required this.dark,
    required this.darkHover,
    required this.darkActive,
    required this.darker,
    required this.gray0,
    required this.gray10,
    required this.gray20,
    required this.gray30,
    required this.gray40,
    required this.gray50,
    required this.gray60,
    required this.gray70,
    required this.gray80,
    required this.gray90,
    required this.gray100,
    required this.gray200,
    required this.gray300,
    required this.gray400,
    required this.gray500,
    required this.gray600,
    required this.gray700,
    required this.gray800,
    required this.gray900,
  });

  static ThemeColors of(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ThemeColors(
      light: Color(0xFFEBF8F4),
      lightHover: Color(0xFFE1F4EE),
      lightActive: Color(0xFFC1E8DC),
      normal: Color(0xFF36B58D),
      normalHover: Color(0xFF31A37F),
      normalActive: Color(0xFF2B9171),
      dark: Color(0xFF29886A),
      darkHover: Color(0xFF206D55),
      darkActive: Color(0xFF18513F),
      darker: Color(0xFF133F31),
      gray0: const Color(0xffFFFFFF),
      gray10: const Color(0xffFAFAFA),
      gray20: const Color(0xffF5F5F5),
      gray30: const Color(0xffEBEBEB),
      gray40: const Color(0xffDEDEDE),
      gray50: const Color(0xffBFBFBF),
      gray60: const Color(0xffB0B0B0),
      gray70: const Color(0xffA3A3A3),
      gray80: const Color(0xff949494),
      gray90: const Color(0xff858585),
      gray100: const Color(0xff757575),
      gray200: const Color(0xff666666),
      gray300: const Color(0xff575757),
      gray400: const Color(0xff4A4A4A),
      gray500: const Color(0xff3B3B3B),
      gray600: const Color(0xff2E2E2E),
      gray700: const Color(0xff1C1C1C),
      gray800: const Color(0xff0D0D0D),
      gray900: const Color(0xff000000),
    );
  }
}