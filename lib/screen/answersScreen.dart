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
    final databaseProvider =
        Provider.of<GetUpdateDataFromDatabase>(context, listen: false);
    debugPrint('databaseProvider--${databaseProvider.updatedDataList.length}');
    return Consumer<GetUpdateDataFromDatabase>(
      builder: (context, value, child) {
        if (value.hasData) {
          return ListView.builder(
            itemCount: value.updatedDataList.length,
            itemBuilder: (context, index) {
              return QuizCard(
                position: index,
                model: value.updatedDataList[index],
              );
            },
          );
        } else {
          return const Text(
              "No data Get From API"); // or show a different widget indicating no data
        }
      },
    );
  }
}
