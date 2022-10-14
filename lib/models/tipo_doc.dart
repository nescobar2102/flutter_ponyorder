import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de tipodoc

class TipoDoc {
   
  final String id_empresa;
  final String id_sucursal;
  final String id_clase_doc;
  final String id_tipo_doc;
  final int consecutivo;
  final String descripcion;
  final String nit;
 

  const TipoDoc(
      {required this.id_empresa,
      required this.id_sucursal,
      required this.id_clase_doc,
      required this.id_tipo_doc,
      required this.consecutivo,
      required this.descripcion,
      required this.nit});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_empresa': id_empresa,
      'id_sucursal': id_sucursal,
      'id_clase_doc': id_clase_doc,
      'id_tipo_doc': id_tipo_doc,
      'consecutivo': consecutivo,
      'descripcion': descripcion,
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'TipoDoc {id_empresa: $id_empresa, id_sucursal: $id_sucursal, id_clase_doc: $id_clase_doc,id_tipo_doc: $id_tipo_doc,consecutivo: $consecutivo,descripcion: $descripcion,nit: $nit}';
  }
}
