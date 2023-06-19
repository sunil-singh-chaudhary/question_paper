// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:question_paper/model/questionmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

String coloumn_option = 'options';

class DatabaseHelper {
  static Database? _database;
  static DatabaseHelper? _databaseHelper; //SINGLETON DataBase-HELPER
  StreamController<List<Map<String, dynamic>>>? _controller;
  DatabaseHelper._createInstance(); //NAMED CONST TO CREATE INSTANCE OF THE DBHELPER

  String question_Table = 'question_table';
  String id = 'id';
  String coloumn_question = 'question';
  String coloumn_correctAnswer = 'correctAnswer';
  String coloumn_explanation = 'explanation';
  String coloumn_result = 'result';

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get instance async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    //GET THE PATH TO THE DIRECTORY FOR IOS AND ANDROID TO STORE DB
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}MCQ.db";

    debugPrint('DB open and path is ${directory.path}MCQ.db');

    //OPEN/CREATE THE DB AT A GIVEN PATH
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
    CREATE TABLE $question_Table (
      $id TEXT,
      $coloumn_option TEXT,
      $coloumn_question TEXT,
      $coloumn_correctAnswer TEXT,
      $coloumn_explanation TEXT,
      $coloumn_result TEXT
    )
  ''');
  }

  //INSERT OPS
  Future<int> insertNote(QuestionModel note) async {
    debugPrint('inserting question ${note.question}');
    Database db = await instance;
    var result = await db.insert(question_Table, note.toJson());
    return result;
  }

  //GET THE NO:OF NOTES
  Future<int?> getCount() async {
    Database db = await instance;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $question_Table");
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  //GET THE 'MAP LIST' [List<Map>] and CONVERT IT TO 'Note List' [List<QuestionModel>]
  Future<List<QuestionModel>> getNoteList() async {
    var questionMapList = await getNoteMapList();

    List<QuestionModel> questionList = [];

    try {
      for (final questionMap in questionMapList) {
        String optionsString = questionMap['options'] ??
            ''; //getting questionMap in String formate
        List<String> options =
            optionsString.split(','); //covert it into list again

        var question = QuestionModel(
          id: questionMap['id'],
          question: questionMap['question'],
          options: options,
          correctAnswer: questionMap['correctAnswer'],
          explanation: questionMap['explanation'],
          result: questionMap['result'],
        );

        questionList.add(question);
      }
    } on FormatException catch (e) {
      // emit(QuestionError(e.toString()));
      debugPrint('server Data mismatch error--> ${e.toString()}');
    }
    return questionList;
  }

  //FETCH TO GET ALL NOTES
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await instance;
    var result = await db.rawQuery("SELECT * FROM $question_Table");
    // debugPrint('get from db--$result');
    //var result = await db.query(noteTable, orderBy: "$colPriority ASC");  //WORKS THE SAME CALLED HELPER FUNC
    return result;
  }

  Future<void> deleteTable(String titles) async {
    debugPrint('deleting...');
    var db = await instance;
    await db.delete(question_Table, where: "title = ?", whereArgs: [titles]);

    await db.query(question_Table);
  }

  Future<void> close() async {
    Database db = await instance;
    await _controller!.close();
    await db.close();
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await instance;

    return await db.query(question_Table);
  }

//check already data in database return empty if not found any existing data
  Future<bool> isRecordExists(String? id) async {
    final db = await instance;

    final result = await db.query(
      question_Table,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }

  Future<void> updateAnswer(String questionId, String selectedAnswer) async {
    Database db = await instance;

    db.update(question_Table, {coloumn_result: selectedAnswer},
        where: '$id = ?', whereArgs: [questionId]);
    debugPrint(
        'Update database with iD $questionId and result is $selectedAnswer');
  }

//get the correct answer from database using ID
  Future<List<Map<String, dynamic>>> getValueById(String? questionId) async {
    final db = await instance;
    final List<Map<String, dynamic>> result = await db.query(
      question_Table, columns: [coloumn_result],
      where: '$id = ?', // Use the ID column name
      whereArgs: [questionId], // Pass the ID as the argument
      // limit: 1, // Limit the query to one result
    );

    if (result.isNotEmpty) {
      // final row = result.first;
      // return row[coloumn_result]; // Return the value of the specified column
      return result;
    } else {
      debugPrint("No matching result found in databse");
      return []; // Return an empty list
    }
  }

  Future<List<Map<String, Object?>>> getIDResultfromColumn() async {
    final db = await instance;

    final result =
        await db.query(question_Table, columns: [id, coloumn_result]);

    return result;
  }
}
