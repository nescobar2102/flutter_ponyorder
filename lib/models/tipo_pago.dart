import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de cuota venta

class TipoPago { 
 
  final String id_tipo_pago;
  final String descripcion; 
  final String nit; 

  const TipoPago(
      {required this.id_tipo_pago,
      required this.descripcion, 
      required this.nit
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_tipo_pago': id_tipo_pago,
      'descripcion': descripcion, 
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'TipoPago{id_tipo_pago: $id_tipo_pago, descripcion: $descripcion, nit: $nit }';
  }
}
