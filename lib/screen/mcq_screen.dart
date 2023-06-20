import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/screen/resultscreen.dart';
import 'package:question_paper/services/updated_database_provider.dart';

import '../component/questionwidget.dart';

// ignore: must_be_immutable
class MCQScreen extends StatefulWidget {
  String fromwhere;
  MCQScreen({super.key, required this.fromwhere});

  @override
  State<MCQScreen> createState() => _TestMCQState();
}

class _TestMCQState extends State<MCQScreen> {
  final PageController _pageController = PageController();
  int currentindex = 1;
  int totalQuestions = 0;
  int correctanswer = 0;
  bool isLastAnswerGiven = false;
  bool nextscreen = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider =
        Provider.of<GetUpdateDataFromDatabase>(context, listen: false);
    refreshShowButton();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF01122E),
        actions: [
          Center(
            child: Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: buildCountWidget(),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: const Color(0xFF01122E),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Question;",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 22.0),
              Consumer<GetUpdateDataFromDatabase>(
                builder: (context, value, child) => Expanded(
                    child: PageView.builder(
                  controller: PageController(
                      initialPage: currentindex), //page start from currentIndex
                  itemCount: value.updatedDataList.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentindex = index + 1;
                      if (currentindex == totalQuestions && isLastAnswerGiven) {
                        // _loadTotalNumbergetByUser();
                        nextscreen = true;
                        //show nextscreen result when all answer given by user
                      } else {
                        nextscreen = false;
                      }
                    });
                  },
                  itemBuilder: (context, index) {
                    return QuestionWidget(
                      question: value.updatedDataList[index],
                      onAnswerSelected: (selectedAnswerposition) {
                        //get selected answer cllback
                        value //print the selected answer from the list of options
                            .updatedDataList[index]
                            .options![selectedAnswerposition];
                        // debugPrint("selectd answer--$ans");
                        _loadTotalNumbergetByUser(); //get corrrect anwer from db and sum them up
                        if (currentindex == totalQuestions) {
                          setState(() {
                            isLastAnswerGiven =
                                true; //show  button when last answer given by user
                          });
                        }
                      },
                    );
                  },
                )),
              ),
              Visibility(
                visible: nextscreen,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value:
                                databaseProvider, // Provide the existing provider value to the new route
                            child: ResultScreen(
                              totalQuestions: totalQuestions,
                              correctAnswers: correctanswer,
                              incorrectAnswers: (totalQuestions -
                                  correctanswer), //wrong answer
                            ),
                          ),
                        ),
                        // MaterialPageRoute(
                        //   builder: (context) => ResultScreen(
                        //     totalQuestions: totalQuestions,
                        //     correctAnswers: correctanswer,
                        //     incorrectAnswers:
                        //         (totalQuestions - correctanswer), //wrong answer
                        //   ),
                        // ),
                      );
                    },
                    child: const Text(
                      'check Your Result',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refreshShowButton() {
    setState(() {
      if (currentindex == totalQuestions && isLastAnswerGiven) {
        nextscreen = true;
        //show nextscreen result when all answer given by user
      } else {
        nextscreen = false;
      }
    });
  }

  Widget buildCountWidget() {
    return FutureBuilder<int?>(
      future: Provider.of<GetUpdateDataFromDatabase>(context, listen: false)
          .getTotalDbCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, show a progress indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If there was an error, show an error message
          return const Text('Error');
        } else {
          // If the future completed successfully, show the count
          final count = snapshot.data;
          totalQuestions = count ?? 0;
          debugPrint('total quesitonpage--$totalQuestions');
          return Center(
            child: Text(
              '$currentindex/$count',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01122E),
              ),
            ),
          );
        }
      },
    );
  }

  void _loadTotalNumbergetByUser() {
    final provider =
        Provider.of<GetUpdateDataFromDatabase>(context, listen: false);
    provider.getTotalresultCount().then((count) {
      setState(() {
        List<Map<String, dynamic>> columallvalues = count;
        int sum = columallvalues
            .map((map) => map['result'])
            .where((value) => value != null && value is int)
            .map((value) => value as int)
            .reduce((value1, value2) => value1 + value2);
        setState(() {
          correctanswer = sum; //count all correct answer here
        });

        print('Sum: $sum');
      });
    });
  }
}
