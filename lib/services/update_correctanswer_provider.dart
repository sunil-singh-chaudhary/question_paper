import 'package:flutter/material.dart';

class GetUpdatedAnswer extends ChangeNotifier {
  int _correctAnswer = 0;
  int get correctAnswer => _correctAnswer;

  updatecorrectAnswer(int count) async {
    _correctAnswer = count;
    debugPrint('notifiy sum--$_correctAnswer');
    notifyListeners();
  }
}
