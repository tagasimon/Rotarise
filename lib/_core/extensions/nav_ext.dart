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
}
