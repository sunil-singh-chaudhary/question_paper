import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/bottomnavigationsection.dart';
import '../component/resultcontentsection.dart';
import '../services/updated_database_provider.dart';
import '../utils/drawstars.dart';

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
  late ConfettiController _controllerCenter; //confetti animation
  double? successPercentage;
  double? failedPercentage;
  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //passing provider to next screen cause of different routes i.e
    final databaseProvider =
        Provider.of<GetUpdateDataFromDatabase>(context, listen: false);
    //calculate percent of success and failure
    successPercentage = (widget.correctAnswers / widget.totalQuestions) * 100;
    failedPercentage = (widget.incorrectAnswers / widget.totalQuestions) * 100;
    successPercentage! > 75
        ? _controllerCenter.play()
        : null; //play star animation in result screen when answer is 75 percent and above

    return ConfettiWidget(
      //show confetti starsss
      confettiController: _controllerCenter,
      blastDirectionality: BlastDirectionality
          .explosive, // don't specify a direction, blast randomly
      shouldLoop: false, // start again as soon as the animation is finished
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ], // manually specify the colors to be used
      createParticlePath: drawStar,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(244, 245, 249, 255),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContentSection(
              failedPercentage: failedPercentage!,
              successPercentage: successPercentage!,
              correctAnswers: widget.correctAnswers,
              totalQuestions: widget.totalQuestions,
              incorrectAnswers: widget.incorrectAnswers,
            ),
          ],
        ),
        bottomNavigationBar: //pass databaseprovider because it is in different root so we can pass it to easily use it
            BottomNavigationBarSection(databaseProvider: databaseProvider),
      ),
    );
  }
}
