import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  final database = openDatabase(
    // Establecer la ruta a la base de datos. Nota: Usando la función `join` del
    // complemento `path` es la mejor práctica para asegurar que la ruta sea correctamente
    // construida para cada plataforma.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // Cuando la base de datos se crea por primera vez, crea una tabla para almacenar dogs
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
      );
    },
    // Establece la versión. Esto ejecuta la función onCreate y proporciona una
    // ruta para realizar actualizacones y defradaciones en la base de datos.
    version: 1,
  );

  Future<void> insertDog(Dog dog) async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Inserta el Dog en la tabla correcta. También puede especificar el
    // `conflictAlgorithm` para usar en caso de que el mismo Dog se inserte dos veces.
    // En este caso, reemplaza cualquier dato anterior.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    // Obtiene una referencia de la base de datos
    final Database db = await database;

    // Consulta la tabla por todos los Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convierte List<Map<String, dynamic> en List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Actualiza el Dog dado
    await db.update(
      'dogs',
      dog.toMap(),
      // Aseguúrate de que solo actualizarás el Dog con el id coincidente
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(Dog dog) async {
    // Obtiene una referencia de la base de datos
    final db = await database;

    // Elimina el Dog de la base de datos
    await db.delete(
      'dogs',
      // Utiliza la cláusula `where` para eliminar un dog específico
      where: "id = ?",
      // Pasa el id Dog a través de whereArg para prevenir SQL injection
      whereArgs: [dog.id],
    );
  }

  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );

  // Inserta un dog en la base de datos
  await insertDog(fido);

  // Imprime la lista de dogs (solamente Fido por ahora)
  print(await dogs());

  // Actualiza la edad de Fido y lo guarda en la base de datos
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // Imprime la información de Fido actualizada
  print(await dogs());

  // Elimina a Fido de la base de datos
  await deleteDog(fido);

  // Imprime la lista de dos (vacía)
  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id = 0, this.name = '', this.age = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implementa toString para que sea más fácil ver información sobre cada perro
  // usando la declaración de impresión.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
