import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A helper class for managing the system UI overlay settings in the app.
class _OverlayStyleConfig {
  const _OverlayStyleConfig._();

  /// Sets the system UI overlay style to the default style.
  static SystemUiOverlayStyle overlayAppBar(BuildContext context) {
    Brightness statusBarIconBrightness =
        Theme.of(context).brightness == Brightness.light
        ? Brightness.light
        : Brightness.dark;

    // final statusBarIconBrightness =
    //     brightness == Brightness.light ? Brightness.dark : Brightness.light;

    return const SystemUiOverlayStyle().copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarIconBrightness: statusBarIconBrightness,
      // systemNavigationBarColor: colorScheme.surface,
      // systemNavigationBarDividerColor: Colors.transparent,
      // systemNavigationBarContrastEnforced: false,
      // systemStatusBarContrastEnforced: false,
    );
  }

  /// Sets the system UI overlay style to the default style.
  static overlayNavigation(BuildContext context) {
    Brightness statusBarIconBrightness =
        Theme.of(context).brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;

    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle()
        .copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: statusBarIconBrightness,
          systemNavigationBarIconBrightness: statusBarIconBrightness,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
          systemStatusBarContrastEnforced: false,
        );

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.bottom],
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }
}

class OverlayHelper {
  /// Sets the system UI overlay style for navigation elements.
  ///
  /// This method applies the [SystemUiOverlayStyle] configuration for navigation elements
  /// to the current [BuildContext].
  static void overlayNavigation(BuildContext context) {
    _OverlayStyleConfig.overlayNavigation(context);
  }

  /// Retrieves the system UI overlay style for app bars.
  ///
  /// This method returns the [SystemUiOverlayStyle] configuration for app bars
  /// based on the current [BuildContext].
  ///
  /// Returns:
  ///   The [SystemUiOverlayStyle] configuration for app bars.
  static overlayStyleAppBar(BuildContext context) {
    return _OverlayStyleConfig.overlayAppBar(context);
  }

  /// Determines if the current theme mode in the given [context] is dark mode.
  /// Returns `true` if the theme mode is dark, `false` otherwise.
  /// If no [context] is provided, the current [BuildContext] is used.
  /// If no [context] is available, `false` is returned.
  /// This method is a shortcut for `Theme.of(context).brightness == Brightness.dark`.
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
