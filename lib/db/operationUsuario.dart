import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


import '../models/usuario.dart';

class OperationUsuario {

  static Future<Database> _openDB() async {
     return  openDatabase(join(await getDatabasesPath(),'pony.db'),onCreate: (db,version){
       return db.execute("CREATE TABLE usuario(id INTEGER PRIMARY KEY, usuario TEXT, password TEXT,nit TEXT,id_tipo_doc_pe TEXT,id_tipo_doc_rc TEXT)",
       );
     }, version: 1);
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
    print("resultado de sql $res[0]['nit']");
    if(res.length>0){
      return res;
    }else{
      return null;
    }
  }
  static Future<void> insertUsuarios(Usuario usuario ) async {
    print("INSERTA a validar el usuario a la BD $usuario");
    Database database = await _openDB();
    int id1 = await database.rawInsert( "INSERT INTO usuario (usuario,password,nit,id_tipo_doc_pe,id_tipo_doc_rc)"
    "VALUES ('${usuario.usuario}', '${usuario.password}', '${usuario.nit}', '${usuario.id_tipo_doc_pe}', '${usuario.id_tipo_doc_rc}')");

  }

  static Future<void> deleteData( ) async {
    print("se borran todos los usuarios");
    Database database = await _openDB();
    await database.rawDelete('DELETE FROM usuario');
  }

}
