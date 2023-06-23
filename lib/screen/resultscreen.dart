import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/bottomnavigationsection.dart';
import '../component/resultcontentsection.dart';
import '../services/updated_database_provider.dart';

class ResultScreen extends StatefulWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;

  const ResultScreen({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    //passing provider to next screen cause of different routes i.e
    final databaseProvider =
        Provider.of<GetUpdateDataFromDatabase>(context, listen: false);
//calculate percent of success and failure
    final double successPercentage =
        (widget.correctAnswers / widget.totalQuestions) * 100;
    final double failedPercentage =
        (widget.incorrectAnswers / widget.totalQuestions) * 100;

    return Scaffold(
      backgroundColor: const Color.fromARGB(244, 245, 249, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ContentSection(
            failedPercentage: failedPercentage,
            successPercentage: successPercentage,
            correctAnswers: widget.correctAnswers,
            totalQuestions: widget.totalQuestions,
            incorrectAnswers: widget.incorrectAnswers,
          ),
        ],
      ),
      bottomNavigationBar: //pass databaseprovidder because it is in different root so we can pass it to easily use it
          BottomNavigationBarSection(databaseProvider: databaseProvider),
    );
  }
}
