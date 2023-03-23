import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _dbName = "sampoorna_local_db.db";
  static const _dbVersion = 1;

  //Student table
  static final _studentTable = 'students';
  static final studentId = 'id';
  static final fullName = 'full_name';
  static final adminssionNo = 'admission_no';
  static final absentFN = 'absent_FN';
  static final absentAN = 'absent_AN';
  static final status = 'status';
  static final totalAbsent = 'total_absent';
  static final studentCode = 'student_code';
  static final schoolID = 'school_id';
  static final batchName = 'batch_name';
  static final batchId = 'batch_id';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase() async {
    Directory direcotry = await getApplicationDocumentsDirectory();
    String path = join(direcotry.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_studentTable (
        $studentId INTEGER PRIMARY KEY, 
        $fullName TEXT NOT NULL, 
        $adminssionNo TEXT NOT NULL UNIQUE, 
        $absentFN INTEGER,
        $absentAN INTEGER,
        $status INETEGER,
        $totalAbsent REAL,
        $schoolID TEXT NOT NULL,
        $studentCode TEXT NOT NULL UNIQUE,
        $batchId TEXT NOT NULL,
        $batchName TEXT)''');
  }

  Future<int> insertStudent(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int studentId = await db.insert(_studentTable, row);
    return studentId;
  }

  Future<List<Map<String, dynamic>>> getStudentsFromLocal(
      dropdownBatchId) async {
    Database db = await instance.database;
    // return await db.query(_studentTable);
    return await db.query(_studentTable,
        //where: '$studentId = ?', whereArgs: [1]);
        where: '$batchId LIKE ?',
        whereArgs: ['%$dropdownBatchId%']);
  }

  Future<List<Map<String, dynamic>>> getStudentSearch(
      searchText, dropdownBatchId) async {
    Database db = await instance.database;
    // return await db.query(_studentTable);
    return await db.query(_studentTable,
        //where: '$studentId = ?', whereArgs: [1]);
        where: '$batchId LIKE ? AND $fullName LIKE ?',
        whereArgs: ['%$dropdownBatchId%', '%$searchText%']);
  }

  Future<void> delete() async {
    Directory direcotry = await getApplicationDocumentsDirectory();
    String path = join(direcotry.path, _dbName);
    await deleteDatabase(path);
    // Database db = await instance.database;
    //   return await db.delete(_studentTable, where: '$studentId = ?', whereArgs: [id]);
  }

  Future<int> studentDataDelete(batchId) async {
    Database db = await instance.database;
    return await db
        .delete(_studentTable, where: '$batchId = ?', whereArgs: [batchId]);
  }
}
