import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de cuota venta

class Sale {
   
  final String venta;
  final String cuota;
  final String id_linea;
  final String nombre;
  final String nit;
  final String id_vendedor;
  final int id_suc_vendedor;

  const Sale(
      {required this.venta,
      required this.cuota,
      required this.id_linea,
      required this.nombre,
      required this.nit,
      required this.id_vendedor,
      required this.id_suc_vendedor});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'venta': venta,
      'cuota': cuota,
      'id_linea': id_linea,
      'nombre': nombre,
      'nit': nit,
      'id_vendedor': id_vendedor,
      'id_suc_vendedor': id_suc_vendedor
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Sale{venta: $venta, cuota: $cuota, id_linea: $id_linea,nombre: $nombre,nit: $nit,id_vendedor: $id_vendedor,id_suc_vendedor: $id_suc_vendedor}';
  }
}
