import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de pedidos

class Pedido {

    final String  id_empresa ;
    final String  id_sucursal ;
    final String  id_tipo_doc ;
    final String  numero ;
    final String  id_tercero ;
    final String  id_sucursal_tercero ;
    final String  id_vendedor ;
    final String  id_suc_vendedor ;
    final String  fecha ;
    final String  vencimiento ;
    final String  fecha_entrega ;
    final String  fecha_trm ;
    final String  id_forma_pago ;
    final String  id_precio_item ;
    final String  id_direccion ;
    final String  id_moneda ;
    final String  trm  ;
    final String  subtotal ;
    final String  total_costo;
    final String  total_iva;
    final String  total_dcto;
    final String  total;
    final String  total_item;
    final String  orden_compra;
    final String  estado;
    final String  flag_autorizado;
    final String  comentario;
    final String  observacion;
    final String  letras;
    final String  id_direccion_factura;
    final String  usuario;
    final String  id_tiempo_entrega;
    final String  flag_enviado;
    final String  nit;

  const Pedido(
      {
        required this.id_empresa ,
        required this.id_sucursal ,
        required this.id_tipo_doc ,
        required this.numero ,
        required this.id_tercero ,
        required this.id_sucursal_tercero ,
        required this.id_vendedor ,
        required this.id_suc_vendedor ,
        required this.fecha ,
        required this.vencimiento ,
        required this.fecha_entrega ,
        required this.fecha_trm ,
        required this.id_forma_pago ,
        required this.id_precio_item ,
        required this.id_direccion ,
        required this.id_moneda ,
        required this.trm  ,
        required this.subtotal ,
        required this.total_costo,
        required this.total_iva,
        required this.total_dcto,
        required this.total,
        required this.total_item,
        required this.orden_compra,
        required this.estado,
        required this.flag_autorizado,
        required this.comentario,
        required this.observacion,
        required this.letras,
        required this.id_direccion_factura,
        required this.usuario,
        required this.id_tiempo_entrega,
        required this.flag_enviado,
        required this.nit
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_empresa':id_empresa,
      'id_sucursal':id_sucursal,
      'id_tipo_doc':id_tipo_doc,
      'numero':numero,
      'id_tercero':id_tercero,
      'id_sucursal_tercero':id_sucursal_tercero,
      'id_vendedor':id_vendedor,
      'id_suc_vendedor':id_suc_vendedor,
      'fecha':fecha,
      'vencimiento':vencimiento,
      'fecha_entrega':fecha_entrega,
      'fecha_trm':fecha_trm,
      'id_forma_pago':id_forma_pago,
      'id_precio_item':id_precio_item,
      'id_direccion':id_direccion,
      'id_moneda':id_moneda,
      'trm ':trm,
      'subtotal':subtotal,
      'total_costo':total_costo,
      'total_iva':total_iva,
      'total_dcto':total_dcto,
      'total':total,
      'total_item':total_item,
      'orden_compra':orden_compra,
      'estado':estado,
      'flag_autorizado':flag_autorizado,
      'comentario':comentario,
      'observacion':observacion,
      'letras':letras,
      'id_direccion_factura':id_direccion_factura,
      'usuario':usuario,
      'id_tiempo_entrega':id_tiempo_entrega, 
      'flag_enviado':  flag_enviado,       
      'nit':nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
     return 'Pedido {  id_empresa:$id_empresa,  id_sucursal:$id_sucursal, id_tipo_doc:$id_tipo_doc, numero:$numero,  id_tercero:$id_tercero,'
      ' id_sucursal_tercero:$id_sucursal_tercero, id_vendedor:$id_vendedor, id_suc_vendedor:$id_suc_vendedor,  fecha:$fecha, vencimiento:$vencimiento,'
      ' fecha_entrega:$fecha_entrega,  fecha_trm:$fecha_trm, id_forma_pago:$id_forma_pago, id_precio_item:$id_precio_item, id_direccion:$id_direccion,'
      'id_moneda:$id_moneda, trm :$trm, subtotal:$subtotal,  total_costo:$total_costo, total_iva:$total_iva, total_dcto:$total_dcto,total:$total,'
      'total_item:$total_item,  orden_compra:$orden_compra, estado:$estado, flag_autorizado:$flag_autorizado, comentario:$comentario, observacion:$observacion,'
      'letras:$letras, id_direccion_factura:$id_direccion_factura, usuario:$usuario,  id_tiempo_entrega:$id_tiempo_entrega, flag_enviado:$flag_enviado, nit:$nit}';  }
}
 
    
    
class PedidoDet { 

