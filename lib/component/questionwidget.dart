import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/model/questionmodel.dart';

import '../services/updated_database_provider.dart';

// ignore: must_be_immutable
class QuestionWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(int) onAnswerSelected;
  String? selectedRadioAnswer;
  List<bool> isSelectedList = List<bool>.filled(5, false);
  QuestionWidget(
      {super.key, required this.question, required this.onAnswerSelected});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            widget.question.question.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: List.generate(
              widget.question.options!.length,
              (index) {
                final option = widget.question.options![index];
                final result = widget.question.result;
                debugPrint("main reuslt-->$result, option $option");

                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0XFF001753),
                  ),
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        selectedValue = index;
                        widget.onAnswerSelected(selectedValue!);
                        Provider.of<GetUpdateDataFromDatabase>(context,
                                listen: false)
                            .updateSelectedAnswer(
                                //Update correct answer into the  database
                                questionId: widget.question.id!,
                                selectedAnswer: widget.question.correctAnswer!);
                        debugPrint("result-->$result, option $option");
                      });
                    },
                    title: Text(
                      widget.question.options![index],
                      style: TextStyle(
                        color: option == result ? Colors.green : Colors.white,
                      ),
                    ),
                    leading: Theme(
                      data: ThemeData(
                          unselectedWidgetColor:
                              option == result ? Colors.green : Colors.white),
                      child: Radio<int>(
                        activeColor:
                            option == result ? Colors.green : Colors.white,
                        value: index,
                        groupValue: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            widget.onAnswerSelected(selectedValue!);
                            Provider.of<GetUpdateDataFromDatabase>(context,
                                    listen: false)
                                .updateSelectedAnswer(
                                    //Update correct answer into the  database
                                    questionId: widget.question.id!,
                                    selectedAnswer:
                                        widget.question.correctAnswer!);
                            debugPrint("result-2->$result, option 2-$option");
                          });
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
}
