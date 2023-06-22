import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/model/questionmodel.dart';
import 'package:question_paper/utils/custom_extension.dart';

import '../services/updated_database_provider.dart';

// ignore: must_be_immutable
class QuestionWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(int) onAnswerSelected;
  String? selectedRadioAnswer;
  String? userSavedresult;
  List<bool> isSelectedList = List<bool>.filled(5, false);

  QuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, //chagne gravity of options
        children: [
          Text(widget.question.question.toString(),
              style: const TextStyle()
                  .withColorAndSize(Colors.white, 22)), //custom extension
          const SizedBox(height: 16),
          Column(
            children: List.generate(
              widget.question.options!.length,
              (index) {
                //get database result and set radio button checked
                //getresultFromDdusingID
                Provider.of<GetUpdateDataFromDatabase>(context)
                    .getresultFromDdusingID(widget.question.id!)
                    .then((value) {
                  // debugPrint('value-- $value');
                  if (mounted) {
                    setState(() {
                      widget.userSavedresult = value;
                    });
                  }
                  //Update User Result
                });

                if (widget.userSavedresult != null) {
                  // Value exists in the database
                  // Compare the value with a condition and set the selected value accordingly
                  if (widget.userSavedresult ==
                      widget.question.options![index]) {
                    selectedValue = index;
                  } else {
                    selectedValue = null;
                    // No condition matched, deselect all radio buttons
                  }
                } else {
                  // No value in the database, deselect all radio buttons
                  selectedValue = null;
                }

                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: selectedValue != null && index == selectedValue!
                        ? const Color.fromARGB(255, 10, 63, 196)
                        : const Color(0XFF001753),
                  ), //
                  child: ListTile(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          selectedValue = index;
                        });
                      }
                      widget.onAnswerSelected(
                          selectedValue!); //callback for getting value selected
                      updateDatabasewithnewresult(selectedValue!, context);
                    },
                    title: Text(
                      widget.question.options![index],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    leading: Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.white),
                      child: Radio<int>(
                        activeColor: Colors.white,
                        value: index,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              selectedValue = value!;
                            });
                          }
                          widget.onAnswerSelected(selectedValue!); //callback
                          updateDatabasewithnewresult(selectedValue!, context);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateDatabasewithnewresult(int selectedvalue, BuildContext context) {
    final correctAnswer = widget.question.correctAnswer;
    debugPrint('save daata in ddatabasse--> $correctAnswer');
    if (widget.question.options![selectedvalue] == correctAnswer) {
      Provider.of<GetUpdateDataFromDatabase>(context, listen: false)
          .updateSelectedAnswer(
              count: 1,
              //Update correct answer into the  database
              questionId: widget.question.id!,
              selectedAnswer: widget.question.options![selectedValue!]);
    } else {
      Provider.of<GetUpdateDataFromDatabase>(context, listen: false)
          .updateSelectedAnswer(
              count: 0,
              //Update correct answer into the  database
              questionId: widget.question.id!,
              selectedAnswer: widget.question.options![selectedValue!]);
    }
  }
}
