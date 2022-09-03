import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import '../models/usuario.dart';

class OperationUsuario {
  static Future<Database> _openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'ponyOrder.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE usuario(id INTEGER PRIMARY KEY, usuario TEXT, password INTEGER,nit TEXT,id_tipo_doc_pe TEXT,id_tipo_doc_rc TEXT)',
        );
      },
      version: 1,
    );
  }

  //insertar los usuarios
  static Future<void> insertUser(Usuario usuario) async {
    // Get a reference to the database.
    Database database = await _openDB();
    // In this case, replace any previous data.
    await database.insert('usuario', usuario.toMap());
  }

  // Obtiene todos los usuarios
  static Future<List<Usuario>> usuariosAll() async {
    // Get a reference to the database.
    Database database = await _openDB();
    final List<Map<String, dynamic>> usuarioMap =
        await database.query('usuario');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(usuarioMap.length, (i) {
      return Usuario(
        id: usuarioMap[i]['id'],
        usuario: usuarioMap[i]['usuario'],
        password: usuarioMap[i]['password'],
        nit: usuarioMap[i]['nit'],
        id_tipo_doc_pe: usuarioMap[i]['id_tipo_doc_pe'],
        id_tipo_doc_rc: usuarioMap[i]['id_tipo_doc_rc'],
      );
    });
  }
  //GET THE NO:OF NOTES

  /// Simple query with sqflite helper
  static Future getLogin(String usuario, String password) async {
    print("entra a validar el usuario a la BD");
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM usuario WHERE usuario = '$usuario' and password = '$password'");
/*     final res = await database.query('usuario',
        columns: ['id','usuario','nit','id_tipo_doc_pe','id_tipo_doc_rc','nit' ],
        where: '$usuario=?',
        whereArgs: [usuario]); */
    return res;
  }
}
