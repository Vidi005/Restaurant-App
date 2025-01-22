import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/style/restaurant_colors.dart';

class RestaurantTheme {
  static getTextTheme(brightness) {
    var isLightTheme = brightness == Brightness.light;
    var accentTextColor = isLightTheme ? Colors.brown : Colors.white;
    var primaryTextColor = isLightTheme ? Colors.black : Colors.white;
    return TextTheme(
      displayLarge: GoogleFonts.montserratTextTheme().displayLarge?.copyWith(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
      displayMedium: GoogleFonts.montserratTextTheme().displayMedium?.copyWith(
            color: primaryTextColor,
          ),
      displaySmall: GoogleFonts.montserratTextTheme().displaySmall?.copyWith(
            color: primaryTextColor,
          ),
      headlineLarge: GoogleFonts.montserratTextTheme().headlineLarge?.copyWith(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
      headlineMedium:
          GoogleFonts.montserratTextTheme().headlineMedium?.copyWith(
                color: primaryTextColor,
              ),
      headlineSmall: GoogleFonts.montserratTextTheme().headlineSmall?.copyWith(
            color: primaryTextColor,
          ),
      titleLarge: GoogleFonts.merriweatherTextTheme().titleLarge?.copyWith(
            color: accentTextColor,
            fontWeight: FontWeight.bold,
          ),
      titleMedium: GoogleFonts.merriweatherTextTheme().titleMedium?.copyWith(
            color: accentTextColor,
          ),
      titleSmall: GoogleFonts.merriweatherTextTheme().titleSmall?.copyWith(
            color: accentTextColor,
          ),
      bodyLarge: GoogleFonts.nunitoTextTheme().bodyLarge?.copyWith(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
      bodyMedium: GoogleFonts.nunitoTextTheme().bodyMedium?.copyWith(
            color: primaryTextColor,
          ),
      bodySmall: GoogleFonts.nunitoTextTheme().bodySmall?.copyWith(
            color: primaryTextColor,
          ),
      labelLarge: GoogleFonts.nunitoTextTheme().labelLarge?.copyWith(
            color: primaryTextColor,
          ),
      labelMedium: GoogleFonts.nunitoTextTheme().labelMedium?.copyWith(
            color: primaryTextColor,
          ),
      labelSmall: GoogleFonts.nunitoTextTheme().labelSmall?.copyWith(
            color: primaryTextColor,
          ),
    );
  }

  static get lightAppBarTheme => AppBarTheme(
        toolbarTextStyle: getTextTheme(Brightness.light).displaySmall,
        shadowColor: Colors.black.withAlpha(128),
      );

  static get darkAppBarTheme => AppBarTheme(
        toolbarTextStyle: getTextTheme(Brightness.dark).displaySmall,
        shadowColor: Colors.white.withAlpha(128),
      );

  static get lightTheme => ThemeData(
        appBarTheme: lightAppBarTheme,
        colorSchemeSeed: RestaurantColors.amber.color,
        brightness: Brightness.light,
        textTheme: getTextTheme(Brightness.light),
        useMaterial3: true,
      );

  static get darkTheme => ThemeData(
        appBarTheme: darkAppBarTheme,
        colorSchemeSeed: RestaurantColors.amberAccent.color,
        brightness: Brightness.dark,
        textTheme: getTextTheme(Brightness.dark),
        useMaterial3: true,
      );
}
