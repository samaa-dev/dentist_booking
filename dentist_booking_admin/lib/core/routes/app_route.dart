import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import '../../features/home/home.dart';

/// Extension on [BuildContext] build context to provide easy access Context Extension.
extension RoutesContextExtension on BuildContext {
  // Pops the current route off the navigation stack.
  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  // Pushes a named route onto the navigation stack.

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  // Replaces the current screen with a named route on the navigation stack.
  void pushReplacementNamed(String routeName, {Object? arguments}) =>
      Navigator.pushReplacementNamed(this, routeName, arguments: arguments);

  // Pushes a named route onto the navigation stack and removes all previous routes.
  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }
}

@immutable
class RoutesName {
  const RoutesName._();

  static const String home = '/home';
  static const String main = '/main';
  static const String search = '/search';
  static const String settings = '/settings';
}

@immutable
class AppRouter {
  PageRoute generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final arguments = settings.arguments;

    switch (settings.name) {
      case RoutesName.home:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const Scaffold(),
        );

      // case RoutesName.scan:
      //   return _getPageRoute(
      //     routeName: settings.name,
      //     viewToShow: ScanScreen(
      //       typeScan: arguments as TypeScan,
      //     ),
      //   );

      // case RoutesName.details:
      //   return _getPageRoute(
      //     routeName: settings.name,
      //     viewToShow: DetailsScreen(
      //       mrzData: arguments as MRZ,
      //     ),
      //   );

      // case RoutesName.sms:
      //   return _getPageRoute(
      //     routeName: settings.name,
      //     viewToShow: SMSScreen(
      //       simModel: arguments as SIMModel,
      //     ),
      //   );

      // case RoutesName.settings:
      //   return _getPageRoute(
      //     routeName: settings.name,
      //     viewToShow: const SettingsScreen(),
      //   );

      default:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  PageRoute _getPageRoute({String? routeName, Widget? viewToShow}) {
    return CupertinoPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => viewToShow!,
    );
  }
}
