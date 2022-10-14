import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de clasificacion items

class PrecioItems {
     
      final String id_precio_item;
      final String descripcion;
      final String vigencia_desde;
      final String vigencia_hasta;
      final String id_margen_item;
      final String id_moneda;
      final String flag_iva_incluido;
      final String flag_lista_base; 
      final String nit; 

  const PrecioItems(
      {
        required this.id_precio_item,
        required this.descripcion,
        required this.vigencia_desde,
        required this.vigencia_hasta,
        required this.id_margen_item,
        required this.id_moneda,
        required this.flag_iva_incluido,
        required this.flag_lista_base,
        required this.nit 
       });


  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_precio_item': id_precio_item,
      'descripcion': descripcion,
      'vigencia_desde': vigencia_desde,
      'vigencia_hasta': vigencia_hasta,
      'id_margen_item': id_margen_item,
      'id_moneda': id_moneda,
      'flag_iva_incluido': flag_iva_incluido,
      'flag_lista_base': flag_lista_base,
      'nit': nit 
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'PrecioItems { id_precio_item:$id_precio_item, descripcion:$descripcion, vigencia_desde:$vigencia_desde,'
    ' vigencia_hasta:$vigencia_hasta, id_margen_item:$id_margen_item,  id_moneda:$id_moneda, flag_iva_incluido:$flag_iva_incluido,'
    '  flag_lista_base:$flag_lista_base, nit:$nit }';
  }
}


class PrecioItemsDet { 
    
      final String id_precio_item;
      final String precio;
      final String id_item;
      final String descuento_maximo;
      final String id_talla;
      final String id_moneda;
      final String id_unidad_compra; 
      final String nit; 

  const PrecioItemsDet(
      {
              required this.precio,
          required this.id_precio_item,
        required this.id_item,
        required this.descuento_maximo,
        required this.id_talla,
        required this.id_moneda,
        required this.id_unidad_compra, 
        required this.nit 
       });


  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'precio': precio,
      'id_precio_item': id_precio_item,      
      'id_item': id_item,
      'descuento_maximo': descuento_maximo,
      'id_talla': id_talla,
      'id_moneda': id_moneda,
      'id_unidad_compra': id_unidad_compra, 
      'nit': nit 
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'PrecioItemsDet {  precio :$precio,id_precio_item:$id_precio_item,   id_item:$id_item,'
    'descuento_maximo:$descuento_maximo,  id_talla:$id_talla,   id_moneda:$id_moneda, id_unidad_compra:$id_unidad_compra,'
    '   nit:$nit }';
  }
}