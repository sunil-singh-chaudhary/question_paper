import 'package:flutter/material.dart';
import 'package:question_paper/database/databasehelper.dart';
import 'package:question_paper/model/questionmodel.dart';

class GetUpdateDataFromDatabase extends ChangeNotifier {
  List<QuestionModel> _data = [];
  final DatabaseHelper db = DatabaseHelper();

  List<QuestionModel> get updatedDataList => _data;
  bool _hasData =
      false; //for checking database has data or it is corrently empty

  bool get hasData => _hasData;

  Future<void> getData() async {
    _data = await db.getNoteList();
    if (_data.isNotEmpty) {
      _hasData = true;
    } else {
      _hasData = false;
    }
    notifyListeners();
  }

  Future<void> insertData(QuestionModel modelquestion) async {
    debugPrint('start inserting using id--${modelquestion.id}');
    bool isRecordExists = await db.isRecordExists(
        modelquestion.id); //check if id is already in db or skipping insertion
    if (!isRecordExists) {
      await db.insertNote(modelquestion);
      await getData();
    } else {
      debugPrint(
          'Record with id ${modelquestion.id} already exists. Skipping insertion.');
    }
  }

  Future<void> deleteData(String titles) async {
    debugPrint('start deleteing');
    await db.deleteTable(titles);
    await getData();
  }

  Future<int?> getTotalDbCount() async {
    int? count = await db.getCount();

    // await getData();
    return count;
  }

  Future<void> updateSelectedAnswer(
      {required String questionId, required String selectedAnswer}) async {
    await db.updateAnswer(questionId, selectedAnswer);
    await getData();
  }

  Future<List<Map<String, Object?>>> getresultFromDb() async {
    return await db.getIDResultfromColumn();
    // await getData();
  }
}
