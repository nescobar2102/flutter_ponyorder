import 'package:app_pony_order/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'ponyorder.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE usuarios (nit, usuario, clave)",
      );
    }, version: 1);
  }

  static Future<int> insert(User user) async {
    Database database = await _openDB();
    return database.insert('usuarios', user.toMap());
  }

  static Future<int> delete(User user) async {
    Database database = await _openDB();
    return database.delete('usuarios', where: 'nit = ?', whereArgs: [user.nit]);
  }

  static Future<int> update(User user) async {
    Database database = await _openDB();
    return database.update('usuarios', user.toMap(),
        where: 'nit = ?', whereArgs: [user.nit]);
  }

  static Future<List<User>> usuarios() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> usuariosMap =
        await database.query("usuarios");
        
 for (var n in usuariosMap) {
      print("____" + n['usuario']);
    }
    return List.generate(
        usuariosMap.length,
        (i) => User(
            clave: usuariosMap[i]['clave'],
            nit: usuariosMap[i]['nit'],
            usuario: usuariosMap[i]['usuario']));
  }
}
