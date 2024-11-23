import 'package:browse_station/core/config/color.constant.dart';
import 'package:flutter/material.dart';

import '../config/font.constant.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor).copyWith(
    primary: AppColor.primaryColor,
    secondary: AppColor.secondaryColor,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: AppColor.scaffordBg,
  fontFamily: AppFont.futura,
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 40,
      color: Colors.black,
      fontFamily: AppFont.futura,
    ),
    titleMedium: TextStyle(
      fontSize: 25,
      fontFamily: AppFont.futura,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      fontFamily: AppFont.futura,
      color: AppColor.dark,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      fontFamily: AppFont.futura,
    ),
    labelSmall: TextStyle(
      color: AppColor.greyColor,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
    fillColor: AppColor.primaryColor.withOpacity(0.08),
    filled: true,
    errorMaxLines: 1,

    errorStyle: const TextStyle(
      color: Colors.transparent,
      fontSize: 0,
      height: 0, // fontFamily: AppFont.futura,
      // fontWeight: FontWeight.bold,
    ),

    border: InputBorder.none,
    enabledBorder: InputBorder.none,

    // enabledBorder: InputBorder.none,
    // errorBorder: const OutlineInputBorder(
    //   borderSide: BorderSide(color: AppColor.danger, width: 1),
    // ),
    errorBorder: InputBorder.none,
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.danger, width: 1),
    ),

    // focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    // contentPadding: EdgeInsets.all(8),
    hintStyle: const TextStyle(
      color: AppColor.greyColor,
      fontFamily: AppFont.segoui,
      fontWeight: FontWeight.normal,
      fontSize: 16,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    color: AppColor.scaffordBg,
    titleTextStyle: TextStyle(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      disabledForegroundColor: Colors.black,
      backgroundColor: AppColor.primaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 60),
      animationDuration: Durations.extralong4,
      enableFeedback: true,
      surfaceTintColor: AppColor.primaryColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
    ),

    // style: ButtonStyle(
    //   padding: WidgetStatePropertyAll(
    //     const EdgeInsets.symmetric(
    //       horizontal: double.infinity,
    //       vertical: 20,
    //     ),
    //   ),
    // ),
  ),
);
