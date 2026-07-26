import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension OsExtensions on BuildContext {
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;

  Size get mediaQuery => MediaQuery.sizeOf(this);

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  // double get screenWidth => mediaQuery.width;
  // double get screenHeight => mediaQuery.height;

  get defaultSystemUiOverlayStylebrightness => isDarkMode
      ? const SystemUiOverlayStyle().copyWith(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        )
      : const SystemUiOverlayStyle().copyWith(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        );

  get reversedSystemUiOverlayStylebrightness => !isDarkMode
      ? const SystemUiOverlayStyle().copyWith(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        )
      : const SystemUiOverlayStyle().copyWith(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        );
}

extension LangExtensions on String {
  String get trnsltd => this.tr();
}

extension IntFormatting on int {
  String twoDigits() => this < 10 ? '0$this' : '$this';
}
