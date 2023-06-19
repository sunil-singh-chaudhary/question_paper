import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/services/updated_database_provider.dart';

import '../component/questionwidget.dart';

// ignore: must_be_immutable
class MCQScreen extends StatefulWidget {
  String fromwhere;
  int currentindex = 1;
  MCQScreen({super.key, required this.fromwhere});

  @override
  State<MCQScreen> createState() => _TestMCQState();
}

class _TestMCQState extends State<MCQScreen> {
  @override
  Widget build(BuildContext context) {
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
                      initialPage:
                          widget.currentindex), //page start from currentIndex
                  itemCount: value.updatedDataList.length - 1,
                  onPageChanged: (index) {
                    setState(() {
                      widget.currentindex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return QuestionWidget(
                      question: value.updatedDataList[index],
                      onAnswerSelected: (selectedAnswerposition) {
                        //get selected answer cllback
                        String? ans =
                            value //print the selected answer from the list of options
                                .updatedDataList[index]
                                .options![selectedAnswerposition];
                        debugPrint("selectd answer--$ans");

                        if (index < value.updatedDataList.length - 1) {
                          // Navigate to the next question
                          widget.currentindex++;
                        } else {
                          // All questions answered, do something
                          // e.g., show results or submit answers
                        }
                      },
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
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
          return Center(
            child: Text(
              '${widget.currentindex}/$count',
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
}
