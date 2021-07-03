import 'package:flutter/material.dart';
import 'package:untitled/ui/home/nav_scaffold.dart';

class NavigateUtils {
  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    Navigator.of(context, rootNavigator: rootNavigator)
        .pushNamed(routeName, arguments: arguments);
  }

  static void pushNamedToRoot(
    BuildContext context,
    String routeName, [
    Object? arguments,
  ]) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void pop(
    BuildContext context, {
    Object? arguments,
    bool rootNavigator = false,
  }) {
    Navigator.of(context, rootNavigator: rootNavigator).pop(arguments);
  }

  static void pushNamedFromNav(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    final NavigatorState? navigatorState = NavigationScaffold.of(context);
    navigatorState?.pushNamed(routeName, arguments: arguments);
  }
}
