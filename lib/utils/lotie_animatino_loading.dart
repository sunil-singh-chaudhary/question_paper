import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:question_paper/utils/custom_extension.dart';

class LottieUtils {
  static Widget loadAnimationFromAsset(String assetPath,
      {double width = 200, double height = 200, BoxFit fit = BoxFit.contain}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.transparent,
          height: height,
          width: width,
          child: Lottie.asset(
            assetPath,
            width: width,
            height: height,
            fit: fit,
          ),
        ),
        Text(
          'Loading...',
          style: const TextStyle().withColorAndSize(Colors.red, 22),
        )
      ],
    );
  }
}
