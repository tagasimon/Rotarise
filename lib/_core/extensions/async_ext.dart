import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showSnackBarOnError(BuildContext context, {String? message}) {
    if (!isLoading && hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: message == null
              ? Text("Error ${error.toString()}", textAlign: TextAlign.center)
              : Text("Error $message", textAlign: TextAlign.center),
        ),
      );
    }
  }
}
