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
      elevation: 8,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question: $position',
              style: questionStyle,
            ),
            const SizedBox(height: 8),
            Text(
              model.question!,
              style: answerStyle,
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
              model.selectedAnswer!,
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
