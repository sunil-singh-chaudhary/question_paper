import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieDialog extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const LottieDialog(
      {super.key,
      required this.assetPath,
      this.width = 200,
      this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Lottie.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
