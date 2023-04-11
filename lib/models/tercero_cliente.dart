import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de tercero cliente 
  
class TerceroCliente { 
    final String id_tercero ;
    final String id_sucursal_tercero ;
    final String id_forma_pago ;
    final String  id_precio_item ;
    final String id_vendedor ;
    final int  id_suc_vendedor ;
    final String  id_medio_contacto ;
    final String id_zona ;
    final String  flag_exento_iva ;
    final String dia_cierre ;
    final String  id_impuesto_reteiva ;
    final String id_agente_reteiva ;
    final String  id_impuesto_reteica ;
    final String id_agente_reteica ;
    final String id_impuesto_retefuente ;
    final String id_agente_retefuente  ;
    final String  id_agente_retecree ;
    final String  id_impuesto_retecree;
    final String  id_tamanno;
    final String  limite_credito;
    final String  dias_gracia;
    final String  flag_cartera_vencida;
    final String  dcto_cliente;
    final String  dcto_adicional;
    final String  numero_facturas_vencidas; 
    final String  nit;
    final String  flag_enviado;

  const TerceroCliente(
      {
    required this.id_tercero,
    required this.id_sucursal_tercero,
    required this.id_forma_pago,
    required this.id_precio_item,
    required this.id_vendedor,
    required this.id_suc_vendedor,
    required this.id_medio_contacto,
    required this.id_zona,
    required this.flag_exento_iva,
    required this.dia_cierre,
    required this.id_impuesto_reteiva,
    required this.id_agente_reteiva,
    required this.id_impuesto_reteica,
    required this.id_agente_reteica,
    required this.id_impuesto_retefuente,
    required this.id_agente_retefuente ,
    required this.id_agente_retecree,
    required this.id_impuesto_retecree,
    required this.id_tamanno,
    required this.limite_credito,
    required this.dias_gracia,
    required this.flag_cartera_vencida,
    required this.dcto_cliente,
    required this.dcto_adicional,
    required this.numero_facturas_vencidas, 
    required this.nit,
        required this.flag_enviado,
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {    
      'id_tercero':id_tercero,
      'id_sucursal_tercero':id_sucursal_tercero,
      'id_forma_pago':id_forma_pago,
      'id_precio_item':id_precio_item,
      'id_vendedor':id_vendedor,
      'id_suc_vendedor':id_suc_vendedor,
      'id_medio_contacto':id_medio_contacto,
      'id_zona':id_zona,
      'flag_exento_iva':flag_exento_iva,
      'dia_cierre':dia_cierre,
      'id_impuesto_reteiva':id_impuesto_reteiva,
      'id_agente_reteiva':id_agente_reteiva,
      'id_impuesto_reteica':id_impuesto_reteica,
      'id_agente_reteica':id_agente_reteica,
      'id_impuesto_retefuente':id_impuesto_retefuente,
      'id_agente_retefuente ':id_agente_retefuente,
      'id_agente_retecree':id_agente_retecree,
      'id_impuesto_retecree':id_impuesto_retecree,
      'id_tamanno':id_tamanno,
      'limite_credito':limite_credito,
      'dias_gracia':dias_gracia, 
      'flag_cartera_vencida':flag_cartera_vencida, 
      'dcto_cliente':dcto_cliente, 
      'dcto_adicional':dcto_adicional, 
      'numero_facturas_vencidas':numero_facturas_vencidas,
      'nit':nit,
      'flag_enviado':flag_enviado,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
     return 'TerceroCliente{ id_tercero:$id_tercero, id_sucursal_tercero:$id_sucursal_tercero, id_forma_pago:$id_forma_pago, id_precio_item:$id_precio_item,'
    ' id_vendedor:$id_vendedor, id_suc_vendedor:$id_suc_vendedor,  id_medio_contacto:$id_medio_contacto,  id_zona:$id_zona,  flag_exento_iva:$flag_exento_iva,'
    ' dia_cierre:$dia_cierre, id_impuesto_reteiva:$id_impuesto_reteiva,  id_agente_reteiva:$id_agente_reteiva, id_impuesto_reteica:$id_impuesto_reteica,'
    ' id_agente_reteica:$id_agente_reteica, id_impuesto_retefuente:$id_impuesto_retefuente, id_agente_retefuente :$id_agente_retefuente,  id_agente_retecree:$id_agente_retecree,'
    ' id_impuesto_retecree:$id_impuesto_retecree, id_tamanno:$id_tamanno,  limite_credito:$limite_credito, dias_gracia:$dias_gracia,  flag_cartera_vencida:$flag_cartera_vencida, '
    ' dcto_cliente:$dcto_cliente, dcto_adicional:$dcto_adicional, numero_facturas_vencidas:$numero_facturas_vencidas, nit:$nit,flag_enviado:$flag_enviado }';  }
}
