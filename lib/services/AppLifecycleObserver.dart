import 'package:flutter/material.dart';

import '../utils/internet_service.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final InternetConnectivity internetConnectionChecker;

  AppLifecycleObserver(this.internetConnectionChecker);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed, start monitoring internet connectivity
      internetConnectionChecker.stopMonitoring();
      debugPrint('start monitoring internet');
    } else if (state == AppLifecycleState.paused) {
      debugPrint('stop monitoring internet on paused');

      // App paused, stop monitoring internet connectivity
      internetConnectionChecker.stopMonitoring();
    } else if (state == AppLifecycleState.detached) {
      debugPrint('stop monitoring internet on detached');

      // App paused, stop monitoring internet connectivity
      internetConnectionChecker.stopMonitoring();
    }
  }
}
