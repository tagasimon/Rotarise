import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void push(Widget destination, {bool? fullscreenDialog = false}) {
    Navigator.push(
      this,
      MaterialPageRoute(
        fullscreenDialog: fullscreenDialog ?? false,
        builder: (context) => destination,
      ),
    );
  }

  void pop(Object? value) {
    Navigator.of(this).pop(value);
  }

  void pushReplacement(Widget destination) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  void pushAndRemoveUntil(Widget destination) {
    Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(builder: (context) => destination),
      (route) => false,
    );
  }

  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  void navigateToAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(routeName, (route) => false,
        arguments: arguments);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // size of the screen
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  // double get screenWidth => MediaQuery.of(context).size.width

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isMobile => MediaQuery.of(this).size.width < 650;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 650 &&
      MediaQuery.of(this).size.width < 1100;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1100;

  // paddingLow
  EdgeInsets get paddingLow => const EdgeInsets.all(8.0);
  EdgeInsets get paddingLowTop => const EdgeInsets.only(top: 8.0);
  EdgeInsets get paddingLowBottom => const EdgeInsets.only(bottom: 8.0);
  EdgeInsets get paddingLowLeft => const EdgeInsets.only(left: 8.0);
  EdgeInsets get paddingLowRight => const EdgeInsets.only(right: 8.0);
  EdgeInsets get paddingLowHorizontal =>
      const EdgeInsets.symmetric(horizontal: 8.0);
  EdgeInsets get paddingLowVertical =>
      const EdgeInsets.symmetric(vertical: 8.0);

  // paddingMedium
  EdgeInsets get paddingMedium => const EdgeInsets.all(16.0);
  EdgeInsets get paddingMediumTop => const EdgeInsets.only(top: 16.0);
  EdgeInsets get paddingMediumBottom => const EdgeInsets.only(bottom: 16.0);
  EdgeInsets get paddingMediumLeft => const EdgeInsets.only(left: 16.0);
  EdgeInsets get paddingMediumRight => const EdgeInsets.only(right: 16.0);
  EdgeInsets get paddingMediumHorizontal =>
      const EdgeInsets.symmetric(horizontal: 16.0);
  EdgeInsets get paddingMediumVertical =>
      const EdgeInsets.symmetric(vertical: 16.0);

  // paddingLow
  EdgeInsets get marginLow => const EdgeInsets.all(8.0);
  EdgeInsets get marginLowTop => const EdgeInsets.only(top: 8.0);
  EdgeInsets get marginLowBottom => const EdgeInsets.only(bottom: 8.0);
  EdgeInsets get marginLowLeft => const EdgeInsets.only(left: 8.0);
  EdgeInsets get marginLowRight => const EdgeInsets.only(right: 8.0);
  EdgeInsets get marginLowHorizontal =>
      const EdgeInsets.symmetric(horizontal: 8.0);
  EdgeInsets get marginLowVertical => const EdgeInsets.symmetric(vertical: 8.0);

  // marginMedium
  EdgeInsets get marginMedium => const EdgeInsets.all(16.0);
  EdgeInsets get marginMediumTop => const EdgeInsets.only(top: 16.0);
  EdgeInsets get marginMediumBottom => const EdgeInsets.only(bottom: 16.0);
  EdgeInsets get marginMediumLeft => const EdgeInsets.only(left: 16.0);
  EdgeInsets get marginMediumRight => const EdgeInsets.only(right: 16.0);
  EdgeInsets get marginMediumHorizontal =>
      const EdgeInsets.symmetric(horizontal: 16.0);
  EdgeInsets get marginMediumVertical =>
      const EdgeInsets.symmetric(vertical: 16.0);

  // Colors
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get primaryColorLight => Theme.of(this).primaryColorLight;
  Color get primaryColorDark => Theme.of(this).primaryColorDark;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get cardColor => Theme.of(this).cardColor;
  Color get dividerColor => Theme.of(this).dividerColor;
  Color get focusColor => Theme.of(this).focusColor;
  Color get hoverColor => Theme.of(this).hoverColor;
  Color get highlightColor => Theme.of(this).highlightColor;
  Color get splashColor => Theme.of(this).splashColor;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