    final String  id_empresa ;
    final String  id_sucursal ;
    final String  id_tipo_doc ;
    final String  numero ;
    final int  consecutivo ;
    final String  id_item ;
    final String descripcion_item;
    final String  id_bodega ;
    final String  cantidad ;
    final String  precio ;
    final String  precio_lista ;
    final String  tasa_iva ;
    final String  total_iva ;
    final String  tasa_dcto_fijo ;
    final String  total_dcto_fijo ;
    final String  total_dcto ;
    final String  costo ;
    final String  subtotal ;
    final String  total ;
    final String  total_item ;  
    final String  id_unidad;
    final String  cantidad_kit;
    final String  cantidad_de_kit;
    final String  recno;
    final String  id_precio_item;
    final String  factor;
    final String  id_impuesto_iva; 
    final String  total_dcto_adicional;
    final String  tasa_dcto_adicional;
    final String  id_kit;    
    final String  precio_kit;
    final String  tasa_dcto_cliente;
    final String  total_dcto_cliente;
    final String  nit;

  const PedidoDet(
      {

        required this.id_empresa ,
        required this.id_sucursal ,
        required this.id_tipo_doc ,
        required this.numero ,
        required this.consecutivo ,
        required this.id_item ,
        required this.descripcion_item,
        required this.id_bodega ,
        required this.cantidad ,
        required this.precio ,
        required this.precio_lista ,
        required this.tasa_iva ,
        required this.total_iva ,
        required this.tasa_dcto_fijo ,
        required this.total_dcto_fijo ,
        required this.total_dcto ,
        required this.costo ,
        required this.subtotal ,
        required this.total ,
        required this.total_item ,  
        required this.id_unidad,
        required this.cantidad_kit,
        required this.cantidad_de_kit,
        required this.recno,
        required this.id_precio_item,
        required this.factor,
        required this.id_impuesto_iva, 
        required this.total_dcto_adicional,
        required this.tasa_dcto_adicional,
        required this.id_kit,    
        required this.precio_kit,
        required this.tasa_dcto_cliente,
        required this.total_dcto_cliente,
        required this.nit, 
        });

        // Convert a Dog into a Map. The keys must correspond to the names of the
        // columns in the database.
        Map<String, dynamic> toMap() {
          return {
        'id_empresa':id_empresa,
        'id_sucursal':id_sucursal,
        'id_tipo_doc':id_tipo_doc,
        'numero':numero,
        'consecutivo':consecutivo,
        'id_item':id_item,
        'descripcion_item':descripcion_item,
        'id_bodega':id_bodega,
        'cantidad':cantidad,
        'precio':precio,
        'precio_lista':precio_lista,
        'tasa_iva':tasa_iva,
        'total_iva':total_iva,
        'tasa_dcto_fijo':tasa_dcto_fijo,
        'total_dcto_fijo':total_dcto_fijo,
        'total_dcto':total_dcto,
        'costo':costo,
        'subtotal':subtotal,
        'total':total,
        'total_item':  total_item,
        'id_unidad':id_unidad,
        'cantidad_kit':cantidad_kit,
        'cantidad_de_kit':cantidad_de_kit,
        'recno':recno,
        'id_precio_item':id_precio_item,
        'factor':factor,
        'id_impuesto_iva': id_impuesto_iva,
        'total_dcto_adicional':total_dcto_adicional,
        'tasa_dcto_adicional':tasa_dcto_adicional,
        'id_kit':  id_kit,
        'precio_kit':precio_kit,
        'tasa_dcto_cliente':tasa_dcto_cliente,
        'total_dcto_cliente':total_dcto_cliente,        
       'nit':nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
     return 'PedidoDet { id_empresa:$id_empresa, id_sucursal:$id_sucursal, id_tipo_doc:$id_tipo_doc, numero:$numero, consecutivo:$consecutivo, id_item:$id_item,'
        'descripcion_item:$descripcion_item,id_bodega:$id_bodega, cantidad:$cantidad, precio:$precio, precio_lista:$precio_lista, tasa_iva:$tasa_iva, total_iva:$total_iva, tasa_dcto_fijo:$tasa_dcto_fijo,'
        'total_dcto_fijo:$total_dcto_fijo, total_dcto:$total_dcto, costo:$costo, subtotal:$subtotal, total:$total, total_item:$total_item, id_unidad:$id_unidad,'
        'cantidad_kit:$cantidad_kit, cantidad_de_kit:$cantidad_de_kit, recno:$recno, id_precio_item:$id_precio_item,  factor:$factor, id_impuesto_iva:$id_impuesto_iva,'
        'total_dcto_adicional:$total_dcto_adicional,  tasa_dcto_adicional:$tasa_dcto_adicional, id_kit:$id_kit, precio_kit:$precio_kit, tasa_dcto_cliente:$tasa_dcto_cliente,'
        'total_dcto_cliente:$total_dcto_cliente, nit:$nit}';  }
}


//modelo del carrito de
 

class Carrito {  

