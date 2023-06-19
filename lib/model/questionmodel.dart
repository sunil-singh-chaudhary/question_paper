import 'dart:convert';

class QuestionModel {
  String? id;
  String? question;
  List<String>? options;
  String? correctAnswer;
  String? explanation;
  String? result;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.result,
  });

  QuestionModel copyWith({
    String? id,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    String? result,
  }) =>
      QuestionModel(
        id: id ?? this.id,
        question: question ?? this.question,
        options: options ?? this.options,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        explanation: explanation ?? this.explanation,
        result: result ?? this.result,
      );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('id') ||
        !json.containsKey('question') ||
        !json.containsKey('options') ||
        !json.containsKey('correctAnswer') ||
        !json.containsKey('explanation')) {
      throw const FormatException('Unsupported format found from server');
    }
    return QuestionModel(
      id: json["id"],
      question: json["question"],
      options: List<String>.from(json["options"].map((x) => x)),
      correctAnswer: json["correctAnswer"],
      explanation: json["explanation"],
      result: json["result"],
    );
  }

  Map<String, dynamic> toJson() {
    final jsonOptions = jsonEncode(options);
    var trimmedOptions =
        jsonOptions.replaceAll('"', '').replaceAll('[', '').replaceAll(']', '');

    //removing [] and "" and insert into database by default value is ["Mosco"]

    return {
      "id": id,
      "question": question,
      "options": trimmedOptions,
      "correctAnswer": correctAnswer,
      "explanation": explanation,
      "result": result,
    };
  }

  static Map<String, dynamic> empty() => {
        "id": '0',
        "question": '0',
        "options": '0',
        "correctAnswer": '0',
        "explanation": '0',
        "result": '0',
      };
}
