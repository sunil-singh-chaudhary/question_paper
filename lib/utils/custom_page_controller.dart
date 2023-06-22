import 'package:flutter/material.dart';

class CustomPageController extends PageController {
  CustomPageController({int initialPage = 0, bool keepPage = true})
      : super(initialPage: initialPage, keepPage: keepPage);
  // @override                              //choice to swipe next not previous disble
  // Future<void> animateToPage(int page,
  //     {Duration duration = Duration.zero, Curve curve = Curves.ease}) {
  //   if (page > (this.page?.round() ?? 0)) {
  //     // Allow swiping to the next screen
  //     return super.animateToPage(page, duration: duration, curve: curve);
  //   } else {
  //     // Prevent swiping to the previous screen
  //     return Future.value();
  //   }
  // }

  // @override
  // Future<void> animateToPage(int page,
  //     {Duration duration = Duration.zero, Curve curve = Curves.ease}) {
  //   //disable swipe feature
  //   // Disable swiping to any page
  //   return Future.value();
  // }
}
