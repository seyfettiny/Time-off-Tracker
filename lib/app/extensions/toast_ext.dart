import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

extension ShowToast on String {
  void showErrorToast() {
    showSimpleNotification(
      Text(this),
      background: Colors.red,
      foreground: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void showInfoToast() {
    showSimpleNotification(
      Text(this),
      background: Colors.blue,
      foreground: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
