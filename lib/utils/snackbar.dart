import 'package:flutter/material.dart';

void showLongSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        message,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      duration: const Duration(seconds: 10), // Set the duration to 10 seconds
    ),
  );
}
