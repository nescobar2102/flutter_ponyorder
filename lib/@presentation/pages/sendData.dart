import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
  
import '../../db/operationDB.dart';
import '../../httpConexion/validateConexion.dart';
import '../../Common/Constant.dart';


class SendataSincronizacion   {

  bool focus = false;
  String date = '';
  

  static Future initSincronizacion() async { 
    print("se envia la data de tercero a la api si esta conectado");
    final _isConnected = await validateConexion.checkInternetConnection();
    
   print("esta conectado -*-*-*-* $_isConnected");
   if(_isConnected  != false && _isConnected != null ){
      await sendTercero(); 
     }else{
      return false;
     }
   }
       

 static Future<void> sendTercero() async {
    print("se envia la data de tercero a la api si esta conectado");

    final data = await OperationDB.getClientFlagNO();
    if(data!= false){  
 
     for (int i = 0; i < data.length; i++) {
    print("-*-*- se envia el $i   $data[i]['id_tercero'] ");
      
        final response = await http.post(
          Uri.parse('${Constant.URL}/nuevo_cliente_app'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
         body: //convert.jsonEncode(<  dynamic>{
               ({
              "id_tercero": double.parse(data[i]['id_tercero'].toString()),
              "id_sucursal_tercero": data[i]['id_sucursal_tercero'],
              "id_tipo_identificacion": data[i]['id_tipo_identificacion'],
              "dv": data[i]['dv'],
              "nombre": data[i]['nombre'],
              "direccion":data[i]['direccion'],
              "id_pais":data[i]['id_pais'],
              "id_depto":  data[i]['id_depto'],
              "id_ciudad": data[i]['id_ciudad'],
              "id_barrio":  data[i]['id_barrio'],
              "telefono":  data[i]['telefono'],
              "id_actividad":data[i]['id_actividad'] ,
              "nombre_sucursal": data[i]['nombre_sucursal'],
              "primer_apellido":data[i]['primer_apellido'],
              "segundo_apellido":data[i]['segundo_apellido'],
              "primer_nombre": data[i]['primer_nombre'],
              "segundo_nombre":data[i]['segundo_nombre'] != ''
                      ? data[i]['segundo_nombre']
                      : '',
              "e_mail": data[i]['e_mail'],
              "telefono_celular": data[i]['telefono'],
              "id_forma_pago":data[i]['id_forma_pago'] != ''
                      ? data[i]['id_forma_pago']
                      : '',
              "id_precio_item":data[i]['id_precio_item'],
              "id_lista_precio":data[i]['id_lista_precio'],
              "id_vendedor": double.parse(data[i]['id_vendedor'].toString()),
              "id_medio_contacto": data[i]['id_medio_contacto'],
              "id_zona": data[i]['id_zona'],
              "id_direccion": data[i]['id_direccion'],
              "tipo_direccion": data[i]['tipo_direccion'],
              "id_suc_vendedor":data[i]['id_suc_vendedor'],
              'nit':data[i]['nit'],
              'flag_persona_nat': data[i]['flag_persona_nat'],
              'usuario': ''
          })   
        ); 
        

        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var success = jsonResponse['success'];      
        if (response.statusCode == 201 && success) { 
       
          print("se actualiza el status del cliente");
          await OperationDB.updateCliente(data[i]['id_tercero'], data[i]['nit']);
        }
       }
      }
        await sendPedido();
  }
      
      

 static Future<void> sendPedido() async {
    print("se envia la data de pedido a la api si esta conectado");
    final data = await OperationDB.getPedidoFlagNO();
   if(data!= false){  
     for (int i = 0; i < data.length; i++) {
      final idTercero = data[i]['id_tercero'];
      print("-*-*- se envia el $i   $data[i]['id_tercero'] ");
       final dataDet = await OperationDB.getPedidoDetFlagNO( data[i]['numero'], data[i]['id_empresa'], data[i]['id_tipo_doc'], data[i]['nit']) ;
           print("-*-*- se envia el DETALLE     $dataDet ");

     final body = convert.jsonEncode(<String, dynamic>{
      'pedidos': [

            {
                'nit':  data[i]['nit'],
                'id_tercero': idTercero,
                "id_empresa":  data[i]['id_empresa'],
                "id_sucursal":  data[i]['id_sucursal'],
                "id_tipo_doc": data[i]['id_tipo_doc'],
                "numero":  data[i]['numero'],
                "id_sucursal_tercero":  data[i]['id_sucursal_tercero'],
                "id_vendedor": data[i]['id_vendedor'],
                "id_suc_vendedor":  data[i]['id_suc_vendedor'],
                "fecha":  data[i]['fecha'],
                "vencimiento": data[i]['vencimiento'],
                "fecha_entrega": data[i]['fecha_entrega'],
                "fecha_trm":data[i]['fecha_trm'],
                "id_forma_pago":data[i]['id_forma_pago'],
                "id_precio_item": data[i]['id_precio_item'],
                "id_direccion": data[i]['id_direccion'],
                "id_moneda": data[i]['id_moneda'],
                "trm": "1",
                "subtotal":  data[i]['subtotal'],
                "total_costo": data[i]['total_costo'],
                "total_iva": data[i]['total_iva'],
                "total_dcto":  data[i]['total_dcto'],
                "total":  data[i]['total'],
                "total_item":  data[i]['total_item'],
                "orden_compra": data[i]['orden_compra'],
                "estado":  data[i]['estado'],
                "flag_autorizado":  data[i]['flag_autorizado'],
                "comentario":  data[i]['comentario'],
                "observacion": data[i]['observacion'],
                "id_direccion_factura": data[i]['id_direccion_factura'],
                "usuario": data[i]['usuario'],
                "id_tiempo_entrega": "0",
                "flag_enviado": "SI",
                "app_movil": true,
                "pedido_det": [                
                  for (var j = 0; j < dataDet.length; j++) { 
                    {
                      'nit':  dataDet[j]['nit'],
                      'id_tercero': idTercero,
                      "id_empresa":  dataDet[j]['id_empresa'],
                      "id_sucursal": dataDet[j]['id_sucursal'],
                      "id_tipo_doc":  dataDet[j]['id_tipo_doc'],
                      "numero":  dataDet[j]['numero'],
                      "consecutivo":  dataDet[j]['consecutivo'],
                      "id_item": dataDet[j]['id_item'],
                      "descripcion_item":  dataDet[j]['descripcion_item'],
                      "id_bodega":  dataDet[j]['id_bodega'],
                      "cantidad": dataDet[j]['cantidad'],
                      "precio": dataDet[j]['precio'],
                      "precio_lista": dataDet[j]['precio_lista'],
                      "tasa_iva": "19",
                      "total_iva": "0",
                      "tasa_dcto_fijo": "0",
                      "total_dcto_fijo": "0",
                      "total_dcto":  dataDet[j]['total_dcto'],
                      "costo": "0",
                      "subtotal":  dataDet[j]['subtotal'],
                      "total": dataDet[j]['total'],
                      "total_item": "0",
                      "id_unidad": "Und",
                      "cantidad_kit": "0",
                      "cantidad_de_kit": "0",
                      "recno": "0",
                      "id_precio_item": dataDet[j]['id_precio_item'],
                      "factor": "1",
                      "id_impuesto_iva": "IVA19",
                      "total_dcto_adicional": "0",
                      "tasa_dcto_adicional": "0",
                      "id_kit": "",
                      "precio_kit": "0",
                      "tasa_dcto_cliente": "0",
                      "total_dcto_cliente": "0"
                    },
                 },
            ]
          }
        ]
        });
     
 print("*-*-* $body");
var response = await http.post(
  Uri.parse('${Constant.URL}/synchronization_pedido'),  
   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, 
    body: body // use jsonEncode()
);

      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var success = jsonResponse['success'];      
      if (response.statusCode == 201 && success) {        
        print("se actualiza el status del pedido");
        await OperationDB.updatePedidoFlag(data[i]['numero'], data[i]['nit']);
          }
        }
      }
      await createReciboApi();
  }
  //visual 

  

   static Future createReciboApi() async {
 
  print("se envia la data de cuentas por tercero a la api si esta conectado");
    final data = await OperationDB.getCuentaTerceroFlagNO();
     if(data!= false){  
 
     for (int i = 0; i < data.length; i++) {
      final idTercero = data[i]['id_tercero'];
      print("-*-*- se envia el $i   $data[i]['id_tercero'] ");
       final dataDet = await OperationDB.getPedidoDetFlagNO( data[i]['numero'], data[i]['id_empresa'], data[i]['id_tipo_doc'], data[i]['nit']) ;
    final response = await http.post(
      Uri.parse('${Constant.URL}/synchronization_cuentaportercero'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: //convert.jsonEncode(<String, dynamic>{
       convert.jsonEncode  ({
        "cuentas_por_terceros": [
          for (var i = 0; i < data.length; i++) ...[
            {
              "nit": data[i]['nit'],
              "id_empresa":  data[i]['id_empresa'],
              "id_sucursal":  data[i]['id_sucursal'],
              "tipo_doc":  data[i]['tipo_doc'],
              "numero":  data[i]['numero'],
              "cuota":  data[i]['cuota'],
              "dias":  data[i]['dias'],
              "id_tercero": idTercero,
              "id_vendedor": data[i]['id_vendedor'],
              "id_sucursal_tercero": data[i]['id_sucursal_tercero'],
              "fecha": data[i]['fecha'],
              "vencimiento": data[i]['vencimiento'], 
              "credito": data[i]['credito'], 
              "dctomax": "0",
              "debito": "0",
              "id_destino": "",
              "id_proyecto": "",
              "id_empresa_cruce": data[i]['id_empresa_cruce'],                   
              "id_sucursal_cruce": data[i]['id_sucursal_cruce'],                   
              "tipo_doc_cruce": data[i]['tipo_doc_cruce'],     
              "numero_cruce": data[i]['numero_cruce'],     
              "cuota_cruce":data[i]['cuota_cruce'],      
            },
          ]
        ],
      }),
    );

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    print("*-*-*-*- actualziacion de cuentas por tercero $msg ");
        if (response.statusCode == 201 && success) {      
          await OperationDB.updateCuentasFlag(data[i]['numero'], data[i]['nit'],data[i]['tipo_doc']);
        }  
     }
      }
    await sendCartera();
  }
 static Future<void> sendCartera() async {
    print("se envia la data de carteraproveedores a la api si esta conectado");

    final data = await OperationDB.getCarteraFlagNO();
    if(data!= false){  
     for (int i = 0; i < data.length; i++) {
      final idTercero = data[i]['id_tercero'];
    print("-*-*- se envia el $i   $data[i]['id_tercero'] ");
       final dataDet = await OperationDB.getCarteraDetFlagNO( data[i]['numero'], data[i]['id_empresa'], data[i]['id_tipo_doc'], data[i]['nit']) ;
        final response = await http.post(
          Uri.parse('${Constant.URL}/synchronization_carteraproveedores'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },   
      body:// convert.jsonEncode(<String, dynamic>{
         convert.jsonEncode  ({
        'cartera_proveedores': [
          {
            "nit":  data[i]['nit'],
            "id_empresa": data[i]['id_empresa'],
            "id_sucursal":  data[i]['id_sucursal'],
            "id_tipo_doc": data[i]['id_tipo_doc'],
            "numero":  data[i]['numero'],
            "fecha": data[i]['fecha'],                
            "total":  data[i]['total'],
            "vencimiento": data[i]['vencimiento'],                
            "letras":  data[i]['letras'],
            "id_moneda": data[i]['id_moneda'],
            "id_tercero":  data[i]['id_tercero'],
            "id_sucursal_tercero": data[i]['id_sucursal_tercero'],
            "id_recaudador": data[i]['id_recaudador'],
            "fecha_trm": data[i]['fecha_trm'],               
            "trm": "1",
            "observaciones": data[i]['observaciones'],
            "usuario":  data[i]['usuario'],
            "flag_enviado": "SI",
            "cartera_proveedores_det": [
           
              for (var j = 0; j <  dataDet.length; j++) ...[
                {
                  "consecutivo":  dataDet[j]['consecutivo'],
                  "cuota":   dataDet[j]['cuota'],
                  "id_tercero":  dataDet[j]['id_tercero'],
                  "id_sucursal_tercero":  dataDet[j]['id_sucursal_tercero'],
                  "id_empresa_cruce": dataDet[j]['id_empresa_cruce'], 
                  "id_sucursal_cruce":  dataDet[j]['id_sucursal_cruce'], 
                  "id_tipo_doc_cruce":  dataDet[j]['id_tipo_doc_cruce'],
                  "numero_cruce":  dataDet[j]['numero_cruce'],
                  "fecha": dataDet[j]['fecha'],                     
                  "vencimiento":  dataDet[j]['vencimiento'],
                  "debito": dataDet[j]['debito'],
                  "credito":  dataDet[j]['credito'],
                  "descripcion": dataDet[j]['descripcion'],
                  "id_vendedor":  dataDet[j]['id_vendedor'],
                  "id_forma_pago":  dataDet[j]['id_forma_pago'],
                  "documento_forma_pago": dataDet[j]['documento_forma_pago'],
                  "distribucion":  dataDet[j]['distribucion'],
                  "trm": dataDet[j]['trm'],
                  "id_recaudador": dataDet[j]['id_recaudador'],
                  "id_suc_recaudador":  dataDet[j]['id_suc_recaudador'],
                  "fecha_trm": dataDet[j]['fecha_trm'], 
                  "total_factura": dataDet[j]['total_factura'],
                  "id_concepto": dataDet[j]['id_concepto'],
                  "id_moneda": dataDet[j]['id_moneda'],
                  "id_destino": dataDet[j]['id_destino'],
                  "id_proyecto":  dataDet[j]['id_proyecto'],
                  "cuota_cruce":  dataDet[j]['cuota_cruce'],
                  "id_banco": dataDet[j]['id_banco'],
                },               
              ]
            ]
          }
        ]
      }),
    );

        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var success = jsonResponse['success'];      
        if (response.statusCode == 201 && success) {  
                final body = {
                      'nit': data[i]['nit'],
                      'id_tipo_doc':data[i]['id_tipo_doc'],
                      'consecutivo':data[i]['numero'],
                    };
                final response = await http
                    .post(Uri.parse("${Constant.URL}/consecutivo_recibo_app"), body: (body));
                var jsonResponse =
                    convert.jsonDecode(response.body) as Map<String, dynamic>;
                var success = jsonResponse['success'];

                    if (response.statusCode == 200 && success) {       
                    await OperationDB.updateReciboFlag(data[i]['numero'], data[i]['nit'],data[i]['id_tipo_doc']);
                  }       
                    print("se actualiza la cartera $i");
         
        }
      }
    }
  }
   }
 
