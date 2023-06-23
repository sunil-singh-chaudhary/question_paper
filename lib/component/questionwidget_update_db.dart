import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/model/questionmodel.dart';

import '../services/updated_database_provider.dart';

void updateDatabasewithnewresult(
    int selectedvalue, BuildContext context, QuestionModel questionmodel) {
  final correctAnswer = questionmodel.correctAnswer;
  debugPrint('save daata in ddatabasse--> $correctAnswer');
  if (questionmodel.options![selectedvalue] == correctAnswer) {
    Provider.of<GetUpdateDataFromDatabase>(context, listen: false)
        .updateSelectedAnswer(
            count: 1,
            //Update correct answer into the  database
            questionId: questionmodel.id!,
            selectedAnswer: questionmodel.options![selectedvalue]);
  } else {
    Provider.of<GetUpdateDataFromDatabase>(context, listen: false)
        .updateSelectedAnswer(
            count: 0,
            //Update correct answer into the  database
            questionId: questionmodel.id!,
            selectedAnswer: questionmodel.options![selectedvalue]);
  }
}
