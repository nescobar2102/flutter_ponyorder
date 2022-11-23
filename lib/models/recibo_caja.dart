import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de  cuentaportercero_all

class CuentaTercero {

  final String  id_empresa;
  final String  id_sucursal;
  final String  tipo_doc;
  final int numero;
  final int cuota;
  final int dias;
  final String id_tercero;
  final String  id_vendedor;
  final int id_sucursal_tercero;
  final String  fecha;
  final String vencimiento;
  final String  credito;
  final String  dctomax;
  final String  debito;
  final String  id_destino;
  final String  id_proyecto;
  final String  nit;
  final String  id_empresa_cruce;
  final String id_sucursal_cruce;
  final String tipo_doc_cruce;
  final String numero_cruce;
  final String cuota_cruce;

  const CuentaTercero(
      {
      required this.id_empresa,
      required this.id_sucursal,
      required this.tipo_doc,
      required this.numero,
      required this.cuota,
      required this.dias,
      required this.id_tercero,
      required this.id_vendedor,
      required this.id_sucursal_tercero,
      required this.fecha,
      required this.vencimiento,
      required this.credito,
      required this.dctomax,
      required this.debito,
      required this.id_destino,
      required this.id_proyecto,
      required this.nit,
      required this.id_empresa_cruce,
      required this.id_sucursal_cruce,
      required this.tipo_doc_cruce,
      required this.numero_cruce,
      required this.cuota_cruce

      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_empresa': id_empresa,
      'id_sucursal': id_sucursal,
      'tipo_doc': tipo_doc,
      'numero': numero,
      'cuota': cuota,
      'dias': dias,
      'id_tercero': id_tercero,
      'id_vendedor': id_vendedor,
      'id_sucursal_tercero': id_sucursal_tercero,
      'fecha': fecha,
      'vencimiento': vencimiento,
      'credito': credito,
      'dctomax': dctomax,
      'debito': debito,
      'id_destino': id_destino,
      'id_proyecto': id_proyecto,
      'nit': nit,
      'id_empresa_cruce': id_empresa_cruce,
      'id_sucursal_cruce': id_sucursal_cruce,
      'tipo_doc_cruce': tipo_doc_cruce,
      'numero_cruce': numero_cruce,
      'cuota_cruce': cuota_cruce
    };
  }

    // Implement toString to make it easier to see information about
    // each dog when using the print statement.
    @override
    String toString() {
      return 'CuentaTercero { id_empresa:$id_empresa, id_sucursal: $id_sucursal, tipo_doc: $tipo_doc,numero: $numero, cuota: $cuota, dias: $dias,'
                ' id_tercero:$id_tercero, id_vendedor: $id_vendedor,id_sucursal_tercero: $id_sucursal_tercero, fecha: $fecha, vencimiento: $vencimiento,'
                ' credito: $credito, dctomax: $dctomax, debito: $debito, id_destino: $id_destino, id_proyecto: $id_proyecto,nit: $nit,id_empresa_cruce: $id_empresa_cruce,'
                ' id_sucursal_cruce : $id_sucursal_cruce, tipo_doc_cruce: $tipo_doc_cruce, numero_cruce: $numero_cruce, cuota_cruce: $cuota_cruce }';
      }
   }


class CarteraProveedores {
  final String  id_empresa;
  final String  id_sucursal;
  final String id_tipo_doc;
  final int  numero ;
  final String  fecha;
  final String  total;
  final String  vencimiento;
  final String  letras;
  final String  id_moneda;
  final String  id_tercero;
  final int  id_sucursal_tercero;
  final String  id_recaudador;
  final String   fecha_trm;
  final String  trm;
  final String  observaciones;
  final String  usuario;
  final String  flag_enviado;
  final String  nit;

