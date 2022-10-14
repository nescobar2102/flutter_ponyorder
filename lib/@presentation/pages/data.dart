import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pony_order/models/tercero_cliente.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:sqflite/sqflite.dart';
import '../../db/operationDB.dart';

import '../../models/tercero_direccion.dart';
import '../../models/usuario.dart';
import '../../models/sale.dart';
import '../../models/tercero.dart';
import '../../models/tercero_cliente.dart';
import '../../models/tipo_pago.dart';
import '../../models/empresa.dart';
import '../../models/ciudad.dart';
import '../../models/tipo_doc.dart';
import '../../models/factura.dart';
import '../../models/clasificacion_item.dart';
import '../../models/precio_item.dart';
import '../../models/zona.dart';
import '../../models/medio_contacto.dart';
import '../../models/pedido.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0xfff8f8f8);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum LoginStatus { notSignIn, signIn }

class LoginPages extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPages> {
 String _url = 'http://178.62.80.103:5000';
  // String _url = 'http://10.0.2.2:3000';

  bool focus = false;
  bool isOnline = false;
  bool _isLoading = false;

  Future<Null> _submitDialog(BuildContext context) async {
    return await showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        });
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  /////api obtiene todos los usuarios de la bd postgres
  Future getUsuariosSincronizacion() async {
    print("ingresa a la sincronizacion desde data");
    final response = await http.get(Uri.parse("$_url/users_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      //  await  OperationDB.deleteDataUsuario();
      for (int i = 0; i < data.length; i++) {
        final user = Usuario(
            id: i + 1,
            usuario: data[i]['usuario'],
            password: data[i]['clave'],
            nit: data[i]['nit'],
            id_tipo_doc_pe: data[i]['id_tipo_doc_pe'],
            id_tipo_doc_rc: data[i]['id_tipo_doc_rc']);
        print("manda a inserta usuariosssss $user");
        //   await OperationDB.insertUser(user) ;
      }
      await getCuotaVentaSincronizacion();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de usuarios",
        ),
      );
    }
  }

  /////api obtiene todos los tipo de pago de la bd postgres
  Future getTipoPagoSincronizacion() async {
    final response = await http.get(Uri.parse("$_url/tipopago_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tipo_pago = TipoPago(
              id_tipo_pago: data[i]['id_tipo_pago'],
              descripcion: data[i]['descripcion'],
              nit: data[i]['nit']);

          await OperationDB.insertTipoPago(tipo_pago);
        }
      }

      await getEmpresaSincronizacion();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de tipo de pago",
        ),
      );
    }
    final allTipoPago = await OperationDB.getTipoPago();
    print("muestra todos los getTipoPago  $allTipoPago");
  }

  /////api obtiene todo las empresas de la bd postgres
  Future getEmpresaSincronizacion() async {
    final response = await http.get(Uri.parse("$_url/empresa_all"));
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
      await getCiudadSincronizacion();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de Empresa",
        ),
      );
    }
    final allEmpresa = await OperationDB.getEmpresa();
    print("muestra todos los getEmpresa    $allEmpresa");
  }

  /////api obtiene todo las empresas de la bd postgres
  Future getCiudadSincronizacion() async {
    final response = await http.get(Uri.parse("$_url/ciudades_all"));
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
      await getTipoDocSincronizacion();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de Ciudad",
        ),
      );
    }
    final allCiudad = await OperationDB.getCiudad();
    print("muestra todos los getCiudad    $allCiudad");
  }

  Future getZonaSincronizacion() async {
    final response = await http.get(Uri.parse("$_url/zona_all"));
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
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de Zona",
        ),
      );
    }
    final allZona = await OperationDB.getZona();
    print("muestra todos los getZona  $allZona");

    await getMedioContactoSincronizacion();
  }

  Future getMedioContactoSincronizacion() async { 
    final response = await http.get(Uri.parse("$_url/medioContacto_all"));
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
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de MedioContacto",
        ),
      );
    }
    final allMedio = await OperationDB.getMedioContacto();
    print("muestra todos los getMedioContacto  $allMedio");
    await getTipoIdentificacion();
  }
  
  Future getTipoIdentificacion() async { 
    final response = await http.get(Uri.parse("$_url/app_tipoidentificacion_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tipo_identity = TipoIdentificacion(
              id_tipo_identificacion: data[i]['value'],
              descripcion: data[i]['label'] );
          await OperationDB.insertTipoIdentificacion(tipo_identity);
        }
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de TipoIdentificacion",
        ),
      );
    }
    final alltipo_identity= await OperationDB.getTipoIdentificacion();
    print("muestra todos los getTipoIdentificacion  $alltipo_identity");
    await getTipoEmpresa();
  }


  Future getTipoEmpresa() async {   
    final response = await http.get(Uri.parse("$_url/tipoempresa_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tipo_empresa = TipoEmpresa(
              id_tipo_empresa: data[i]['id_tipo_empresa'],
              descripcion: data[i]['descripcion'] ,
                 nit: data[i]['nit']);
          await OperationDB.insertTipoEmpresa(tipo_empresa);
        }
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de tipo_empresa",
        ),
      );
    }
    final alltipo_empresa= await OperationDB.getTipoEmpresa();
    print("muestra todos los getTipoEmpresa  $alltipo_empresa");
    await getBarrio();
  }
 

  Future getBarrio() async { 
    final response = await http.get(Uri.parse("$_url/barrio_all"));
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
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de barrio",
        ),
      );
    }
    final allbarrio= await OperationDB.getBarrio();
    print("muestra todos los getBarrio  $allbarrio");
    await getDepto();
  }

  Future getDepto() async {
    final response = await http.get(Uri.parse("$_url/depto_all"));
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
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de insertDepto",
        ),
      );
    }
    final alldepto= await OperationDB.getDepto();
    print("muestra todos los getDepto  $alldepto");
    await getPedido();
  }


  Future getPedido() async {  
    final response = await http.get(Uri.parse("$_url/pedido_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final pedido = Pedido(
              id_empresa:data[i]['id_empresa'],id_sucursal:data[i]['id_sucursal'],
              id_tipo_doc:data[i]['id_tipo_doc'],numero:data[i]['numero'].toString(),
              id_tercero:data[i]['id_tercero'],id_sucursal_tercero:data[i]['id_sucursal_tercero'].toString(),
              id_vendedor:data[i]['id_vendedor'], id_suc_vendedor:data[i]['id_suc_vendedor'].toString(),
              fecha:data[i]['fecha'],vencimiento:data[i]['vencimiento'],
              fecha_entrega:data[i]['fecha_entrega'],  fecha_trm:data[i]['fecha_trm'],
              id_forma_pago:data[i]['id_forma_pago'], id_precio_item:data[i]['id_precio_item'], 
              id_direccion:data[i]['id_direccion'],id_moneda:data[i]['id_moneda'],
              trm :data[i]['trm'], subtotal:data[i]['subtotal'],  
              total_costo:data[i]['total_costo'], total_iva:data[i]['total_iva'], 
              total_dcto:data[i]['total_dcto'],total:data[i]['total'],
              total_item:data[i]['total_item'],  orden_compra:data[i]['orden_compra'], 
              estado:data[i]['estado'], flag_autorizado:data[i]['flag_autorizado'], 
              comentario:data[i]['comentario'],observacion:data[i]['observacion'], 
              letras:data[i]['letras'], id_direccion_factura:data[i]['id_direccion_factura'],
              usuario:data[i]['usuario'],  id_tiempo_entrega:data[i]['id_tiempo_entrega'].toString(),
              flag_enviado:data[i]['flag_enviado'], nit:data[i]['nit']              );
          await OperationDB.insertPedido(pedido);
        }
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de insertPedido",
        ),
      );
    }
    final allPedido= await OperationDB.getPedido();
    print("muestra todos los getPedido  $allPedido");
    await getPedidoDet();
  }


  Future getPedidoDet() async {
    //ULTIMO
    final response = await http.get(Uri.parse("$_url/pedido_det_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final pedidodet = PedidoDet(
                    id_empresa:data[i]['id_empresa'],id_sucursal:data[i]['id_sucursal'],
                    id_tipo_doc:data[i]['id_tipo_doc'],numero:data[i]['numero'].toString(),
                    id_precio_item:data[i]['id_precio_item'], 
                    subtotal:data[i]['subtotal'],  descripcion_item:data[i]['descripcion_item'],
                    total_iva:data[i]['total_iva'], 
                    total_dcto:data[i]['total_dcto'],total:data[i]['total'],
                    total_item:data[i]['total_item'],  
                    nit:data[i]['nit'],consecutivo:data[i]['consecutivo'],id_item:data[i]['id_item'],id_bodega:data[i]['id_bodega'],
                    cantidad: data[i]['cantidad'],precio:data[i]['precio'],precio_lista:data[i]['precio_lista'],tasa_iva:data[i]['tasa_iva'],
                    tasa_dcto_fijo:data[i]['tasa_dcto_fijo'],total_dcto_fijo:data[i]['total_dcto_fijo'],costo:data[i]['costo'],
                    id_unidad:data[i]['id_unidad'],cantidad_kit:data[i]['cantidad_kit'], cantidad_de_kit:data[i]['cantidad_de_kit'],
                    recno:data[i]['recno'].toString(),factor:data[i]['factor'],id_impuesto_iva:data[i]['id_impuesto_iva'],total_dcto_adicional:data[i]['total_dcto_adicional'],
                    tasa_dcto_adicional:data[i]['tasa_dcto_adicional'],id_kit:data[i]['id_kit'],precio_kit:data[i]['precio_kit'],
                    tasa_dcto_cliente:data[i]['tasa_dcto_cliente'].toString(),total_dcto_cliente:data[i]['total_dcto_cliente'].toString()
          );
          await OperationDB.insertPedidoDet(pedidodet);
        }
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de getPedidoDet",
        ),
      );
    }
    final ALLPEDIDODET= await OperationDB.getPedidoDet();
    print("muestra todos los getPedidoDet  $ALLPEDIDODET");
  }



  Future searchTercero() async {
    print("buscar el searchTercero");

    final response = await http.get(Uri.parse("$_url/tercero_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    print("------response $success");
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      print("------response data data $data");
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tercero = Tercero(
              id_tercero: data[i]['id_tercero'].toString(),
              id_sucursal_tercero: data[i]['id_sucursal_tercero'],
              id_tipo_identificacion: data[i]['id_tipo_identificacion'],
              dv: data[i]['dv'],
              nombre: data[i]['nombre'],
              direccion: data[i]['direccion'],
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'],
              id_ciudad: data[i]['id_ciudad'],
              id_barrio: data[i]['id_barrio'],
              telefono: data[i]['telefono'],
               id_actividad: data[i]['id_actividad'] != null
                  ? data[i]['id_actividad']
                  : '',  
              id_tipo_empresa: data[i]['id_tipo_empresa'],
              cliente: data[i]['cliente'],
              fecha_creacion: data[i]['fecha_creacion'],
              nombre_sucursal: data[i]['nombre_sucursal'],
              primer_apellido: data[i]['primer_apellido'],
              segundo_apellido: data[i]['segundo_apellido'],
              primer_nombre: data[i]['primer_nombre'],
              segundo_nombre: data[i]['segundo_nombre'] != null
                  ? data[i]['segundo_nombre']
                  : '',
              flag_persona_nat: data[i]['flag_persona_nat'],
              estado_tercero: data[i]['estado_tercero'],
              vendedor: data[i]['vendedor'],
              id_lista_precio: data[i]['id_lista_precio'] != null
                  ? data[i]['id_lista_precio']
                  : '',
              id_forma_pago: data[i]['id_forma_pago'] != null
                  ? data[i]['id_forma_pago']
                  : '',
              usuario: data[i]['usuario'] != null ? data[i]['usuario'] : '',
              flag_enviado: 'NO',
              e_mail: data[i]['e_mail'],
              telefono_celular: data[i]['telefono_celular'] != null
                  ? data[i]['telefono_celular']
                  : '',
              e_mail_fe:
                  data[i]['e_mail_fe'] != null ? data[i]['e_mail_fe'] : '',
              nit: data[i]['nit']);
          print("manda a inserta tercerosssssssss  $tercero");
          await OperationDB.insertTercero(tercero);
        }
      }

      await searchTerceroCliente();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "error en la sincronizacion de tercero",
        ),
      );
    }
    final allTercero = await OperationDB.getTercero();
    print("muestra todos los TERCEROss    $allTercero");
  }

  Future searchTerceroCliente() async {
    print("buscar el tercero cliente");

    final response = await http.get(Uri.parse("$_url/cliente_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    print("------response $success");
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tercero_cliente = TerceroCliente(
              id_tercero: data[i]['id_tercero'],
              id_sucursal_tercero: data[i]['id_sucursal_tercero'],
              id_forma_pago: data[i]['id_forma_pago'],
              id_precio_item: data[i]['id_precio_item'].toString(),
              id_vendedor: data[i]['id_vendedor'],
              id_suc_vendedor: data[i]['id_suc_vendedor'],
              id_medio_contacto: data[i]['id_medio_contacto'],
              id_zona: data[i]['id_zona'],
              flag_exento_iva: data[i]['flag_exento_iva'],
              dia_cierre: data[i]['dia_cierre'].toString(),
              id_impuesto_reteiva: data[i]['id_impuesto_reteiva'] != null
                  ? data[i]['id_impuesto_reteiva']
                  : '',
              id_agente_reteiva: data[i]['id_agente_reteiva'] != null
                  ? data[i]['id_agente_reteiva']
                  : '',
              id_impuesto_reteica: data[i]['id_impuesto_reteica'] != null
                  ? data[i]['id_impuesto_reteica']
                  : '',
              id_agente_reteica: data[i]['id_agente_reteica'] != null
                  ? data[i]['id_agente_reteica']
                  : '',
              id_impuesto_retefuente: data[i]['id_impuesto_retefuente'] != null
                  ? data[i]['id_impuesto_retefuente']
                  : '',
              id_agente_retefuente: data[i]['id_agente_retefuente'] != null
                  ? data[i]['id_agente_retefuente']
                  : '',
              id_agente_retecree: data[i]['id_agente_retecree'] != null
                  ? data[i]['id_agente_retecree']
                  : '',
              id_impuesto_retecree: data[i]['id_impuesto_retecree'] != null
                  ? data[i]['id_impuesto_retecree']
                  : '',
              id_tamanno: data[i]['id_tamanno'].toString() != null
                  ? data[i]['id_tamanno'].toString()
                  : '',
              limite_credito: data[i]['limite_credito'],
              dias_gracia: data[i]['dias_gracia'],
              flag_cartera_vencida: data[i]['flag_cartera_vencida'],
              dcto_cliente: data[i]['dcto_cliente'],
              dcto_adicional: data[i]['dcto_adicional'],
              numero_facturas_vencidas: data[i]['numero_facturas_vencidas'],
              nit: data[i]['nit']);
          print("manda a inserta tercero_clientessssss  $tercero_cliente");
          await OperationDB.insertTerceroCliente(tercero_cliente);
        }
      }

      await searchTerceroDireccion();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "error en la sincronizacion de tercero cliente",
        ),
      );
    }
    final allTerceroCliente = await OperationDB.getTerceroCliente();
    print("muestra todos los TERCERO CLIENTE  $allTerceroCliente");
  }

  Future searchTerceroDireccion() async {
    print("buscar el tercero direccion");

    final response = await http.get(Uri.parse("$_url/direccion_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    print("------response $success");
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tercero_direccion = TerceroDireccion(
              id_tercero: data[i]['id_tercero'],
              id_sucursal_tercero: data[i]['id_sucursal_tercero'],
              id_direccion: data[i]['id_direccion'],
              direccion: data[i]['direccion'],
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'],
              id_ciudad: data[i]['id_ciudad'],
              telefono: data[i]['telefono'],
              tipo_direccion: data[i]['tipo_direccion'],
              nit: data[i]['nit']);
          print("manda a inserta tercero_clientessssss  $tercero_direccion");
          await OperationDB.insertTerceroDireccion(tercero_direccion);
        }
      }

      await getTipoPagoSincronizacion();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "error en la sincronizacion de tercero direccion",
        ),
      );
    }
    final allTerceroDireccion = await OperationDB.getTerceroDireccion();
    print("muestra todos los TERCERO DIRECCION  $allTerceroDireccion");
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getCuotaVentaSincronizacion() async {
    print("ingresa a la cuota venta");
    final response = await http.get(Uri.parse("$_url/cuotaventas_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      print("la data que se obtiene de la api $data");
      if (data.length > 0) {
        await OperationDB.deleteCuota();
        for (int i = 0; i < data.length; i++) {
          final sale = Sale(
              venta: data[i]['venta'].toString(),
              cuota: data[i]['cuota'].toString(),
              id_linea: data[i]['id_linea'],
              nombre: data[i]['nombre'],
              nit: data[i]['nit'],
              id_vendedor: data[i]['id_vendedor'],
              id_suc_vendedor: data[i]['id_suc_vendedor']);
          print("manda a inserta cuota_Venta $sale");
          await OperationDB.insertCuotaVenta(sale);
        }
        final allSale = await OperationDB.cuotaventaAll();
        print(
            "muestra todos los registro de cuota venta  desde dataaaaa $allSale");
      }
      await searchTercero();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de cuota venta",
        ),
      );
    }
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getTipoDocSincronizacion() async {
    //consecutivo
    print("ingresa a tipo doc");
    final response = await http.get(Uri.parse("$_url/tipodoc_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
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
          print("manda a inserta tipodoc $tipodoc");
          await OperationDB.insertTipoDoc(tipodoc);
        }
        final allTipoDoc = await OperationDB.getTipoDoc();
        print(
            "muestra todos los registro de tipodoc desde dataaaaa $allTipoDoc");
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de tipodoc",
        ),
      );
    }
    await getFacturaSincronizacion();
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getFacturaSincronizacion() async {
    //consecutivo
    print("ingresa a factura");
    final response = await http.get(Uri.parse("$_url/factura_app_movil"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];

    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final factura = Factura(
              id_tercero: data[i]['id_tercero'].toString(),
              numero: data[i]['numero'].toString(),
              fecha: data[i]['fecha'].toString(),
              total_fac: data[i]['total_fac'].toString(),
              id_item: data[i]['id_item'],
              descripcion_item: data[i]['descripcion_item'],
              precio: data[i]['precio'].toString(),
              cantidad: data[i]['cantidad'],
              total: data[i]['total']);
          print("manda a inserta factura $factura");
          await OperationDB.insertFactura(factura);
        }
        final allFactura = await OperationDB.getFactura();
        print(
            "muestra todos los registro de factura desde dataaaaa $allFactura");
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de factura",
        ),
      );
    }

    await getCalsificacionItemSincronizacion();
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getCalsificacionItemSincronizacion() async {
    //consecutivo
    print("ingresa a getCalsificacionItemSincronizacion");
    final response = await http.get(Uri.parse("$_url/clasificacionItems_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];

    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final claitem = ClasificacionItems(
            id_clasificacion: data[i]['id_clasificacion'].toString(),
            descripcion: data[i]['descripcion'].toString(),
            id_padre: data[i]['id_padre'].toString(),
            nivel: data[i]['nivel'].toString(),
            es_padre: data[i]['es_padre'],
            nit: data[i]['nit'],
            foto: data[i]['foto'].toString() != null
                ? data[i]['foto'].toString()
                : '',
            imagen: data[i]['imagen'].toString() != null
                ? data[i]['imagen'].toString()
                : '',
          );
          print("manda a inserta claitem $claitem");
          await OperationDB.insertClasificacionItem(claitem);
        }
        final allClasiItem = await OperationDB.getClasificacionItem();
        print(
            "muestra todos los registro de clasificac desde dataaaaa $allClasiItem");
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de clasificac",
        ),
      );
    }
    await getPrecioItemSincronizacion();
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getPrecioItemSincronizacion() async {
    //consecutivo
    print("ingresa a getPrecioItemSincronizacion");
    final response = await http.get(Uri.parse("$_url/precioitem_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];

    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final precioitem = PrecioItems(
            id_precio_item: data[i]['id_precio_item'].toString(),
            descripcion: data[i]['descripcion'].toString(),
            vigencia_desde: data[i]['vigencia_desde'].toString(),
            vigencia_hasta: data[i]['vigencia_hasta'].toString(),
            id_margen_item: data[i]['id_margen_item'],
            id_moneda: data[i]['id_moneda'].toString() != null
                ? data[i]['id_moneda'].toString()
                : '',
            flag_iva_incluido: data[i]['flag_iva_incluido'].toString() != null
                ? data[i]['flag_iva_incluido'].toString()
                : '',
            flag_lista_base: data[i]['flag_lista_base'].toString() != null
                ? data[i]['flag_lista_base'].toString()
                : '',
            nit: data[i]['nit'],
          );
          print("manda a inserta insertPrecioItem $precioitem");
          await OperationDB.insertPrecioItem(precioitem);
        }
        final allPrecioItem = await OperationDB.getPrecioItem();
        print(
            "muestra todos los registro de insertPrecioItem desde dataaaaa $allPrecioItem");
        await getPrecioItemDetSincronizacion();
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de factura",
        ),
      );
    }
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getPrecioItemDetSincronizacion() async {
    //consecutivo
    print("ingresa a getPrecioItemDetSincronizacion");
    final response = await http.get(Uri.parse("$_url/precioitemdet_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];

    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final precioitemDet = PrecioItemsDet(
            precio: data[i]['precio'].toString(),
            id_precio_item: data[i]['id_precio_item'].toString(),
            id_item: data[i]['id_item'].toString(),
            descuento_maximo: data[i]['descuento_maximo'].toString(),
            id_talla: data[i]['id_talla'].toString(),
            id_moneda: data[i]['id_moneda'].toString() != null
                ? data[i]['id_moneda'].toString()
                : '',
            id_unidad_compra: data[i]['id_unidad_compra'].toString() != null
                ? data[i]['id_unidad_compra'].toString()
                : '',
            nit: data[i]['nit'],
          );
          print("manda a inserta insertPrecioItemDet $precioitemDet");
          await OperationDB.insertPrecioItemDet(precioitemDet);
        }
        final allPrecioItemDet = await OperationDB.getPrecioItemDet();
        print(
            "muestra todos los registro de insertPrecioItem DERdesde dataaaaa $allPrecioItemDet");
        await getItemSincronizacion();
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de factura",
        ),
      );
    }
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getItemSincronizacion() async {
    //consecutivo
    print("ingresa a getItemSincronizacion");
    final response = await http.get(Uri.parse("$_url/item_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];

    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
       // await OperationDB.deleteItem();
        for (int i = 0; i < data.length; i++) {
          final item = Items(
            id_item: data[i]['id_item'].toString(),
            descripcion: data[i]['descripcion'].toString(),
            referencia: data[i]['referencia'].toString(),
            id_impuesto: data[i]['id_impuesto'].toString(),
            tipo_impuesto: data[i]['tipo_impuesto'].toString(),
            dcto_producto: data[i]['dcto_producto'].toString(),
            dcto_maximo: data[i]['dcto_maximo'].toString(),
            flag_facturable: data[i]['flag_facturable'],
            flag_serial: data[i]['flag_serial'],
            flag_kit: data[i]['flag_kit'],
            id_clasificacion: data[i]['id_clasificacion'],
            id_padre_clasificacion: data[i]['id_padre_clasificacion'],
            id_unidad_compra: data[i]['id_unidad_compra'],
            exento_impuesto: data[i]['exento_impuesto'],
            flag_existencia: data[i]['flag_existencia'],
            flag_dcto_volumen: data[i]['flag_dcto_volumen'],
            nit: data[i]['nit'],
            saldo_inventario: data[i]['saldo_inventario'].toString() != null
                ? data[i]['saldo_inventario'].toString()
                : '0',
          );
          print("manda a inserta item $item");
          await OperationDB.inserItem(item);
        }
        final allItem = await OperationDB.getItem();
        print("muestra todos los registro de item dataaaaa $allItem");
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizacion de factura",
        ),
      );
    }
    await getZonaSincronizacion();
  }

  /////api
  Future getItemTypeIdentication() async {
    final response =
        await http.get(Uri.parse("$_url/app_tipoidentificacion_all"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object object $data");
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizaciond e ",
        ),
      );
    }
  }

  /////api
  Future getItems() async {
    final response = await http.get(Uri.parse("$_url/item_all"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      print("object object $data");
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la sincronizaciond Items ",
        ),
      );
    }
  }

  //visual
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _background(context),
          CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                _form(context),
              ]))
            ],
          ),
        ],
      ),
    );
  }

  //nn
  Widget showPrimaryButton(String title, bool action) {
    final _size = MediaQuery.of(context).size;
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          width: _size.width - 20.0,
          child: new ElevatedButton(
            child: Center(
              child: Text(
                '$title',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            onPressed: () {
              action
                  ? getCuotaVentaSincronizacion()
                  : Navigator.pushNamed(context, 'home');
            },
          ),
        ));
  }

  Widget _background(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      height: 500,
      color: Colors.white,
      child: CustomPaint(
        painter: CurvePainter(),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _bar = MediaQuery.of(context).padding.top;
    //safeArea for android
    return SafeArea(
      bottom: false,
      top: true,
      child: Container(
        width: _size.width,
        height: _size.height - _bar,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Text(
                      'Ultima sincronizacion 26-09-2022 15:33',
                      style: TextStyle(
                          color: Color(0xff06538D),
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Versión D-18-11-2022',
                      style: TextStyle(
                          color: Color(0xff06538D),
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              showPrimaryButton('Sincronización', true),
              SizedBox(
                height: 20.0,
              ),
              showPrimaryButton('Regresar', false),
            ],
          ),
        ),
      ),
    );
  }
}
