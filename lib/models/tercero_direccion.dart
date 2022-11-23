import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo tercero direccion
class TerceroDireccion { 
 
    final String id_tercero ;
    final String id_sucursal_tercero ;
    final String id_direccion ;
    final String direccion ; 
    final String id_pais ;
    final String id_depto ;
    final String id_ciudad ; 
    final String telefono ;   
    final String tipo_direccion ;   
    final String nit;

  const TerceroDireccion({
    required this.id_tercero,
    required this.id_sucursal_tercero, 
    required this.id_direccion,
    required this.direccion,
    required this.id_pais,
    required this.id_depto,
    required this.id_ciudad, 
    required this.telefono,   
    required this.tipo_direccion,
    required this.nit
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {    
      'id_tercero':id_tercero,
      'id_sucursal_tercero':id_sucursal_tercero,
      'id_direccion':id_direccion,
      'direccion':direccion, 
      'id_pais':id_pais,
      'id_depto':id_depto,
      'id_ciudad':id_ciudad, 
      'telefono':telefono, 
      'tipo_direccion':tipo_direccion, 
      'nit':nit, 
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
     return 'TerceroDireccion{   id_tercero:$id_tercero,  id_sucursal_tercero:$id_sucursal_tercero, id_direccion:$id_direccion,  direccion:$direccion,' 
     '  id_pais:$id_pais, id_depto:$id_depto,  id_ciudad:$id_ciudad,    telefono:$telefono,   tipo_direccion:$tipo_direccion, nit:$tipo_direccion  }';  }
}
