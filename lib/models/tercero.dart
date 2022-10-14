import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de cuota venta

class Tercero { 
    final String id_tercero ;
    final String id_sucursal_tercero ;
    final String id_tipo_identificacion ;
    final String  dv ;
    final String nombre ;
     final String direccion ;
    final String  id_pais ;
    final String  id_depto ;
    final String id_ciudad ;
    final String  id_barrio ;
    final String telefono ;
    final String  id_actividad ;
    final String id_tipo_empresa ;
    final String  cliente ;
    final String fecha_creacion ;
    final String nombre_sucursal ;
    final String primer_apellido  ;
    final String  segundo_apellido ;
    final String  primer_nombre;
    final String  segundo_nombre;
    final String  flag_persona_nat;
    final String  estado_tercero;
    final String  vendedor;
    final String  id_lista_precio;
    final String  id_forma_pago;
    final String  usuario;
    final String  flag_enviado;
    final String  e_mail;
    final String  telefono_celular;
    final String  e_mail_fe;
    final String  nit;

  const Tercero(
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
     required this.id_actividad,
    required this.id_tipo_empresa,
    required this.cliente,
    required this.fecha_creacion,
    required this.nombre_sucursal,
    required this.primer_apellido ,
    required this.segundo_apellido,
    required this.primer_nombre,
    required this.segundo_nombre,
    required this.flag_persona_nat,
    required this.estado_tercero,
    required this.vendedor,
    required this.id_lista_precio,
    required this.id_forma_pago,
    required this.usuario,
    required this.flag_enviado,
    required this.e_mail,
    required this.telefono_celular,
    required this.e_mail_fe,
    required this.nit
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {    
      'id_tercero':id_tercero,
      'id_sucursal_tercero':id_sucursal_tercero,
      'id_tipo_identificacion':id_tipo_identificacion,
      'dv':dv,
      'nombre':nombre,
       'direccion':direccion,
      'id_pais':id_pais,
      'id_depto':id_depto,
      'id_ciudad':id_ciudad,
      'id_barrio':id_barrio,
      'telefono':telefono, 
      'id_actividad':id_actividad,
      'id_tipo_empresa':id_tipo_empresa,
      'cliente':cliente,
      'fecha_creacion':fecha_creacion,
      'nombre_sucursal':nombre_sucursal,
      'primer_apellido ':primer_apellido,
      'segundo_apellido':segundo_apellido,
      'primer_nombre':primer_nombre,
      'segundo_nombre':segundo_nombre,
      'flag_persona_nat':flag_persona_nat,
      'estado_tercero':estado_tercero,
      'vendedor':vendedor,
      'id_lista_precio':id_lista_precio,
      'id_forma_pago':id_forma_pago,
      'usuario':usuario,
      'flag_enviado':flag_enviado,
      'e_mail':e_mail,
      'telefono_celular':telefono_celular, 
      'e_mail_fe':e_mail_fe, 
      'nit':nit, 
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
     return 'Tercero {  id_tercero:$id_tercero,  id_sucursal_tercero:$id_sucursal_tercero, id_tipo_identificacion:$id_tipo_identificacion,  dv:$dv,' 
     ' nombre:$nombre, direccion:$direccion, id_pais:$id_pais, id_depto:$id_depto,  id_ciudad:$id_ciudad,  id_barrio:$id_barrio,  telefono:$telefono, id_actividad.$id_actividad   '
     ' id_tipo_empresa:$id_tipo_empresa,  cliente:$cliente,  fecha_creacion:$fecha_creacion,  nombre_sucursal:$nombre_sucursal,  primer_apellido :$primer_apellido,' 
     ' segundo_apellido:$segundo_apellido,  primer_nombre:$primer_nombre,  segundo_nombre:$segundo_nombre,  flag_persona_nat:$flag_persona_nat,  estado_tercero:$estado_tercero,' 
     ' vendedor:$vendedor,  id_lista_precio:$id_lista_precio,  id_forma_pago:$id_forma_pago, usuario:$usuario, flag_enviado:$flag_enviado,e_mail:$e_mail,' 
     ' telefono_celular:$telefono_celular,  e_mail_fe:$e_mail_fe,  nit:$nit, }';  }
}