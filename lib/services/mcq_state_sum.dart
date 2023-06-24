import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_paper/services/update_correctanswer_provider.dart';
import 'package:question_paper/services/updated_database_provider.dart';

class MCQScreenLogic {
  static void loadTotalNumbergetByUser(BuildContext context) async {
    final provider =
        Provider.of<GetUpdateDataFromDatabase>(context, listen: false);
    final correctanswerProvider =
        Provider.of<GetUpdatedAnswer>(context, listen: false);

    try {
      List<Map<String, dynamic>> columallvalues =
          await provider.getTotalresultCount();

      int sum = 0;

      for (var map in columallvalues) {
        var value = map['result'];
        if (value != null && value is int) {
          sum += value;
        }
      }

      correctanswerProvider.updatecorrectAnswer(sum);
      debugPrint('correct sum in saperate class--$sum');
    } catch (error) {
      // Handle any potential errors here
      debugPrint('Error occurred while loading total number: $error');
    }
  }
}
