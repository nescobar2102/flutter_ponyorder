import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de ciudad

class Ciudad { 
 
  final String id_pais;
  final String id_depto; 
  final String id_ciudad; 
  final String nombre; 
  final String nit; 

  const Ciudad(
      {
      required this.id_pais,
      required this.id_depto, 
      required this.id_ciudad, 
      required this.nombre,
      required this.nit
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_pais': id_pais,
      'id_depto': id_depto, 
      'id_ciudad': id_ciudad, 
      'nombre': nombre, 
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Ciudad {id_pais: $id_pais, id_depto: $id_depto,  id_ciudad: $id_ciudad, nombre: $nombre,nit: $nit }';
  }
}


class Barrio { 
 
  final String id_pais;
  final String id_depto; 
  final String id_ciudad; 
  final String id_barrio; 
  final String nombre; 
  final String nit; 

  const Barrio(
      {
      required this.id_pais,
      required this.id_depto, 
      required this.id_ciudad, 
      required this.id_barrio,
      required this.nombre,
      required this.nit
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_pais': id_pais,
      'id_depto': id_depto, 
      'id_ciudad': id_ciudad, 
       "id_barrio": id_barrio,
      'nombre': nombre, 
      'nit': nit
    };
  }
  

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Barrio {id_pais: $id_pais, id_depto: $id_depto,  id_ciudad: $id_ciudad, id_barrio:$id_barrio,nombre: $nombre,nit: $nit }';
  }
}


class Depto { 
 
  final String id_pais;
  final String id_depto;  
  final String nombre; 
  final String nit; 

  const Depto(
      {
      required this.id_pais,
      required this.id_depto,     
      required this.nombre,
      required this.nit
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_pais': id_pais,
      'id_depto': id_depto,        
      'nombre': nombre, 
      'nit': nit
    };
  }  

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Depto {id_pais: $id_pais, id_depto: $id_depto, nombre: $nombre,nit: $nit }';
  }
}
