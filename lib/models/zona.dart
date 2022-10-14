import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Clase del modelo de zona

class Zona {
  final String id_zona;
  final String descripcion;
  final String id_padre;
  final String nivel;
  final String es_padre;
  final String nit;

  const Zona(
      {required this.id_zona,
      required this.descripcion,
      required this.id_padre,
      required this.nivel,
      required this.es_padre,
      required this.nit});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_zona': id_zona,
      'descripcion': descripcion,
      'id_padre': id_padre,
      'nivel': nivel,
      'es_padre': es_padre,
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Zona {id_zona: $id_zona, descripcion: $descripcion,  id_padre: $id_padre, nivel: $nivel,es_padre:$es_padre,nit: $nit }';
  }
}
