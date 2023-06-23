import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/screen/resultscreen.dart';
import 'package:question_paper/services/updated_database_provider.dart';
import 'package:question_paper/utils/custom_extension.dart';

import '../component/questionwidget.dart';
import '../component/rightwipepageviewcontroller.dart';
import '../utils/sharepref_countingpage.dart';

// ignore: must_be_immutable
class MCQScreen extends StatefulWidget {
  String fromwhere;
  MCQScreen({super.key, required this.fromwhere});

  @override
  State<MCQScreen> createState() => _TestMCQState();
}

class _TestMCQState extends State<MCQScreen> {
  late final PageController _pageController = PageController();

  int currentindex = 1;
  int? totalQuestions = 0;
  int correctanswer = 0;
  bool isLastAnswerGiven = false;
  bool nextscreen = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferencesService.gotoLastUserloadsharedpref(
          _pageController); //user left last screen go on app start
    });
  }

  @override
  Widget build(BuildContext context) {
    refreshShowButton(); //show button on last screen to go to result screen by default it is invisible

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF01122E),
        actions: [
          Center(
            child: Consumer<GetUpdateDataFromDatabase>(
                builder: (context, value, child) {
              totalQuestions = value.totaldata;
              return Container(
                height: 35,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$currentindex/${value.totaldata}',
                    style: const TextStyle()
                        .withColorAndSize(const Color(0xFF01122E), 14),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      body: Center(
        child: Container(
          color: const Color(0xFF01122E),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Question",
                    style: const TextStyle().withColorAndSize(
                        Colors.black, 22)), //using custom extension
              ),
              const SizedBox(height: 22.0),
              Consumer<GetUpdateDataFromDatabase>(
                builder: (context, value, child) => Expanded(
                  child: PageView.builder(
                    // physics:
                    //     RightPageSwipeController(), // Disable left scrollling

                    controller: _pageController,
                    //set initialpage to 0 or lst page visited
                    itemCount: value.updatedDataList.length,
                    onPageChanged: (indexx) {
                      int adjustedIndex = indexx + 1;

                      setState(() {
                        currentindex = adjustedIndex;
                        //page chagne index for cmparing with total pages
                        if (currentindex == totalQuestions &&
                            isLastAnswerGiven) {
                          debugPrint('answergive done save sharepref');

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
                          value
                              //print the selected answer from the list of options
                              .updatedDataList[index]
                              .options![selectedAnswerposition];
                          debugPrint('index page $index');

                          if (currentindex == totalQuestions) {
                            SharedPreferencesService.setTotalQuestionCount(
                                index); //index start form 0
                            setState(() {
                              isLastAnswerGiven = true;
                              //show  button when last answer given by user
                            });
                            //pageview last page didnt show onPageChanged so here we save lst user page answer
                            SharedPreferencesService.setTotalQuestionCount(
                                index);

                            Future.delayed(const Duration(seconds: 1), () {
                              //updatin db and instatly geting value casue some error i.e take 2 second for fettching on last data update
                              _loadTotalNumbergetByUser();
                              //get corrrect anwer from db and sum them up
                            });
                          } else {
                            //Now Set Curret Page USer Visited in shredpreferences
                            SharedPreferencesService.setTotalQuestionCount(
                                index); //index start form 0
                            SharedPreferencesService.gotoNextScreen(
                                _pageController);
                          }

                          //go to next page when any answer selected
                        },
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: nextscreen,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      final databaseProvider =
                          Provider.of<GetUpdateDataFromDatabase>(context,
                              listen: false);

                      // Handle button press
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: databaseProvider,
                            // Provide the existing provider value to the new route
                            child: ResultScreen(
                              totalQuestions: totalQuestions!,
                              correctAnswers: correctanswer,
                              incorrectAnswers:
                                  (totalQuestions! - correctanswer),
                              //incorrect answer
                            ),
                          ),
                        ),
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

  void _loadTotalNumbergetByUser() async {
    final provider =
        Provider.of<GetUpdateDataFromDatabase>(context, listen: false);

    try {
      List<Map<String, dynamic>> columallvalues =
          await provider.getTotalresultCount();
      debugPrint('columallvalues--$columallvalues');

      int sum = 0;

      setState(() {
        for (var map in columallvalues) {
          var value = map['result'];
          if (value != null && value is int) {
            sum += value;
          }
        }
        correctanswer = sum;

        debugPrint('correct answer count--$correctanswer');
      });
    } catch (error) {
      // Handle any potential errors here
      debugPrint('Error occurred while loading total number: $error');
    }
  }
}
