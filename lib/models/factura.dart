import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de cuota venta

class Factura {
    
      final String id_tercero;
      final String numero;
      final String fecha;
      final String total_fac;
      final String id_item;
      final String descripcion_item;
      final String precio;
      final String cantidad;
      final String total;

  const Factura(
      {required this.id_tercero,
      required this.numero,
      required this.fecha,
      required this.total_fac,
      required this.id_item,
      required this.descripcion_item,
      required this.precio,
      required this.cantidad,
      required this.total});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_tercero': id_tercero,
      'numero': numero,
      'fecha': fecha,
      'total_fac': total_fac,
      'id_item': id_item,
      'descripcion_item': descripcion_item,
      'precio': precio,
      'cantidad': cantidad,
      'total': total
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Factura {id_tercero: $id_tercero, numero: $numero, fecha: $fecha,total_fac: $total_fac,id_item: $id_item,'
            ' descripcion_item: $descripcion_item,precio: $precio,cantidad: $cantidad,total: $total}';
  }
}
