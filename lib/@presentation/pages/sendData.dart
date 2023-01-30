import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../../db/operationDB.dart';
import '../../httpConexion/validateConexion.dart';
import '../../Common/Constant.dart';
import '../../models/empresa.dart';

import '../../models/ciudad.dart';
import '../../models/tipo_doc.dart';
import '../../models/zona.dart';
import '../../models/medio_contacto.dart';


class SendataSincronizacion   {

  bool focus = false;
  String date = '';


  static convertDateFormat2(fecha) {
    var info = fecha.split('-');
    var dia = info[0];
    var nueva_fecha = dia+'-'+info[1]+'-'+info[2];
    return nueva_fecha;
  }

  static convertDateFormat3(fecha) {
    var info = fecha.split('/');
    var nueva_fecha =info[0]+'/'+info[1]+'/'+ info[2];
    return nueva_fecha;
  }
  static Future initSincronizacion() async {

    print("se envia la data de tercero a la api si esta conectado");
    final _isConnected = await validateConexion.checkInternetConnection();

    print("esta conectado -*-*-*-* $_isConnected");
    print("empiza a enviarrrr");
    if(_isConnected  != false && _isConnected != null ){
      await sendTercero(true);
    }else{
      return false;
    }
  }


  static Future<void> sendTercero(bool origin ) async {
    print("ingresa  asincronizar desde la bd");
    final data = await OperationDB.getClientFlagNO();
    if(data!= false){
      for (int i = 0; i < data.length; i++) {
        final body = {
          "id_tercero":data[i]['id_tercero'],
          "id_sucursal_tercero":data[i]['id_sucursal_tercero'].toString(),
          "id_tipo_identificacion": data[i]['id_tipo_identificacion'].toString(),
          "dv":data[i]['dv'].toString(),
          "nombre": data[i]['nombre'],
          "direccion":data[i]['direccion'],
          "id_pais":data[i]['id_pais'].toString(),
          "id_depto":  data[i]['id_depto'].toString(),
          "id_ciudad": data[i]['id_ciudad'].toString(),
          "id_barrio":  data[i]['id_barrio'].toString(),
          "telefono":  data[i]['telefono'].toString(),
          "id_actividad":data[i]['id_actividad'].toString(),
          "nombre_sucursal": data[i]['nombre_sucursal'],
          "primer_apellido":data[i]['primer_apellido'],
          "segundo_apellido":data[i]['segundo_apellido'],
          "primer_nombre": data[i]['primer_nombre'],
          "segundo_nombre":data[i]['segundo_nombre'] != ''
              ? data[i]['segundo_nombre']
              : '',
          "e_mail": data[i]['e_mail'],
          "telefono_celular": data[i]['telefono_celular'].toString(),
          "id_forma_pago":data[i]['id_forma_pago'] != ''
              ? data[i]['id_forma_pago']
              : '01',
          "id_precio_item":data[i]['id_precio_item'].toString(),
          "id_lista_precio":data[i]['id_lista_precio'] != ''
              ? data[i]['id_lista_precio']
              : '01',
          "id_vendedor": data[i]['id_vendedor'].toString(),
          "id_medio_contacto": data[i]['id_medio_contacto'].toString(),
          "id_zona": data[i]['id_zona'].toString(),
          "id_direccion": data[i]['id_direccion'].toString(),
          "tipo_direccion": data[i]['tipo_direccion'].toString(),
          "id_suc_vendedor":data[i]['id_suc_vendedor'].toString(),
          'nit':data[i]['nit'].toString(),
          'flag_persona_nat': data[i]['flag_persona_nat'],
          'usuario': '',
        };
        print("--------- print bpu $body");
        final response = await http.post(
            Uri.parse('${Constant.URL}/nuevo_cliente_app'),
            body:body );

        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        var success = jsonResponse['success'];
        var msg = jsonResponse['msg'];
        if (response.statusCode == 201 && success) {
          await OperationDB.updateCliente(data[i]['id_tercero'], data[i]['nit']);
        }
      }
    }
    origin ?  await createPedidoAPI(): null;
  }

