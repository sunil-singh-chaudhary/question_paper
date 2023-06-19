import 'databasehelper.dart';

class QuestionOption {
  List<String> options;

  QuestionOption({
    required this.options,
  });

  Map<String, dynamic> toMap() {
    return {
      coloumn_option:
          options.join(','), // Convert list to a comma-separated string
    };
  }

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      options: map[coloumn_option]
          .split(','), // Convert comma-separated string to a list
    );
  }
}
