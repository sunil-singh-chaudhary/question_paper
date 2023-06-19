// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:eventsource/eventsource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:question_paper/Qbloc/question_state.dart';
import 'package:question_paper/model/questionmodel.dart';

class QuestionCubit extends Cubit<QuestionState> {
  final BASE_URL =
      "https://question-generator-qh4u.onrender.com/questions?n=10";
  late EventSource? eventSource;
  QuestionCubit() : super(QuestionStatus.initial);

  void fetchQuestionsWebSocket() async {
    try {
      eventSource = await EventSource.connect(BASE_URL);
      eventSource!.listen((event) {
        emit(QuestionStatus.loading);
        final jsonData = event.data;
        // debugPrint('cubit--> $jsonData');
        final dataMap = jsonDecode(jsonData!);

        try {
          final question = QuestionModel.fromJson(dataMap);
          emit(onQuestionLoaded(question));
        } catch (e) {
          emit(QuestionError(e.toString()));
        }

        // Emit a new state with the updated list
      });
    } catch (e) {
      emit(QuestionError(e.toString()));
    }
  }

  void stopFetchingQuestions() {
    // eventSource!.close();
  }
}
