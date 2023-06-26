import 'package:flutter/material.dart';
import 'package:question_paper/model/questionmodel.dart';

import '../utils/mytextstyle.dart';

class QuizCard extends StatelessWidget {
  final QuestionModel model;
  final int position;

  const QuizCard({
    Key? key,
    required this.position,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 7,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question:${position + 1} ',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              model.question!,
              style: questionStyle,
            ),
            const SizedBox(height: 16),
            const Text(
              'Correct Answer:',
              style: questionStyle,
            ),
            const SizedBox(height: 8),
            Text(
              model.correctAnswer!,
              style: const TextStyle(
                fontSize: 16,
                color: correctColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Answer:',
              style: questionStyle,
            ),
            const SizedBox(height: 8),
            Text(
              model.selectedAnswer ?? 'No Answer selected',
              style: TextStyle(
                fontSize: 16,
                color: model.correctAnswer == model.selectedAnswer
                    ? correctColor
                    : wrongColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Explanation:',
              style: questionStyle,
            ),
            const SizedBox(height: 8),
            Text(
              model.explanation!,
              style: explanationStyle,
            ),
          ],
        ),
      ),
    );
  }
}
