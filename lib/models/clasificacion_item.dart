import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de clasificacion items

class ClasificacionItems {
    
              
      final String id_clasificacion;
      final String descripcion;
      final String id_padre;
      final String nivel;
      final String es_padre;
      final String nit;
      final String foto;
      final String imagen; 

  const ClasificacionItems(
      {required this.id_clasificacion,
      required this.descripcion,
      required this.id_padre,
      required this.nivel,
      required this.es_padre,
      required this.nit,
      required this.foto,
      required this.imagen });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_clasificacion': id_clasificacion,
      'descripcion': descripcion,
      'id_padre': id_padre,
      'nivel': nivel,
      'es_padre': es_padre,
      'nit': nit,
      'foto': foto,
      'imagen': imagen 
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'ClasificacionItems {id_clasificacion: $id_clasificacion, descripcion: $descripcion, id_padre: $id_padre,nivel: $nivel,es_padre: $es_padre,'
            ' nit: $nit,foto: $foto,imagen: $imagen}';
  }
}

   
class  Items {
    
     final String id_item;
     final String   descripcion ;
     final String   referencia ;
     final String  id_impuesto ;
     final String   tipo_impuesto ;
     final String   dcto_producto ;
     final String  dcto_maximo ;
     final String  flag_facturable ;
     final String   flag_serial ;
     final String    flag_kit ;
     final String   id_clasificacion ;
     final String   id_padre_clasificacion ;
     final String   id_unidad_compra ;
     final String   exento_impuesto ;
     final String  flag_existencia ;
     final String   flag_dcto_volumen ;
     final String  nit ;
     final String   saldo_inventario ;

    const Items(
    { 
    required this.id_item,
    required this.descripcion,
    required this.referencia,
    required this.id_impuesto,
    required this.tipo_impuesto,
    required this.dcto_producto,
    required this.dcto_maximo,
    required this.flag_facturable,
    required this.flag_serial,
    required this.flag_kit,
    required this.id_clasificacion,
    required this.id_padre_clasificacion,
    required this.id_unidad_compra,
    required this.exento_impuesto,
    required this.flag_existencia,
    required this.flag_dcto_volumen,
    required this. nit,
    required this.saldo_inventario
     });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_item': id_item,
      'descripcion': descripcion,
      'referencia': referencia,
      'id_impuesto': id_impuesto,
      'tipo_impuesto': tipo_impuesto,
      'dcto_producto': dcto_producto,
      'dcto_maximo': dcto_maximo,
      'flag_facturable': flag_facturable ,
      'flag_serial': flag_serial,
      'flag_kit': flag_kit,
      'id_clasificacion': id_clasificacion,
      'id_padre_clasificacion': id_padre_clasificacion,
      'id_unidad_compra': id_unidad_compra,
      'exento_impuesto': exento_impuesto,
      'flag_existencia': flag_existencia,
      'flag_dcto_volumen': flag_dcto_volumen ,
      'nit': nit,
      'saldo_inventario': saldo_inventario
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return ' Items {  id_item: id_item, descripcion:$descripcion,  referencia:$referencia,  id_impuesto:$id_impuesto,'
    '  tipo_impuesto:$tipo_impuesto, dcto_producto:$dcto_producto,   dcto_maximo:$dcto_maximo,  flag_facturable:$flag_facturable ,'
      ' flag_serial:$flag_serial, flag_kit:$flag_kit, id_clasificacion:$id_clasificacion,  id_padre_clasificacion:$id_padre_clasificacion,'
    '  id_unidad_compra:$id_unidad_compra,   exento_impuesto:$exento_impuesto,  flag_existencia:$flag_existencia,  flag_dcto_volumen:$flag_dcto_volumen ,'
     '   nit:$nit,   saldo_inventario:$saldo_inventario  }';
  }
}


class  Kit {

  final String  id_kit;
  final String  descripcion;
  final String  precio_kit;
  final String  precio_kit_iva;
  final String  flag_vigencia;
  final String  fecha_inicial;
  final String  fecha_final;
  final String  ultima_actualizacion;
  final String  nit;

  const Kit(
      {
        required this.id_kit,
        required this.descripcion,
        required this.precio_kit,
        required this.precio_kit_iva,
        required this.flag_vigencia,
        required this.fecha_inicial,
        required this.fecha_final,
        required this.ultima_actualizacion,
        required this. nit
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_kit': id_kit,
      'descripcion': descripcion,
      'precio_kit': precio_kit,
      'precio_kit_iva': precio_kit_iva,
      'flag_vigencia': flag_vigencia,
      'fecha_inicial': fecha_inicial,
      'fecha_final': fecha_final,
      'ultima_actualizacion': ultima_actualizacion,
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return ' Kit { id_kit: $id_kit, descripcion:$descripcion,  precio_kit:$precio_kit,  precio_kit_iva:$precio_kit_iva,'
        ' flag_vigencia:$flag_vigencia, fecha_inicial:$fecha_inicial, fecha_final:$fecha_final, ultima_actualizacion:$ultima_actualizacion,'
        ' nit:$nit }';
  }
}


class  KitDet {

  final String  id_kit;
  final String  id_item;
  final String  id_bodega;
  final String  cantidad;
  final String  tasa_dcto;
  final String  precio;
  final String  valor_total;
  final String  tasa_iva;
  final String valor_iva;
  final String total;
  final String ultima_actualizacion;
  final String  nit;

  const KitDet(
      {
        required this.id_kit,
        required this.id_item,
        required this.id_bodega,
        required this.cantidad,
        required this.tasa_dcto,
        required this.precio,
        required this.valor_total,
        required this.tasa_iva,
        required this.valor_iva,
        required this.total,
        required this.ultima_actualizacion,
        required this. nit
      });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_kit': id_kit,
      'id_item': id_item,
      'id_bodega': id_bodega,
      'cantidad': cantidad,
      'tasa_dcto': tasa_dcto,
      'precio': precio,
      'valor_total': valor_total,
      'tasa_iva': tasa_iva,
      'valor_iva': valor_iva,
      'total': total,
      'ultima_actualizacion': ultima_actualizacion,
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return ' KitDet { id_kit: $id_kit, id_item:$id_item,  id_bodega:$id_bodega,  cantidad:$cantidad,'
        ' tasa_dcto:$tasa_dcto, precio:$precio, valor_total:$valor_total, tasa_iva:$tasa_iva,'
        ' valor_iva:$valor_iva, total:$total, ultima_actualizacion:$ultima_actualizacion, nit:$nit }';
  }
}