    final String  id_empresa ; 
    final String  id_tipo_doc ;
    final int  numero ;
    final String nombre_sucursal;
    final String  id_tercero ; 
    final String  id_vendedor ;
    final String  id_suc_vendedor ;
    final String  fecha ; 
    final String  id_forma_pago ;
    final String  id_precio_item ;
    final String  id_direccion ;     
    final String  subtotal ;
    final String  total_costo; 
    final String  total_dcto;
    final String  total; 
    final String  orden_compra; 
    final String  observacion;
    final String  letras;
    final String  id_direccion_factura;
    final String  usuario;   
    final String  nit;

  const Carrito(
      {
        required this.id_empresa , required this.nombre_sucursal,
        required this.id_tipo_doc ,
        required this.numero ,
        required this.id_tercero , 
        required this.id_vendedor ,
        required this.id_suc_vendedor ,
        required this.fecha , 
        required this.id_forma_pago ,
        required this.id_precio_item ,
        required this.id_direccion ,  
        required this.subtotal ,
        required this.total_costo, 
        required this.total_dcto,
        required this.total, 
        required this.orden_compra, 
        required this.observacion,
        required this.letras,
        required this.id_direccion_factura,
        required this.usuario, 
        required this.nit
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_empresa':id_empresa, 
      'nombre_sucursal':nombre_sucursal,
      'id_tipo_doc':id_tipo_doc,
      'numero':numero,
      'id_tercero':id_tercero, 
      'id_vendedor':id_vendedor,
      'id_suc_vendedor':id_suc_vendedor,
      'fecha':fecha, 
      'id_forma_pago':id_forma_pago,
      'id_precio_item':id_precio_item,
      'id_direccion':id_direccion, 
      'subtotal':subtotal,
      'total_costo':total_costo, 
      'total_dcto':total_dcto,
      'total':total, 
      'orden_compra':orden_compra,  
      'observacion':observacion,
      'letras':letras,
      'id_direccion_factura':id_direccion_factura,
      'usuario':usuario,      
      'nit':nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
     return 'Carrito {   id_empresa:$id_empresa,  nombre_sucursal:$nombre_sucursal, id_tipo_doc:$id_tipo_doc, numero:$numero,  id_tercero:$id_tercero,'
      '  id_vendedor:$id_vendedor, id_suc_vendedor:$id_suc_vendedor,  fecha:$fecha,  '
      '  id_forma_pago:$id_forma_pago, id_precio_item:$id_precio_item, id_direccion:$id_direccion,'
      '  subtotal:$subtotal,  total_costo:$total_costo,  total_dcto:$total_dcto,total:$total,'
      '  orden_compra:$orden_compra  ,  observacion:$observacion, letras:$letras, id_direccion_factura:$id_direccion_factura, usuario:$usuario,  nit:$nit}';  }
}
  
    
class CarritoDet { 
 
    final int  numero ; 
    final String  id_item ;
    final String  descripcion; 
    final String  id_tercero ;
    final String  precio ;
    final String  cantidad ;
    final String  total_dcto ;
    final String  dcto ; 
    final String  id_precio_item; 
    final String  nit;
 
  const CarritoDet(
      { 
        required this.numero , 
        required this.id_item ,
        required this.descripcion, 
        required this.id_tercero ,
        required this.precio , 
        required this.cantidad ,
        required this.total_dcto ,
        required this.dcto,
        required this.id_precio_item, 
        required this.nit, 
        });

        // Convert a Dog into a Map. The keys must correspond to the names of the
        // columns in the database.
        Map<String, dynamic> toMap() {
          return {
     
        'numero':numero, 
        'id_item':id_item,
        'descripcion':descripcion, 
        'id_tercero':id_tercero,      
        'precio':precio,
        'cantidad':cantidad,   
        'total_dcto':total_dcto,
        'dcto':dcto,      
        'id_precio_item':id_precio_item,         
        'nit':nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
     return 'CarritoDet { numero:$numero, id_item:$id_item, descripcion:$descripcion,id_tercero:$id_tercero, '
     ' cantidad:$cantidad, precio:$precio,  total_dcto:$total_dcto, dcto:$dcto, id_precio_item:$id_precio_item,  nit:$nit}';  }
}