  static Future<void> createPedidoAPI() async {
    final data = await OperationDB.getPedidoFlagNO();
    if(data!= false){
      for (int i = 0; i < data.length; i++) {
        final idTercero = data[i]['id_tercero'];
        final nit = data[i]['nit'].toString();
        final numero = data[i]['numero'].toString();
        final dataDet = await OperationDB.getPedidoDetFlagNO(numero, data[i]['id_empresa'], data[i]['id_tipo_doc'], nit) ;

        final body = convert.jsonEncode(<String, dynamic>  {
          'pedidos': [
            {
              'nit': nit,
              'id_tercero': idTercero.toString(),
              "id_empresa":  data[i]['id_empresa'].toString(),
              "id_sucursal":  data[i]['id_sucursal'].toString(),
              "id_tipo_doc": data[i]['id_tipo_doc'],
              "numero": numero,
              "id_sucursal_tercero":  data[i]['id_sucursal_tercero'].toString(),
              "id_vendedor": data[i]['id_vendedor'].toString(),
              "id_suc_vendedor":  data[i]['id_suc_vendedor'].toString(),
              "fecha":  data[i]['fecha'],
              "vencimiento": data[i]['vencimiento'],
              "fecha_entrega": data[i]['fecha_entrega'],
              "fecha_trm":data[i]['fecha_trm'],
              "id_forma_pago":data[i]['id_forma_pago'].toString(),
              "id_precio_item": data[i]['id_precio_item'].toString(),
              "id_direccion": data[i]['id_direccion'].toString(),
              "id_moneda": data[i]['id_moneda'],
              "trm": "1",
              "subtotal":  data[i]['subtotal'].toString(),
              "total_costo": data[i]['total_costo'].toString(),
              "total_iva": data[i]['total_iva'],
              "total_dcto":  data[i]['total_dcto'].toString(),
              "total":  data[i]['total'].toString(),
              "total_item":  data[i]['total_item'].toString(),
              "orden_compra": data[i]['orden_compra'],
              "estado":  data[i]['estado'],
              "flag_autorizado":  data[i]['flag_autorizado'],
              "comentario":  data[i]['comentario'],
              "observacion": data[i]['observacion'],
              "id_direccion_factura": data[i]['id_direccion_factura'].toString(),
              "usuario": data[i]['usuario'],
              "id_tiempo_entrega": "0",
              "flag_enviado": "SI",
              "app_movil": true,
              "pedido_det": [
                for (var j = 0; j < dataDet.length; j++) ...[
                  {
                    'nit': nit,
                    'id_tercero': idTercero.toString(),
                    "id_empresa":  dataDet[j]['id_empresa'].toString(),
                    "id_sucursal": dataDet[j]['id_sucursal'].toString(),
                    "id_tipo_doc":  dataDet[j]['id_tipo_doc'].toString(),
                    "numero": numero,
                    "consecutivo":  dataDet[j]['consecutivo'].toString(),
                    "id_item": dataDet[j]['id_item'],
                    "descripcion_item":  dataDet[j]['descripcion_item'],
                    "id_bodega":  dataDet[j]['id_bodega'].toString(),
                    "cantidad": dataDet[j]['cantidad'].toString(),
                    "precio": dataDet[j]['precio'].toString(),
                    "precio_lista": dataDet[j]['precio_lista'].toString(),
                    "tasa_iva": '19',
                    "total_iva": "0",
                    "tasa_dcto_fijo": "0",
                    "total_dcto_fijo": "0",
                    "total_dcto":  dataDet[j]['total_dcto'].toString(),
                    "costo": "0",
                    "subtotal":  dataDet[j]['subtotal'].toString(),
                    "total": dataDet[j]['total'].toString(),
                    "total_item": "0",
                    "id_unidad": "Und",
                    "cantidad_kit": "0",
                    "cantidad_de_kit": "0",
                    "recno": "0",
                    "id_precio_item": dataDet[j]['id_precio_item'].toString(),
                    "factor": "1",
                    "id_impuesto_iva": "IVA19",
                    "total_dcto_adicional": "0",
                    "tasa_dcto_adicional": "0",
                    "id_kit": "",
                    "precio_kit": "0",
                    "tasa_dcto_cliente": "0",
                    "total_dcto_cliente": "0",
                  },
                ],
              ],
            }
          ]
        });
        final response = await http.post(
            Uri.parse('${Constant.URL}/synchronization_pedido'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: body
        );

        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        var success = jsonResponse['success'];

        if (response.statusCode == 201 && success) {
          await OperationDB.updatePedidoFlag(numero, nit);
        }
      }
    }
    await createReciboApi();
  }


  static Future createReciboApi() async {
    final data = await OperationDB.getCuentaTerceroFlagNO();
    if(data!= false){
      for (int i = 0; i < data.length; i++) {
        final idTercero = data[i]['id_tercero'].toString();

        final body = convert.jsonEncode(<String, dynamic>{
          "cuentas_por_terceros": [
            {
              "nit": data[i]['nit'].toString(),
              "id_empresa":  data[i]['id_empresa'].toString(),
              "id_sucursal":  data[i]['id_sucursal'].toString(),
              "tipo_doc":  data[i]['tipo_doc'].toString(),
              "numero":  data[i]['numero'].toString(),
              "cuota":  data[i]['cuota'].toString(),
              "dias":  data[i]['dias'].toString(),
              "id_tercero": idTercero,
              "id_vendedor": data[i]['id_vendedor'].toString(),
              "id_sucursal_tercero": data[i]['id_sucursal_tercero'].toString(),
              "fecha":  data[i]['fecha'] ,
              "vencimiento": data[i]['vencimiento'],
              "credito": data[i]['credito'].toString(),
              "dctomax": "0",
              "debito": "0",
              "id_destino": "",
              "id_proyecto": "",
              "id_empresa_cruce": data[i]['id_empresa_cruce'].toString(),
              "id_sucursal_cruce": data[i]['id_sucursal_cruce'].toString(),
              "tipo_doc_cruce": data[i]['tipo_doc_cruce'].toString(),
              "numero_cruce": data[i]['numero_cruce'].toString(),
              "cuota_cruce":data[i]['cuota_cruce'].toString(),
            },
          ],
        });
        final response = await http.post(
            Uri.parse('${Constant.URL}/synchronization_cuentaportercero'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body:body
        );

        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        var success = jsonResponse['success'];
        var msg = jsonResponse['msg'];
        if (response.statusCode == 201 && success) {
          await OperationDB.updateCuentasFlag(data[i]['numero'].toString(), data[i]['nit'],data[i]['tipo_doc']);
        }else{
          print("no se actualizo la cuenta por tercero $msg");
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
        final dataDet = await OperationDB.getCarteraDetFlagNO(data[i]['numero'].toString(), data[i]['id_empresa'], data[i]['id_tipo_doc'], data[i]['nit']) ;

        if(dataDet!= false){
          final body = convert.jsonEncode(<String, dynamic>{
            'cartera_proveedores': [
              {
                "nit":  data[i]['nit'].toString(),
                "id_empresa": data[i]['id_empresa'].toString(),
                "id_sucursal":  data[i]['id_sucursal'].toString(),
                "id_tipo_doc": data[i]['id_tipo_doc'].toString(),
                "numero":  data[i]['numero'].toString(),
                "fecha": convertDateFormat2(data[i]['fecha'].toString()),
                "total": data[i]['total'] ,
                "vencimiento": convertDateFormat2(data[i]['vencimiento'].toString()),
                "letras":  data[i]['letras'],
                "id_moneda": data[i]['id_moneda'],
                "id_tercero":  data[i]['id_tercero'].toString(),
                "id_sucursal_tercero": data[i]['id_sucursal_tercero'].toString(),
                "id_recaudador": data[i]['id_recaudador'].toString(),
                "fecha_trm": convertDateFormat2(data[i]['fecha_trm'].toString()),
                "trm": "1",
                "observaciones": data[i]['observaciones'],
                "usuario":  data[i]['usuario'],
                "flag_enviado": "SI",
                "cartera_proveedores_det": [
                  for (var j = 0; j < dataDet.length; j++) ...[
                    {
                      "consecutivo":  dataDet[j]['consecutivo'].toString(),
                      "cuota": dataDet[j]['cuota'].toString(),
                      "id_tercero": dataDet[j]['id_tercero'].toString(),
                      "id_sucursal_tercero": dataDet[j]['id_sucursal_tercero'].toString(),
                      "id_empresa_cruce": dataDet[j]['id_empresa_cruce'].toString(),
                      "id_sucursal_cruce": dataDet[j]['id_sucursal_cruce'].toString(),
                      "id_tipo_doc_cruce": dataDet[j]['id_tipo_doc_cruce'].toString(),
                      "numero_cruce": dataDet[j]['numero_cruce'].toString(),
                      "fecha": convertDateFormat3(dataDet[j]['fecha'].toString()),
                      "vencimiento":dataDet[j]['vencimiento'].toString(),
                      "debito": dataDet[j]['debito'],
                      "credito": dataDet[j]['credito'],
                      "descripcion": dataDet[j]['descripcion'],
                      "id_vendedor": dataDet[j]['id_vendedor'].toString(),
                      "id_forma_pago": dataDet[j]['id_forma_pago'].toString(),
                      "documento_forma_pago": dataDet[j]['documento_forma_pago'].toString(),
                      "distribucion":  dataDet[j]['distribucion'],
                      "trm": dataDet[j]['trm'],
                      "id_recaudador": "6220948",
                      "id_suc_recaudador":  dataDet[j]['id_suc_recaudador'].toString(),
                      "fecha_trm": convertDateFormat2(dataDet[j]['fecha_trm'].toString()),
                      "total_factura": dataDet[j]['total_factura'].toString(),
                      "id_concepto": dataDet[j]['id_concepto'].toString(),
                      "id_moneda": dataDet[j]['id_moneda'].toString(),
                      "id_destino": dataDet[j]['id_destino'].toString(),
                      "id_proyecto":  dataDet[j]['id_proyecto'].toString(),
                      "cuota_cruce":  dataDet[j]['cuota_cruce'].toString(),
                      "id_banco": dataDet[j]['id_banco'].toString(),
                    },
                  ]
                ]
              }
            ]
          });

          final response = await http.post(
              Uri.parse('${Constant.URL}/synchronization_carteraproveedores'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body : body
          );

          var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
          var success = jsonResponse['success'];

          if (response.statusCode == 201 && success) {
            final body = {
              'nit': data[i]['nit'],
              'id_tipo_doc':data[i]['id_tipo_doc'],
              'consecutivo':data[i]['numero'].toString(),
            };
            final response = await http
                .post(Uri.parse("${Constant.URL}/consecutivo_recibo_app"), body: (body));
            var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
            var success = jsonResponse['success'];

            if (response.statusCode == 200 && success) {
              await OperationDB.updateReciboFlag(data[i]['numero'].toString(), data[i]['nit'],data[i]['id_tipo_doc']);
            }
          }
        }
      }
    }
  }


  /////////////
  ///
  ///
  /////api obtiene todo las empresas de la bd postgres
  static  Future getEmpresaSincronizacion() async {
    print("empieza la sincronizacion que envia desde el login");
    final response = await http.get(Uri.parse("${Constant.URL}/empresa_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final empresa = Empresa(
              razon_social: data[i]['razon_social'],
              id_tipo_empresa: data[i]['id_tipo_empresa'],
              pre_actividad_economica: data[i]['pre_actividad_economica'],
              pre_cuenta: data[i]['pre_cuenta'],
              pre_medio_contacto: data[i]['pre_medio_contacto'],
              id_moneda: data[i]['id_moneda'],
              direccion: data[i]['direccion'],
              telefono: data[i]['telefono'],
              dv: data[i]['dv'],
              fax: data[i]['fax'] != null ? data[i]['fax'] : '',
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'],
              id_ciudad: data[i]['id_ciudad'],
              regimen_tributario: data[i]['regimen_tributario'] != null
                  ? data[i]['regimen_tributario']
                  : '',
              flag_iva: data[i]['flag_iva'],
              flag_forma_pago_efectivo: data[i]['flag_forma_pago_efectivo'],
              correo_electronico: data[i]['correo_electronico'],
              id_empresa: data[i]['id_empresa'],
              estado: data[i]['estado'].toString(),
              nit: data[i]['nit']);
          await OperationDB.insertEmpresa(empresa);
        }
      }
    }

    await getPaisSincronizacion();
  }


  static Future getPaisSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/pais_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final pais = Pais(
              id_pais: data[i]['id_pais'],
              ie_pais: data[i]['ie_pais'] != null ? data[i]['ie_pais']  : '',
              nacionalidad: data[i]['nacionalidad'],
              nombre: data[i]['nombre'],
              nit: data[i]['nit']);
          await OperationDB.insertPais(pais);
        }
      }
    }

    await getCiudadSincronizacion();
  }

  /////api obtiene todo las empresas de la bd postgres
  static Future getCiudadSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/ciudades_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final ciudad = Ciudad(
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'],
              id_ciudad: data[i]['id_ciudad'],
              nombre: data[i]['nombre'],
              nit: data[i]['nit']);
          await OperationDB.insertCiudad(ciudad);
        }
      }
    }

    await getZonaSincronizacion();

  }

  static Future getZonaSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/zona_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final zona = Zona(
              id_zona: data[i]['id_zona'],
              descripcion: data[i]['descripcion'],
              id_padre: data[i]['id_padre'],
              nivel: data[i]['nivel'].toString(),
              es_padre: data[i]['es_padre'],
              nit: data[i]['nit']);
          await OperationDB.insertZona(zona);
        }
      }
    }

    await getMedioContactoSincronizacion();
  }

  static Future getMedioContactoSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/medioContacto_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final contacto = MedioContacto(
              id_medio_contacto: data[i]['id_medio_contacto'],
              descripcion: data[i]['descripcion'],
              nit: data[i]['nit']);
          await OperationDB.insertMedioContacto(contacto);
        }
      }
    }

    await getTipoIdentificacion();
  }

  static Future getTipoIdentificacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/tipoidentificacion_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tipoIdentity = TipoIdentificacion(
              id_tipo_identificacion: data[i]['id_tipo_identificacion'],
              descripcion: data[i]['descripcion'] ,
              nit: data[i]['nit']);
          await OperationDB.insertTipoIdentificacion(tipoIdentity);
        }
      }
    }

    await getTipoEmpresa();
  }


  static Future getTipoEmpresa() async {
    final response = await http.get(Uri.parse("${Constant.URL}/tipoempresa_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tipoEmpresa = TipoEmpresa(
              id_tipo_empresa: data[i]['id_tipo_empresa'],
              descripcion: data[i]['descripcion'] ,
              nit: data[i]['nit']);
          await OperationDB.insertTipoEmpresa(tipoEmpresa);
        }
      }
    }

    await getBarrio();
  }

  static Future getBarrio() async {
    final response = await http.get(Uri.parse("${Constant.URL}/barrio_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final barrio = Barrio(
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'] ,
              id_ciudad: data[i]['id_ciudad'],
              id_barrio: data[i]['id_barrio'],
              nombre: data[i]['nombre'] ,
              nit: data[i]['nit']);
          await OperationDB.insertBarrio(barrio);
        }
      }
    }

    await getDepto();
  }

  static Future getDepto() async {
    final response = await http.get(Uri.parse("${Constant.URL}/depto_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final depto = Depto(
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'],
              nombre: data[i]['nombre'],
              nit: data[i]['nit']);
          await OperationDB.insertDepto(depto);
        }
      }
    }

    await getTipoDocSincronizacion();
  }

  static Future getTipoDocSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/tipodoc_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tipodoc = TipoDoc(
              id_empresa: data[i]['id_empresa'].toString(),
              id_sucursal: data[i]['id_sucursal'].toString(),
              id_clase_doc: data[i]['id_clase_doc'].toString(),
              id_tipo_doc: data[i]['id_tipo_doc'].toString(),
              consecutivo: data[i]['consecutivo'],
              descripcion: data[i]['descripcion'].toString(),
              nit: data[i]['nit']);
          await OperationDB.insertTipoDoc(tipodoc);
        }
      }
    }
    print("Finaliza la sincronizacion que envia desde el login");
    return true;
  }
}