  const CarteraProveedores(
      {
        required this.id_empresa,
        required this.id_sucursal,
        required this.id_tipo_doc,
        required this.numero,
        required this.fecha,
        required this.total,
        required this.vencimiento,
        required this.letras,
        required this.id_moneda,
        required this.id_tercero,
        required this.id_sucursal_tercero,
        required this.id_recaudador,
        required this.fecha_trm,
        required this.trm,
        required this.observaciones,
        required this.usuario,
        required this.flag_enviado,
        required this.nit
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_empresa': id_empresa,
      'id_sucursal': id_sucursal,
      'id_tipo_doc': id_tipo_doc,
      'numero': numero,
      'fecha': fecha,
      'total': total,
      'vencimiento': vencimiento,
      'letras': letras,
      'id_moneda': id_moneda,
      'id_tercero': id_tercero,
      'id_sucursal_tercero': id_sucursal_tercero,
      'id_recaudador': id_recaudador,
      'fecha_trm': fecha_trm,
      'trm': trm,
      'observaciones': observaciones,
      'usuario': usuario,
      'flag_enviado':flag_enviado,
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return ' CarteraProveedores { id_empresa:$id_empresa, id_sucursal: $id_sucursal, id_tipo_doc: $id_tipo_doc,numero: $numero, fecha: $fecha, total: $total,'
           ' vencimiento:$vencimiento, letras: $letras,id_moneda: $id_moneda, id_tercero: $id_tercero, id_sucursal_tercero: $id_sucursal_tercero,'
           ' id_recaudador: $id_recaudador, fecha_trm: $fecha_trm, trm: $trm, observaciones: $observaciones, usuario: $usuario,flag_enviado: $flag_enviado,nit: $nit }';
  }
}


class CarteraProveedoresDet {

  final String  id_empresa;
  final String  id_sucursal;
  final String id_tipo_doc;
  final int  numero ;
  final int  consecutivo;
  final String id_empresa_cruce;
  final String id_sucursal_cruce;
  final String id_tipo_doc_cruce;
  final int   numero_cruce;
  final String fecha;
  final String vencimiento;
  final String debito;
  final String credito;
  final String id_vendedor;
  final String id_forma_pago;
  final String  documento_forma_pago;
  final int  id_sucursal_tercero;
  final String  id_tercero;
  final String  cuota;
  final String  distribucion;
  final String  descripcion;
  final String  trm;
  final String  id_recaudador;
  final int  id_suc_recaudador;
  final String  fecha_trm;
  final String  total_factura;
  final String  id_concepto;
  final String  id_moneda;
  final String  id_destino;
  final String  id_proyecto;
  final int  cuota_cruce;
  final String  id_banco;
  final String  nit;

