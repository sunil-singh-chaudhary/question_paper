// import 'dart:async';
// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import 'package:question_paper/questionmodel.dart';

// class RepositoryAPI {
//   final BASE_URL =
//       "https://question-generator-qh4u.onrender.com/questions?n=10";

//   Stream<QuestionModel> fetchQuestionsStream() {
//     final controller = StreamController<QuestionModel>();

//     http.get(Uri.parse(BASE_URL)).then((response) {
//       if (response.statusCode == 200) {
//         final questionList = json.decode(response.body);

//         for (var questionData in questionList) {
//           QuestionModel question = QuestionModel(
//             id: questionData['id'],
//             question: questionData['question'],
//             options: List<String>.from(questionData['options']),
//             correctAnswer: questionData['correctAnswer'],
//             explanation: questionData['explanation'],
//           );

//           controller.add(question);
//         }

//         controller.close();
//       } else {
//         // Handle HTTP error
//         controller.addError('HTTP Error: ${response.statusCode}');
//       }
//     }).catchError((error) {
//       // Handle other errors
//       controller.addError('Error: $error');
//     });

//     return controller.stream;
//   }
// }
