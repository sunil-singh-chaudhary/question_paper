import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/quiz_card.dart';
import '../services/updated_database_provider.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Consumer<GetUpdateDataFromDatabase>(
        builder: (context, value, child) {
          if (value.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: value.updatedDataList.length,
              itemBuilder: (context, index) {
                return QuizCard(
                  position: index,
                  model: value.updatedDataList[index],
                );
              },
            );
          } else {
            return const Text("No data Found");
            // or show a different widget indicating no data
          }
        },
      ),
    );
  }
}
