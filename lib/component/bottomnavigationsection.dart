import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/utils/custom_extension.dart';

import '../screen/answersScreen.dart';
import '../services/updated_database_provider.dart';

class BottomNavigationBarSection extends StatelessWidget {
  final databaseProvider;
  const BottomNavigationBarSection({super.key, required this.databaseProvider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<GetUpdateDataFromDatabase>.value(
                    value: databaseProvider,
                    // Provide the existing provider value to the new route
                    child: const AnswerScreen() //wrong answer
                    ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 50,
        color: Colors.grey[800],
        child: Center(
          child: Text(
            "Check all Answers",
            style: const TextStyle().withColorAndSize(Colors.white, 20),
          ),
        ),
      ),
    );
  }
}
