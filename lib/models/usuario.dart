import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
/* 
void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'ponyOrder_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY, user TEXT, password INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<User>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        user: maps[i]['user'],
        password: maps[i]['password'],
        nit: maps[i]['nit'],
      );
    });
  }

  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  // Create a Dog and add it to the dogs table
  var fido = const User(
    id: 0,
    user: 'Fido',
    password: 35,
    nit: '2893742834',
  );

  await insertUser(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await dogs()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = User(
    id: fido.id,
    user: fido.user,
    password: fido.password,
    nit: fido.nit,
  );
  await updateUser(fido);

  // Print the updated results.
  print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteUser(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
}
 */
//Clase del modelo de usuario

class Usuario {
  final String usuario;
  final String clave;
  final String nit;
  final String id_tipo_doc_rc;
  final String id_tipo_doc_pe;
  final String id_bodega;
  final String flag_activo;
  final String flag_cambia_fp;
  final String flag_cambia_lp;
  final String flag_edita_cliente;
  final String flag_edita_dcto;
  final String edita_consecutivo_rc;
  final String edita_fecha_rc;
  final String id_tipo_doc_fac;
  final String flag_mobile;


  const Usuario(
      {
      required this.usuario,
      required this.clave,
      required this.nit,
      required this.id_tipo_doc_pe,
      required this.id_tipo_doc_rc,
      required this.id_bodega,
      required this.flag_activo,
      required this.flag_cambia_fp,
      required this.flag_cambia_lp,
      required this.flag_edita_cliente,
      required this.flag_edita_dcto,
      required this.edita_consecutivo_rc,
      required this.edita_fecha_rc,
      required this.id_tipo_doc_fac,
      required this.flag_mobile,
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'clave': clave,
      'nit': nit,
      'id_tipo_doc_pe': id_tipo_doc_pe,
      'id_tipo_doc_rc': id_tipo_doc_rc,
      'id_bodega' : id_bodega,
      'flag_activo' : flag_activo,
      'flag_cambia_fp' : flag_cambia_fp,
      'flag_cambia_lp' : flag_cambia_lp,
      'flag_edita_cliente' : flag_edita_cliente,
      'flag_edita_dcto' : flag_edita_dcto,
      'edita_consecutivo_rc' : edita_consecutivo_rc,
      'edita_fecha_rc' : edita_fecha_rc,
      'id_tipo_doc_fac' : id_tipo_doc_fac,
      'flag_mobile' : flag_mobile
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Usuario{ usuario: $usuario, clave: $clave,id_tipo_doc_pe: $id_tipo_doc_pe,id_tipo_doc_rc: $id_tipo_doc_rc,id_bodega: $id_bodega ,'
    ' flag_activo : $flag_activo, flag_cambia_fp : $flag_cambia_fp, flag_cambia_lp : $flag_cambia_lp, flag_edita_cliente : $flag_edita_cliente,'
    ' flag_edita_dcto : $flag_edita_dcto, edita_consecutivo_rc : $edita_consecutivo_rc, edita_fecha_rc : $edita_fecha_rc, id_tipo_doc_fac : $id_tipo_doc_fac,'
    ' flag_mobile : $flag_mobile }';
  }
}
