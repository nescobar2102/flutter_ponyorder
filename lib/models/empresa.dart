import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de cuota venta

class Empresa { 

      final String razon_social;
      final String id_tipo_empresa; 
      final String pre_actividad_economica; 
      final String pre_cuenta; 
      final String pre_medio_contacto; 
      final String id_moneda;
      final String direccion; 
      final String telefono; 
      final String dv; 
      final String fax; 
      final String id_pais; 
      final String id_depto; 
      final String id_ciudad; 
      final String regimen_tributario;
      final String flag_iva; 
      final String flag_forma_pago_efectivo; 
      final String correo_electronico; 
      final String id_empresa; 
      final String estado; 
      final String nit;        
    
  const Empresa(
      {
        required this.razon_social,
        required this.id_tipo_empresa,      
        required this.pre_actividad_economica,
        required this.pre_cuenta,
        required this.pre_medio_contacto,
        required this.id_moneda,
        required this.direccion,
        required this.telefono,
        required this.dv,
        required this.fax,
        required this.id_pais,
        required this.id_depto,
        required this.id_ciudad,
        required this.regimen_tributario,
        required this.flag_iva,
        required this.flag_forma_pago_efectivo,
        required this.correo_electronico,
        required this.id_empresa,
        required this.estado,
        required this.nit
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
        return {
          'razon_social': razon_social,
          'id_tipo_empresa': id_tipo_empresa, 
          'pre_actividad_economica': pre_actividad_economica, 
          'pre_cuenta': pre_cuenta, 
          'pre_medio_contacto': pre_medio_contacto, 
          'id_moneda': id_moneda, 
          'direccion': direccion, 
          'telefono': telefono, 
          'dv': dv, 
          'fax': fax, 
          'id_pais': id_pais, 
          'id_depto': id_depto, 
          'id_ciudad': id_ciudad, 
          'regimen_tributario': regimen_tributario, 
          'flag_iva': flag_iva, 
          'flag_forma_pago_efectivo': flag_forma_pago_efectivo, 
          'correo_electronico': correo_electronico, 
          'id_empresa': id_empresa, 
          'estado': estado, 
          'nit': nit
         };
        }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Empresa{ razon_social: $razon_social,  id_tipo_empresa:$id_tipo_empresa, pre_actividad_economica:$pre_actividad_economica,  pre_cuenta:$pre_cuenta, '
           ' pre_medio_contacto:$pre_medio_contacto, id_moneda:$id_moneda,  direccion:$direccion,   telefono:$telefono,  dv:$dv, fax:$fax, id_pais:$id_pais, '
           ' id_depto:$id_depto, id_ciudad:$id_ciudad, regimen_tributario:$regimen_tributario, flag_iva:$flag_iva, flag_forma_pago_efectivo:$flag_forma_pago_efectivo, '
           ' correo_electronico:$correo_electronico, id_empresa:$id_empresa, estado:$estado,   nit:$nit }';
  }
}
