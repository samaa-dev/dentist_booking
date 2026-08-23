import 'package:flutter/material.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppNavigator {
  AppNavigator._();

  static void dismissOverlays() {
    final nav = rootNavigatorKey.currentState;
    if (nav == null) return;
    nav.popUntil((route) => route.isFirst);
  }
}
