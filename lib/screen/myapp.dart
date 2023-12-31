import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/screen/mcq_screen.dart';
import 'package:question_paper/services/update_correctanswer_provider.dart';

import '../Qbloc/question_cubit.dart';
import '../services/updated_database_provider.dart';
import 'answersScreen.dart';
import 'question_paper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCQ Paper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          Provider<QuestionCubit>(
            create: (_) => QuestionCubit()..fetchQuestionsWebSocket(),
          ),
          ChangeNotifierProvider(
            create: (_) => GetUpdateDataFromDatabase()..getData(),
            child: Builder(
              builder: (context) {
                final databaseProvider = Provider.of<GetUpdateDataFromDatabase>(
                    context,
                    listen: false);

                if (databaseProvider.hasData) {
                  return Column(
                    children: [
                      QuestionPaper(),
                      const AnswerScreen(),
                    ],
                  );
                } else {
                  return const Text(
                      "No data Get From API"); // or show a different widget indicating no data
                }
              },
            ),
          ), //when app start it will fetch defaul db value
          ChangeNotifierProvider(
            create: (_) => GetUpdatedAnswer(),
            child: MCQScreen(),
          ),
        ],
        child: QuestionPaper(),
      ),
    );
  }
}
