import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/screen/resultscreen.dart';
import 'package:question_paper/services/update_correctanswer_provider.dart';
import 'package:question_paper/services/updated_database_provider.dart';
import 'package:question_paper/utils/custom_extension.dart';

import '../component/questionwidget.dart';
import '../component/rightwipepageviewcontroller.dart';
import '../services/mcq_state_sum.dart';
import '../utils/lotie_animatino_loading.dart';
import '../utils/lottie_dialog_progressbar.dart';
import '../utils/sharepref_countingpage.dart';

// ignore: must_be_immutable
class MCQScreen extends StatefulWidget {
  String fromwhere;
  MCQScreen({super.key, required this.fromwhere});
  @override
  State<MCQScreen> createState() => _TestMCQState();
}

class _TestMCQState extends State<MCQScreen> {
  PageController? _pageController;
  bool showDialogInProgress = false;
  int currentindex = 0; //pageview index started from 0 position
  int? totalQuestions = 0;
  bool isLastAnswerGiven = false;
  SharedPreferencesService service = SharedPreferencesService();
  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    //it is important when user came back to check his answer and made any changes on those answer
    super.didChangeDependencies();
    MCQScreenLogic.loadTotalNumbergetByUser(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            SharedPreferencesService.getTotalQuestionCount().then((value) {
              int? nextPage;

              if (value == 1) {
                //if didnt answer yet start with 0 pgaeview start with 0
                nextPage = 0;
              } else {
                nextPage = value + 1;
                // increase one page where user last gave answer , after restart the app
              }
              setState(() {
                currentindex = nextPage!;
                debugPrint('goto $currentindex');
                _pageController = PageController(
                    initialPage: currentindex); // set last user location +1
              });
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      //currentindex+1 it start from 0 in pageview
                      '${currentindex + 1}/${value.totaldata}',
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
                                  setState(() {
                                    currentindex = indexx;
                                    debugPrint(
                                        'upar current ${indexx + 1} and $totalQuestions ');
                                    //page chagne index for cmparing with total pages
                                    final nextScreenProvider =
                                        Provider.of<GetUpdatedAnswer>(context,
                                            listen: false);

                                    if ((indexx + 1) == totalQuestions &&
                                        isLastAnswerGiven) {
                                      // nextscreen = true;
                                      nextScreenProvider.updateisLastAnswerGiven(
                                          true); // Set the nextscreen value to true
                                      // debugPrint('next screen -- $nextscreen');
                                      //show nextscreen result when all answer given by user
                                    } else {
                                      nextScreenProvider
                                          .updateisLastAnswerGiven(false);
                                    }
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return QuestionWidget(
                                    //Question widget
                                    questionModel: value.updatedDataList[index],
                                    onAnswerSelected: (selectedAnswerposition) {
                                      value
                                          //print the selected answer from the list of options
                                          .updatedDataList[index]
                                          .options![selectedAnswerposition];
                                      debugPrint(
                                          'curr ${index + 1} and tatolq- $totalQuestions and is $isLastAnswerGiven');
                                      if ((index + 1) == totalQuestions) {
                                        SharedPreferencesService
                                            .setTotalQuestionCount(index + 1);
                                        setState(() {
                                          isLastAnswerGiven = true;

                                          //show  button when last answer given by user
                                        });

                                        final nextScreenProvider =
                                            Provider.of<GetUpdatedAnswer>(
                                                context,
                                                listen: false);
                                        nextScreenProvider.updateisLastAnswerGiven(
                                            true); // Update the provider value

                                        //pageview last page didnt show onPageChanged so here we save lst user page answer
                                        SharedPreferencesService
                                            .setTotalQuestionCount(index + 1);
                                      } else {
                                        //Now Set Curret Page USer Visited in shredpreferences
                                        SharedPreferencesService
                                            .setTotalQuestionCount(index + 1);
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
                    Consumer<GetUpdatedAnswer>(
                      builder: (context, correctanservalues, child) =>
                          Visibility(
                        //check that answer on the lst page is give if given visible This Button
                        visible: correctanservalues.isNextScreen,
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          child: ElevatedButton(
                            onPressed: () {
                              final databaseProvider =
                                  Provider.of<GetUpdateDataFromDatabase>(
                                      context,
                                      listen: false);
                              MCQScreenLogic.loadTotalNumbergetByUser(context);
                              //get all data on click
                              setState(() {
                                showDialogInProgress = true; // Show the dialog
                              });

                              Future.delayed(const Duration(seconds: 3), () {
                                // Wait for 3 seconds to sync with database
                                setState(() {
                                  showDialogInProgress = false;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ChangeNotifierProvider.value(
                                      value: databaseProvider,
                                      child: ResultScreen(
                                        totalQuestions: totalQuestions!,
                                        correctAnswers:
                                            correctanservalues.correctAnswer,
                                        incorrectAnswers: (totalQuestions! -
                                            correctanservalues.correctAnswer),
                                      ),
                                    );
                                  }),
                                );
                              });
                            },
                            child: const Text(
                              'Check Result',
                              style: TextStyle(fontSize: 16),
                            ),
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
}
