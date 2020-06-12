import 'dart:io';
import 'package:notekeeper/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton DatabaseHelper
  static Database _database; //Singleton database

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); //This is executed only once, singleton object
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) 
      _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    //Open/create the db at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //Fetch operation
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    return await db.query(noteTable, orderBy: '$colPriority ASC');
  }

  //Insert Operation
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    return await db.insert(noteTable, note.toMap());
  }

  //Update operation
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    return await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
  }

  //Delete operation
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    return await db.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
  }

  //Get number of Note objects
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    return Sqflite.firstIntValue(x);
  }

  //Get the 'Map List' [List<Map>] and convert to 'Note List' [List<Note>]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();

    for(int i=0; i<count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}