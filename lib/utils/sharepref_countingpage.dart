import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _sharedPreferences;

  static Future<void> initializeSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> getSharedPreferencesInstance() async {
    if (_sharedPreferences == null) {
      await initializeSharedPreferences();
    }
    return _sharedPreferences!;
  }

  static Future<int> getTotalQuestionCount() async {
    final prefs = await getSharedPreferencesInstance();
    return prefs.getInt('totalQuestionCount') ?? 1;
  }

  static Future<void> setTotalQuestionCount(int count) async {
    final prefs = await getSharedPreferencesInstance();
    debugPrint('last page save in index is -$count');

    await prefs.setInt('totalQuestionCount', count);
  }

  static gotoNextScreen(PageController _pageController) {
    Future.delayed(const Duration(seconds: 2), () {
      SharedPreferencesService.getTotalQuestionCount().then(
        (value) {
          int nextPage = value + 1;
          _pageController.animateToPage(
            nextPage,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 10),
          );
          debugPrint('Jumped to index $nextPage in shared preferences');
        },
      );
    });
  }

  static gotoLastUserloadsharedpref(PageController _pageController) {
    Future.delayed(const Duration(seconds: 2), () {
      SharedPreferencesService.getTotalQuestionCount().then(
        (value) {
          debugPrint('Jumped to value $value in shared preferences');

          int? nextPage;

          if (value == 1) {
            nextPage = value;
          } else {
            nextPage = value + 1;
          }
          debugPrint('Jumped to before index $nextPage in shared preferences');

          if (nextPage > 1) {
            _pageController.animateToPage(
              nextPage,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 10),
            );
          }

          debugPrint('Jumped to index $nextPage in shared preferences');
        },
      );
    });
  }
}
