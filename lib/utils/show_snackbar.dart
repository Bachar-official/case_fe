import 'package:flutter/material.dart';

void showSnackBar(
    GlobalKey<ScaffoldMessengerState> key, Color color, String message) {
  key.currentState!.showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(message),
    ),
  );
}
