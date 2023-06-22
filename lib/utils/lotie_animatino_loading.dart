import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class LottieUtils {
  static Widget loadAnimationFromAsset(String assetPath,
      {double width = 200, double height = 200, BoxFit fit = BoxFit.contain}) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
