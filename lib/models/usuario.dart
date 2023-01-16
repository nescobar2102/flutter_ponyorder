import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//Clase del modelo de usuario

class Usuario {
  final String usuario;
  final String clave;
  final String nit;
  final String id_tipo_doc_rc;
  final String id_tipo_doc_pe;
  final String id_bodega;
  final String flag_activo;
  final String flag_cambia_fp;
  final String flag_cambia_lp;
  final String flag_edita_cliente;
  final String flag_edita_dcto;
  final String edita_consecutivo_rc;
  final String edita_fecha_rc;
  final String id_tipo_doc_fac;
  final String flag_mobile;

  const Usuario({
    required this.usuario,
    required this.clave,
    required this.nit,
    required this.id_tipo_doc_pe,
    required this.id_tipo_doc_rc,
    required this.id_bodega,
    required this.flag_activo,
    required this.flag_cambia_fp,
    required this.flag_cambia_lp,
    required this.flag_edita_cliente,
    required this.flag_edita_dcto,
    required this.edita_consecutivo_rc,
    required this.edita_fecha_rc,
    required this.id_tipo_doc_fac,
    required this.flag_mobile,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'clave': clave,
      'nit': nit,
      'id_tipo_doc_pe': id_tipo_doc_pe,
      'id_tipo_doc_rc': id_tipo_doc_rc,
      'id_bodega': id_bodega,
      'flag_activo': flag_activo,
      'flag_cambia_fp': flag_cambia_fp,
      'flag_cambia_lp': flag_cambia_lp,
      'flag_edita_cliente': flag_edita_cliente,
      'flag_edita_dcto': flag_edita_dcto,
      'edita_consecutivo_rc': edita_consecutivo_rc,
      'edita_fecha_rc': edita_fecha_rc,
      'id_tipo_doc_fac': id_tipo_doc_fac,
      'flag_mobile': flag_mobile
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Usuario{ usuario: $usuario, clave: $clave,id_tipo_doc_pe: $id_tipo_doc_pe,id_tipo_doc_rc: $id_tipo_doc_rc,id_bodega: $id_bodega ,'
        ' flag_activo : $flag_activo, flag_cambia_fp : $flag_cambia_fp, flag_cambia_lp : $flag_cambia_lp, flag_edita_cliente : $flag_edita_cliente,'
        ' flag_edita_dcto : $flag_edita_dcto, edita_consecutivo_rc : $edita_consecutivo_rc, edita_fecha_rc : $edita_fecha_rc, id_tipo_doc_fac : $id_tipo_doc_fac,'
        ' flag_mobile : $flag_mobile }';
  }
}
