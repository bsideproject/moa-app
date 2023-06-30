import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moa_app/constants/color_constants.dart';

class Themes {
  Themes._();

  static final light = ThemeData.light().copyWith(
    // useMaterial3: true,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    // bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.blackColor,
      ),
      actionsIconTheme: IconThemeData(
        color: AppColors.blackColor,
      ),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.blackColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: lightModeStatusBarColor,
      toolbarTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.blackColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.disabled,
      background: Colors.white,
      primary: AppColors.primaryColor,
      surfaceTint: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC4C4C4))),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
    disabledColor: const Color.fromRGBO(30, 30, 30, 0.2),
    buttonTheme: ButtonThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(background: Colors.black)),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    ),
  );

  static final dark = ThemeData.dark().copyWith(
    // dark theme settings
    // useMaterial3: true,
    colorScheme: const ColorScheme.light(
      background: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      systemOverlayStyle: darkModeStatusBarColor,
    ),

    scaffoldBackgroundColor: Colors.black,

    inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFA4A4A4))),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),

    disabledColor: const Color.fromRGBO(205, 205, 205, 0.2),
    buttonTheme: ButtonThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(background: Colors.white)),

    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );

  static void setStatusBarColors() {
    SystemChrome.setSystemUIOverlayStyle(
      lightModeStatusBarColor,
    );
  }
}

const darkModeStatusBarColor = SystemUiOverlayStyle(
  statusBarColor: Colors.black,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const lightModeStatusBarColor = SystemUiOverlayStyle(
  statusBarColor: Colors.white,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