  const CarteraProveedoresDet(
      {
        required this.id_empresa,
        required this.id_sucursal,
        required this.id_tipo_doc,
        required this.numero,
        required this.consecutivo,
        required this.id_empresa_cruce,
        required this.id_sucursal_cruce,
        required this.id_tipo_doc_cruce,
        required this.numero_cruce,
        required this.fecha,
        required this.vencimiento,
        required this.debito,
        required this.credito,
        required this.id_vendedor,
        required this.id_forma_pago,
        required this.documento_forma_pago,
        required this.id_sucursal_tercero,
        required this.id_tercero,
        required this.cuota,
        required this.distribucion,
        required this.descripcion,
        required this.trm,
        required this.id_recaudador,
        required this.id_suc_recaudador,
        required this.fecha_trm,
        required this.total_factura,
        required this.id_concepto,
        required this.id_moneda,
        required this.id_destino,
        required this.id_proyecto,
        required this.cuota_cruce,
        required this.id_banco, 
        required this.nit
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_empresa': id_empresa,
      'id_sucursal': id_sucursal,
      'id_tipo_doc': id_tipo_doc,
      'numero': numero,       
      'consecutivo':consecutivo,
      'id_empresa_cruce':id_empresa_cruce,
      'id_sucursal_cruce':id_sucursal_cruce,
      'id_tipo_doc_cruce':id_tipo_doc_cruce,
      'numero_cruce':numero_cruce,
      'fecha':fecha,
      'vencimiento':vencimiento,
      'debito':debito,
      'credito':credito,
      'id_vendedor':id_vendedor,
      'id_forma_pago':id_forma_pago,
      'documento_forma_pago':documento_forma_pago,
      'id_sucursal_tercero':id_sucursal_tercero,
      'id_tercero':id_tercero,
      'cuota':cuota,
      'distribucion':distribucion,
      'descripcion':descripcion,
      'trm':trm,
      'id_recaudador':id_recaudador,
      'id_suc_recaudador':id_suc_recaudador,
      'fecha_trm':fecha_trm,
      'total_factura':total_factura,
      'id_concepto':id_concepto,
      'id_moneda':id_moneda,
      'id_destino':id_destino,
      'id_proyecto':id_proyecto,
      'cuota_cruce':cuota_cruce,
      'id_banco': id_banco,
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return ' CarteraProveedoresDet { id_empresa	:$id_empresa, id_sucursal: $id_sucursal, id_tipo_doc: $id_tipo_doc,  numero: $numero,    consecutivo: $consecutivo,'
      ' id_empresa_cruce: $id_empresa_cruce,  id_sucursal_cruce: $id_sucursal_cruce, id_tipo_doc_cruce: $id_tipo_doc_cruce,  numero_cruce: $numero_cruce, fecha: $fecha,'
    '  vencimiento: $vencimiento,  debito: $debito, credito: $credito, id_vendedor: $id_vendedor, id_forma_pago: $id_forma_pago, documento_forma_pago: $documento_forma_pago,'
     ' id_sucursal_tercero: $id_sucursal_tercero,  id_tercero: $id_tercero,   cuota: $cuota,  distribucion: $distribucion,   descripcion: $descripcion,  trm: $trm,'
    '  id_recaudador: $id_recaudador, id_suc_recaudador: $id_suc_recaudador,  fecha_trm: $fecha_trm,  total_factura: $total_factura,  id_concepto: $id_concepto,'
     ' id_moneda: $id_moneda,  id_destino: $id_destino,  id_proyecto: $id_proyecto,  cuota_cruce: $cuota_cruce,   id_banco: $id_banco,  nit: $nit}';
  }
}


class Concepto {

  final String id_concepto;
  final String descripcion;
  final String naturalezacta;
  final String id_auxiliar;
  final String nit;

  const Concepto(
      {
        required this.id_concepto,
        required this.descripcion,
        required this.naturalezacta,
        required this.id_auxiliar,
        required this.nit
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_concepto': id_concepto,
      'descripcion': descripcion,
      'naturalezacta': naturalezacta,
      "id_auxiliar": id_auxiliar,
      'nit': nit
    };
  }


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Concepto {id_concepto: $id_concepto, descripcion: $descripcion, naturalezacta: $naturalezacta, id_auxiliar:$id_auxiliar ,nit: $nit }';
  }
}

class Auxiliar {

  final String id_auxiliar;
  final String descripcion;
  final String flag_flujo_caja;
  final String id_tipo_cuenta;
  final String nit;

  const Auxiliar(
      {
        required this.id_auxiliar,
        required this.descripcion,
        required this.flag_flujo_caja,
        required this.id_tipo_cuenta,
        required this.nit
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_auxiliar': id_auxiliar,
      'descripcion': descripcion,
      'flag_flujo_caja': flag_flujo_caja,
      "id_tipo_cuenta": id_tipo_cuenta,
      'nit': nit
    };
  }


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Auxiliar {id_auxiliar: $id_auxiliar, descripcion: $descripcion, flag_flujo_caja: $flag_flujo_caja, id_tipo_cuenta:$id_tipo_cuenta ,nit: $nit }';
  }
}

class Banco {

  final String id_banco;
  final String descripcion;
  final String nit;

  const Banco(
      {
        required this.id_banco,
        required this.descripcion,
        required this.nit
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_banco': id_banco,
      'descripcion': descripcion,
      'nit': nit
    };
  }


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Banco {id_banco: $id_banco, descripcion: $descripcion, nit: $nit }';
  }
}
