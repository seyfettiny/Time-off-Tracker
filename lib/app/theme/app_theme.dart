//App Theme

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeProvider = Provider((ref) => AppTheme());

class AppTheme {
  ThemeData get themeData => ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xff7F56D9),
          onPrimary: Colors.white,
          secondary: Colors.black,
          onSecondary: Colors.amber,
          error: Colors.red,
          onError: Colors.white,
          background: const Color(0xffF6F6F6),
          onBackground: const Color(0xff344054),
          surface: Colors.lightBlue,
          onSurface: Colors.grey.shade800,
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          toolbarTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        fontFamily: GoogleFonts.getFont('Inter').fontFamily,
      );
}
