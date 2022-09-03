import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//import 'package:notebuddy/models/note.dart';

class DatabaseHelper {
  static final _dbName = "Database.db";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
 

  Future <Database> get database async{
    return _database ??= await initializeDatabase();
}
  String noteTable = 'usuarios';
  String colid = 'id';
  String colTitle = 'username';
  String colDescription = 'correo';
  String colDate = 'clave';
  String colPriority = 'estado';

 

  Future<Database> initializeDatabase() async {
    //GET THE PATH TO THE DIRECTORY FOR IOS AND ANDROID TO STORE DB
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "usuarios.db";

    //OPEN/CREATE THE DB AT A GIVEN PATH
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colid INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate INTEGER)');
  }

  //FETCH TO GET ALL NOTES
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result =
        db.rawQuery("SELECT * FROM $noteTable ORDER BY $colPriority ASC"); 
    return result;
  }

  //INSERT OPS
  Future<int> insertNote(note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //UPDATE OPS
  Future<int> updateNote(note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colid = ?', whereArgs: [note.id]);
    return result;
  }

  //DELETE OPS
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.delete(noteTable, where: "$colid = ?", whereArgs: [id]);
    return result;
  }

 /* //GET THE NO:OF NOTES
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $noteTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //GET THE 'MAP LIST' [List<Map>] and CONVERT IT TO 'Note List' [List<Note>]
  Future<List> getNoteList() async {
    var noteMapList = await getNoteMapList(); //GET THE MAPLIST FROM DB
    int count = noteMapList.length; //COUNT OF OBJS IN THE LIST
    List noteList = List();
    for (int index = 0; index < count; index++) {
      noteList.add(Note.fromMapObject(noteMapList[index]));
    }
    return noteList;
  }*/
}
