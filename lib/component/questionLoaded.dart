import 'package:flutter/material.dart';
import 'package:question_paper/model/questionmodel.dart';

// ignore: must_be_immutable
class QuestionLoadedView extends StatelessWidget {
  QuestionLoadedView({
    super.key,
    required this.kquestion,
    required this.onRefresh,
  });
  int count = 0;
  final List<QuestionModel> kquestion;
  final ValueGetter<Future<void>> onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: kquestion.length,
        itemBuilder: (context, index) {
          final user = kquestion[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                '${count++}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(user.question!),
            subtitle: Text(user.correctAnswer!),
          );
        },
      ),
    );
  }
}
