import 'package:flutter/material.dart';
import 'package:question_paper/utils/custom_extension.dart';

void showLongSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.grey,
      content: Text(message,
          style: const TextStyle().withColorAndSize(Colors.white, 20)),
      duration: const Duration(seconds: 5), // Set the duration to 3 seconds
    ),
  );
}
