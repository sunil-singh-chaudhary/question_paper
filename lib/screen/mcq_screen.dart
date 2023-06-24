import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/screen/resultscreen.dart';
import 'package:question_paper/services/updated_database_provider.dart';
import 'package:question_paper/utils/custom_extension.dart';

import '../component/questionwidget.dart';
import '../component/rightwipepageviewcontroller.dart';
import '../utils/lotie_animatino_loading.dart';
import '../utils/lottie_dialog_progressbar.dart';
import '../utils/sharepref_countingpage.dart';

// ignore: must_be_immutable
class MCQScreen extends StatefulWidget {
  static final GlobalKey<_TestMCQState> mcqScreenStateKey =
      GlobalKey<_TestMCQState>();

  String fromwhere;
  MCQScreen({super.key, required this.fromwhere});

  @override
  State<MCQScreen> createState() => _TestMCQState();
}

class _TestMCQState extends State<MCQScreen> {
  PageController? _pageController;
  bool showDialogInProgress = false;
  int currentindex = 1;
  int? totalQuestions = 0;
  int correctanswer = 0;
  bool isLastAnswerGiven = false;
  bool nextscreen = false;
  SharedPreferencesService service = SharedPreferencesService();
  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    //it is important when use came back to check his answer and made any changes on those answer
    super.didChangeDependencies();
    _loadTotalNumbergetByUser();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          SharedPreferencesService.getTotalQuestionCount().then((value) {
            int? nextPage;

            if (value == 1) {
              nextPage = value;
            } else {
              nextPage = value +
                  1; // increase one page where user give answer on the last page after restart app
            }
            setState(() {
              currentindex = nextPage!;
              _pageController = PageController(
                  initialPage: nextPage); // set last user location +1
            });
          });
        },
      );
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
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
                        child: _pageController != null
                            ? PageView.builder(
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
                                      nextscreen = true;
                                      //show nextscreen result when all answer given by user
                                    } else {
                                      nextscreen = false;
                                    }
                                  });
                                },
                                itemBuilder: (context, index) {
                                  debugPrint(
                                      'db update--${value.updatedDataList[index]}');
                                  return QuestionWidget(
                                    questionModel: value.updatedDataList[index],
                                    onAnswerSelected: (selectedAnswerposition) {
                                      value
                                          //print the selected answer from the list of options
                                          .updatedDataList[index]
                                          .options![selectedAnswerposition];
                                      debugPrint('index page $index');

                                      if (currentindex == totalQuestions) {
                                        SharedPreferencesService
                                            .setTotalQuestionCount(
                                                index); //index start form 0
                                        setState(() {
                                          isLastAnswerGiven = true;
                                          //show  button when last answer given by user
                                        });
                                        //pageview last page didnt show onPageChanged so here we save lst user page answer
                                        SharedPreferencesService
                                            .setTotalQuestionCount(index);
                                      } else {
                                        //Now Set Curret Page USer Visited in shredpreferences
                                        SharedPreferencesService
                                            .setTotalQuestionCount(
                                                index); //index start form 0
                                        SharedPreferencesService.gotoNextScreen(
                                            _pageController!);
                                        //go to next page when any answer selected
                                      }
                                    },
                                  );
                                },
                              )
                            : Center(
                                child: LottieUtils.loadAnimationFromAsset(
                                    'assets/loading.json'),
                              ),
                      ),
                    ),
                    Visibility(
                      //check that answer on the lst page is give if given visible This Button
                      visible: nextscreen,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            final databaseProvider =
                                Provider.of<GetUpdateDataFromDatabase>(context,
                                    listen: false);
                            _loadTotalNumbergetByUser(); //get all data on click
                            setState(() {
                              showDialogInProgress = true; // Show the dialog
                            });

                            Future.delayed(const Duration(seconds: 3), () {
                              // Wait for 3 seconds
                              setState(() {
                                showDialogInProgress =
                                    false; // Hide the dialog after 3 seconds
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ChangeNotifierProvider.value(
                                    value: databaseProvider,
                                    child: ResultScreen(
                                      totalQuestions: totalQuestions!,
                                      correctAnswers: correctanswer,
                                      incorrectAnswers:
                                          (totalQuestions! - correctanswer),
                                    ),
                                  );
                                }),
                              );
                            });
                          },
                          child: const Text(
                            'Check Your Result',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                showDialogInProgress
                    ? const LottieDialog(
                        assetPath: 'assets/loading.json',
                        width: 200,
                        height: 200,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ));
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
