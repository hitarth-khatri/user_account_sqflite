// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task1/model/user_model.dart';

class DatabaseHelper {
  static const _databaseName = "userdb.db";
  static const _databaseVersion = 1;

  static const table = 'user_table';
  static const columnName = 'username';
  static const columnNumber = 'number';
  static const columnEmail = 'email';
  static const columnPass = 'password';
  static const columnGender = 'gender';
  static const columnDOB = 'birthDate';


  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();

  //initialize database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // create database
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  //create table
  Future _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE $table($columnName TEXT NOT NULL,$columnNumber INTEGER, $columnEmail TEXT NOT NULL, $columnPass TEXT NOT NULL, $columnGender TEXT NOT NULL, $columnDOB TEXT)");
  }

  //insert data
  Future<int> insert(User user) async {
    Database db = await instance.database;
    return await db.insert(table, {columnName: user.username,columnNumber: user.number, columnEmail: user.email, columnPass: user.password, columnGender:user.gender, columnDOB:user.birthDate,});
  }

  //display data
  Future getUser(String email, String password) async {
    Database db = await instance.database;
    var res = await db.rawQuery("SELECT * FROM $table WHERE $columnEmail = '$email' AND $columnPass = '$password'");
    if (res.isNotEmpty){
      return User.fromJson(res.first);
    }
    return null;
  }

  //get all data
  Future getAllUsers() async {
    Database db = await instance.database;
    return await db.query(table,columns: [columnName , columnEmail, columnNumber, columnGender, columnPass, columnDOB],);
  }

  // //update data
  Future update(User user) async {
    Database db = await instance.database;
    String email = user.toJson()['email'];
    return await db.update(
      table,
      user.toJson(),
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
  }
  // //delete data
  Future delete(String email) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnEmail = ?', whereArgs: [email]);
  }

}