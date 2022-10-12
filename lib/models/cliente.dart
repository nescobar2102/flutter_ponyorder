import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//Clase del modelo de cliente

class Cliente {      
  final String id_tercero;
  final String id_sucursal_tercero;
  final String id_tipo_identificacion;
  final String dv;
  final String nombre;
  final String direccion;  
  final String id_pais;
  final String id_depto;
  final String id_ciudad;
  final String id_barrio;
  final String telefono; 
/*   final String cliente;*/
  final String fecha_creacion;
  final String nombre_sucursal;
  final String primer_apellido;
  final String segundo_apellido;
  final String primer_nombre;
  final String segundo_nombre; 
  final String e_mail; 
  final String nit; 
  final String id_tipo_empresa;  
  final String id_forma_pago; 
  final String id_lista_precio;
  final String id_precio_item;
  final String id_vendedor;
  final String id_suc_vendedor;
  final String id_medio_contacto;
  final String id_zona;
  final String flag_persona_nat;

  const Cliente(
      {  
          required this.id_tercero,
          required this.id_sucursal_tercero,
          required this.id_tipo_identificacion,
          required this.dv,
          required this.nombre,
          required this.direccion,  
          required this.id_pais,
          required this.id_depto,
          required this.id_ciudad,
          required this.id_barrio,
          required this.telefono,  
          required this.fecha_creacion,
          required this.nombre_sucursal,
          required this.primer_apellido,
          required this.segundo_apellido,
          required this.primer_nombre,
          required this.segundo_nombre,
          required this.e_mail,
          required this.nit,
          required this.id_tipo_empresa,
          required this.id_forma_pago,
          required this.id_lista_precio,
          required this.id_precio_item,
          required this.id_vendedor,
          required this.id_suc_vendedor,
          required this.id_medio_contacto,
          required this.id_zona,
          required this.flag_persona_nat
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
       
      'id_tercero': id_tercero,
      'id_sucursal_tercero': id_sucursal_tercero,
      'id_tipo_identificacion': id_tipo_identificacion,
      'dv': dv,
      'nombre': nombre,
      'direccion': direccion,
      'id_pais': id_pais,
      'id_depto': id_depto,
      'id_ciudad': id_ciudad,
      'id_barrio': id_barrio,
      'telefono': telefono,
      'fecha_creacion': fecha_creacion,
      'nombre_sucursal': nombre_sucursal,
      'primer_apellido': primer_apellido,
      'segundo_apellido': segundo_apellido,
      'primer_nombre': primer_nombre,
      'segundo_nombre': segundo_nombre,      
      'e_mail': e_mail,
      'nit': nit,
      'id_tipo_empresa': id_tipo_empresa,
      'id_forma_pago': id_forma_pago,
      'id_lista_precio':id_lista_precio,
      'id_precio_item':id_precio_item,
      'id_vendedor':id_vendedor,
      'id_suc_vendedor':id_suc_vendedor,
      'id_medio_contacto':id_medio_contacto,
      'id_zona':id_zona,
      'flag_persona_nat':flag_persona_nat
    };          
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Cliente{  id_tercero: $id_tercero, id_sucursal_tercero: $id_sucursal_tercero,'
           '  id_tipo_identificacion: $id_tipo_identificacion,  dv: $dv, nombre: $nombre, direccion: $direccion,'
           '  id_pais: $id_pais, id_depto: $id_depto, id_ciudad: $id_ciudad, id_barrio: $id_barrio,telefono: $telefono,fecha_creacion: $fecha_creacion,'
           '  nombre_sucursal: $nombre_sucursal, primer_apellido: $primer_apellido,'
           '  segundo_apellido: $segundo_apellido, primer_nombre: $primer_nombre,  segundo_nombre: $segundo_nombre, e_mail: $e_mail, nit: $nit,'
           ' id_tipo_empresa: $id_tipo_empresa,id_forma_pago: $id_forma_pago,id_lista_precio:$id_lista_precio, id_precio_item:$id_precio_item,id_vendedor:$id_vendedor,'
           ' id_suc_vendedor:$id_suc_vendedor,id_medio_contacto:$id_medio_contacto,id_zona:$id_zona,flag_persona_nat:$flag_persona_nat}';
  }
}
