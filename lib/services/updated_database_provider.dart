import 'package:flutter/material.dart';
import 'package:question_paper/database/databasehelper.dart';
import 'package:question_paper/model/questionmodel.dart';

class GetUpdateDataFromDatabase extends ChangeNotifier {
  final DatabaseHelper db = DatabaseHelper();

  List<QuestionModel> _data = [];
  List<QuestionModel> get updatedDataList => _data;

  bool _hasData = false;
  //for checking database has data or it is corrently empty
  bool get hasData => _hasData;

  String? _savedResult;
  String? get savedResult => _savedResult;

  Future<void> getData() async {
    _data = await db.getNoteList();
    if (_data.isNotEmpty) {
      _hasData = true;
    } else {
      _hasData = false;
    }
    notifyListeners();
  }

  Future<void> getSavedResult(String sved) async {
    _savedResult = sved;
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

  Future<void> deleteData(String id) async {
    debugPrint('start deleteing');
    await db.deleteTable(id);
    await getData();
  }

  Future<int?> getTotalDbCount() async {
    int? count = await db.getCount();
    return count;
  }

  Future<List<Map<String, dynamic>>> getTotalresultCount() async {
    return await db.getTotalNumber();
  }

  Future<void> updateSelectedAnswer(
      {required String questionId,
      required int count,
      required String selectedAnswer}) async {
    await db.updateAnswer(questionId, count, selectedAnswer);
    await getData(); //after apdate recents answer call databse latest data
  }

  Future<String> getresultFromDdusingID(String questionid) async {
    String answer = await db.getValueById(questionid);
    // debugPrint('user answer in Database--$answer');

    return answer;
  }
}
