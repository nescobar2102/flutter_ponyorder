import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:pony_order/models/tercero_cliente.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../db/operationDB.dart';
import '../../httpConexion/validateConexion.dart';
import '../../Common/Constant.dart';

import '../../models/tercero_direccion.dart';
import '../../models/sale.dart';
import '../../models/tercero.dart';
import '../../models/tercero_cliente.dart';
import '../../models/tipo_pago.dart';
import '../../models/factura.dart';
import '../../models/clasificacion_item.dart';
import '../../models/precio_item.dart';
import '../../models/pedido.dart';
import '../../models/recibo_caja.dart';

import './sendData.dart';
import 'dart:convert';

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

class LoginPages extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPages> {
  bool focus = false;
  bool _isConnected = false;
  String date = '';
  double porcentajeAvance = 0;
  bool startSincro = false;
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
              ),
            ],
          );
        });
  }

  void _showMSG(msg) {
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: msg,
      ),
    );
  }

  Future<String> convertToBase64(file) async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/seeImagen/$file"));
    String _base64 = base64Encode(response.bodyBytes);
    return _base64;
  }

  static convertDateFormat(fecha) {
    var info = fecha.split('T00:00:00.000Z');
    var nuevaFecha2 = info[0];
    return nuevaFecha2;
  }

  @override
  void initState() {
    super.initState();
    getSincronizacion();
  }

  Future getSincronizacion() async {
    var data = await OperationDB.getSincronizacion();
    if (data != false) {
      setState(() {
        date = data[0]['create_at'];
      });
    }
  }

  Future getTipoPagoSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/tipopago_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
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
    }
    setState(() {
      porcentajeAvance = 28;
    });
    await getFacturaSincronizacion();
  }

  Future getPedido() async {
    final response = await http.get(Uri.parse("${Constant.URL}/pedido_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final pedido = Pedido(
              id_empresa: data[i]['id_empresa'],
              id_sucursal: data[i]['id_sucursal'],
              id_tipo_doc: data[i]['id_tipo_doc'],
              numero: data[i]['numero'].toString(),
              id_tercero: data[i]['id_tercero'],
              id_sucursal_tercero: data[i]['id_sucursal_tercero'].toString(),
              id_vendedor: data[i]['id_vendedor'],
              id_suc_vendedor: data[i]['id_suc_vendedor'].toString(),
              fecha: convertDateFormat(data[i]['fecha']),
              vencimiento: convertDateFormat(data[i]['vencimiento']),
              fecha_entrega: convertDateFormat(data[i]['fecha_entrega']),
              fecha_trm: convertDateFormat(data[i]['fecha_trm']),
              id_forma_pago: data[i]['id_forma_pago'],
              id_precio_item: data[i]['id_precio_item'],
              id_direccion: data[i]['id_direccion'],
              id_moneda: data[i]['id_moneda'],
              trm: data[i]['trm'],
              subtotal: data[i]['subtotal'],
              total_costo: data[i]['total_costo'],
              total_iva: data[i]['total_iva'],
              total_dcto: data[i]['total_dcto'],
              total: data[i]['total'],
              total_item: data[i]['total_item'],
              orden_compra: data[i]['orden_compra'],
              estado: data[i]['estado'],
              flag_autorizado: data[i]['flag_autorizado'],
              comentario: data[i]['comentario'],
              observacion: data[i]['observacion'],
              letras: data[i]['letras'],
              id_direccion_factura: data[i]['id_direccion_factura'],
              usuario: data[i]['usuario'],
              id_tiempo_entrega: data[i]['id_tiempo_entrega'].toString(),
              flag_enviado: data[i]['flag_enviado'],
              nit: data[i]['nit']);
          await OperationDB.insertPedido(pedido, false);
        }
      }
    }
    setState(() {
      porcentajeAvance = 62;
    });
    await getPedidoDet();
  }

  Future getPedidoDet() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/pedido_det_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final pedidodet = PedidoDet(
              id_empresa: data[i]['id_empresa'],
              id_sucursal: data[i]['id_sucursal'],
              id_tipo_doc: data[i]['id_tipo_doc'],
              numero: data[i]['numero'].toString(),
              id_precio_item: data[i]['id_precio_item'],
              subtotal: data[i]['subtotal'],
              descripcion_item: data[i]['descripcion_item'],
              total_iva: data[i]['total_iva'],
              total_dcto: data[i]['total_dcto'],
              total: data[i]['total'],
              total_item: data[i]['total_item'],
              nit: data[i]['nit'],
              consecutivo: data[i]['consecutivo'],
              id_item: data[i]['id_item'],
              id_bodega: data[i]['id_bodega'],
              cantidad: data[i]['cantidad'],
              precio: data[i]['precio'],
              precio_lista: data[i]['precio_lista'],
              tasa_iva: data[i]['tasa_iva'],
              tasa_dcto_fijo: data[i]['tasa_dcto_fijo'],
              total_dcto_fijo: data[i]['total_dcto_fijo'],
              costo: data[i]['costo'],
              id_unidad: data[i]['id_unidad'],
              cantidad_kit: data[i]['cantidad_kit'],
              cantidad_de_kit: data[i]['cantidad_de_kit'],
              recno: data[i]['recno'].toString(),
              factor: data[i]['factor'],
              id_impuesto_iva: data[i]['id_impuesto_iva'],
              total_dcto_adicional: data[i]['total_dcto_adicional'],
              tasa_dcto_adicional: data[i]['tasa_dcto_adicional'],
              id_kit: data[i]['id_kit'],
              precio_kit: data[i]['precio_kit'],
              tasa_dcto_cliente: data[i]['tasa_dcto_cliente'].toString(),
              total_dcto_cliente: data[i]['total_dcto_cliente'].toString());
          await OperationDB.insertPedidoDet(pedidodet, false);
        }
      }
    }
    setState(() {
      porcentajeAvance = 66;
    });
    await getCuentaTercero();
  }

  Future getCuentaTercero() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/cuentaportercero_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final cuenta_tercero = CuentaTercero(
              id_empresa: data[i]['id_empresa'],
              id_sucursal: data[i]['id_sucursal'],
              tipo_doc: data[i]['tipo_doc'],
              numero: data[i]['numero'],
              cuota: data[i]['cuota'],
              dias: data[i]['dias'],
              id_tercero: data[i]['id_tercero'].toString(),
              id_vendedor: data[i]['id_vendedor'].toString(),
              id_sucursal_tercero: data[i]['id_sucursal_tercero'],
              fecha: data[i]['fecha'],
              vencimiento: data[i]['vencimiento'],
              credito: data[i]['credito'].toString(),
              dctomax: data[i]['dctomax'].toString(),
              debito: data[i]['debito'].toString(),
              id_destino: data[i]['id_destino'].toString(),
              id_proyecto: data[i]['id_proyecto'].toString(),
              nit: data[i]['nit'],
              id_empresa_cruce: data[i]['id_empresa_cruce'],
              id_sucursal_cruce: data[i]['id_sucursal_cruce'],
              tipo_doc_cruce: data[i]['tipo_doc_cruce'],
              numero_cruce: data[i]['numero_cruce'].toString(),
              cuota_cruce: data[i]['cuota_cruce'].toString(),
              flag_enviado: 'SI');
          await OperationDB.insertCuentaTercero(cuenta_tercero);
        }
      }
    }
    setState(() {
      porcentajeAvance = 70;
    });
    await getCarteraProveedores();
  }

  Future getCarteraProveedores() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/carteraproveedores_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final cartera = CarteraProveedores(
            id_empresa: data[i]['id_empresa'],
            id_sucursal: data[i]['id_sucursal'],
            id_tipo_doc: data[i]['id_tipo_doc'],
            numero: data[i]['numero'],
            fecha: convertDateFormat(data[i]['fecha']),
            total: data[i]['total'].toString(),
            vencimiento: convertDateFormat(data[i]['vencimiento']),
            letras: data[i]['letras'],
            id_moneda: data[i]['id_moneda'],
            id_tercero: data[i]['id_tercero'].toString(),
            id_sucursal_tercero: data[i]['id_sucursal_tercero'],
            id_recaudador: data[i]['id_recaudador'].toString(),
            fecha_trm: convertDateFormat(data[i]['fecha_trm']),
            trm: data[i]['trm'].toString(),
            observaciones: data[i]['observaciones'],
            usuario: data[i]['usuario'],
            flag_enviado: data[i]['flag_enviado'],
            nit: data[i]['nit'],
          );
          await OperationDB.insertCarteraProveedores(cartera);
          await getCarteraProveedoresDet(
              cartera.id_empresa, cartera.numero, cartera.nit);
        }
      }
    }
    setState(() {
      porcentajeAvance = 75;
    });
    await getAuxiliar();
  }

  Future getCarteraProveedoresDet(id_empresa, numero, nit) async {
    final response = await http.get(Uri.parse(
        "${Constant.URL}/carteraproveedoresdet_all/$id_empresa/$numero/$nit"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final carteraDet = CarteraProveedoresDet(
              id_empresa: data[i]['id_empresa'],
              id_sucursal: data[i]['id_sucursal'],
              id_tipo_doc: data[i]['id_tipo_doc'],
              numero: data[i]['numero'],
              consecutivo: data[i]['consecutivo'],
              id_empresa_cruce: data[i]['id_empresa_cruce'],
              id_sucursal_cruce: data[i]['id_sucursal_cruce'],
              id_tipo_doc_cruce: data[i]['id_tipo_doc_cruce'],
              numero_cruce: data[i]['numero_cruce'],
              debito: data[i]['debito'].toString(),
              credito: data[i]['credito'].toString(),
              id_vendedor: data[i]['id_vendedor'].toString(),
              id_forma_pago: data[i]['id_forma_pago'],
              documento_forma_pago: data[i]['documento_forma_pago'],
              cuota: data[i]['cuota'],
              distribucion: data[i]['distribucion'],
              descripcion: data[i]['descripcion'],
              id_suc_recaudador: data[i]['id_suc_recaudador'],
              total_factura: data[i]['total_factura'].toString(),
              id_concepto: data[i]['id_concepto'],
              id_moneda: data[i]['id_moneda'],
              id_destino: data[i]['id_destino'],
              id_proyecto: data[i]['id_proyecto'],
              cuota_cruce: data[i]['cuota_cruce'],
              id_banco: data[i]['id_banco'],
              fecha: data[i]['fecha'],
              vencimiento: data[i]['vencimiento'],
              id_tercero: data[i]['id_tercero'].toString(),
              id_sucursal_tercero: data[i]['id_sucursal_tercero'],
              id_recaudador: data[i]['id_recaudador'].toString(),
              fecha_trm: data[i]['fecha_trm'],
              trm: data[i]['trm'].toString(),
              nit: data[i]['nit']);
          await OperationDB.insertCarteraProveedoresDet(carteraDet);
        }
      }
    }
  }

  Future getAuxiliar() async {
    final response = await http.get(Uri.parse("${Constant.URL}/auxiliar_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        await OperationDB.deleteAuxiliar();
        for (int i = 0; i < data.length; i++) {
          final auxiliar = Auxiliar(
              id_auxiliar: data[i]['id_auxiliar'],
              descripcion: data[i]['descripcion'],
              flag_flujo_caja: data[i]['flag_flujo_caja'],
              id_tipo_cuenta: data[i]['id_tipo_cuenta'],
              nit: data[i]['nit']);
          await OperationDB.insertAuxiliar(auxiliar);
        }
      }
    }
    setState(() {
      porcentajeAvance = 78;
    });
    await getConcepto();
  }

  Future getConcepto() async {
    final response = await http.get(Uri.parse("${Constant.URL}/concepto_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final concepto = Concepto(
              id_concepto: data[i]['id_concepto'],
              descripcion: data[i]['descripcion'],
              naturalezacta: data[i]['naturalezacta'],
              id_auxiliar: data[i]['id_auxiliar'],
              nit: data[i]['nit']);
          await OperationDB.insertConcepto(concepto);
        }
      }
    }
    setState(() {
      porcentajeAvance = 80;
    });
    await getBanco();
  }

  Future getBanco() async {
    final response = await http.get(Uri.parse("${Constant.URL}/banco_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final banco = Banco(
              id_banco: data[i]['id_banco'],
              descripcion: data[i]['descripcion'],
              nit: data[i]['nit']);
          await OperationDB.insertBanco(banco);
        }
      }
    }
    setState(() {
      porcentajeAvance = 84;
    });
    await getFormaPago();
  }

  Future getFormaPago() async {
    //ULTIMO
    final response = await http.get(Uri.parse("${Constant.URL}/formapago_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final formapago = FormaPago(
            id_forma_pago: data[i]['id_forma_pago'],
            descripcion: data[i]['descripcion'],
            id_precio_item: data[i]['id_precio_item'],
            nit: data[i]['nit'],
          );
          await OperationDB.insertFormaPago(formapago);
        }
      }
    }
    await OperationDB.insertSincronizacion();
    setState(() {
      porcentajeAvance = 100;
    });
    Navigator.pop(context);
    _showMSG('Sincronización exitosa');
    Navigator.pushNamed(context, 'home');
  }

  Future searchTercero() async {
    final response = await http.get(Uri.parse("${Constant.URL}/tercero_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        await OperationDB.deleteTercero();
        for (int i = 0; i < data.length; i++) {
          final tercero = Tercero(
              id_tercero: data[i]['id_tercero'].toString(),
              id_sucursal_tercero: data[i]['id_sucursal_tercero'].toString(),
              id_tipo_identificacion: data[i]['id_tipo_identificacion'],
              dv: data[i]['dv'],
              nombre: data[i]['nombre'],
              direccion: data[i]['direccion'],
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'],
              id_ciudad: data[i]['id_ciudad'],
              id_barrio: data[i]['id_barrio'],
              telefono: data[i]['telefono'] != null ? data[i]['telefono'] : '',
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
              flag_enviado: 'SI',
              e_mail: data[i]['e_mail'],
              telefono_celular: data[i]['telefono_celular'] != null
                  ? data[i]['telefono_celular']
                  : '',
              e_mail_fe:
                  data[i]['e_mail_fe'] != null ? data[i]['e_mail_fe'] : '',
              nit: data[i]['nit']);
          await OperationDB.insertTercero(tercero);
        }
      }
    }
    setState(() {
      porcentajeAvance = 15;
    });
    await searchTerceroCliente();
  }

  Future searchTerceroCliente() async {
    final response = await http.get(Uri.parse("${Constant.URL}/cliente_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tercero_cliente = TerceroCliente(
              id_tercero: data[i]['id_tercero'].toString(),
              id_sucursal_tercero: data[i]['id_sucursal_tercero'].toString(),
              id_forma_pago: data[i]['id_forma_pago'],
              id_precio_item: data[i]['id_precio_item'].toString(),
              id_vendedor: data[i]['id_vendedor'].toString(),
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
              nit: data[i]['nit'],
              flag_enviado: 'SI');
          await OperationDB.insertTerceroCliente(tercero_cliente);
        }
      }
    }
    setState(() {
      porcentajeAvance = 20;
    });
    await searchTerceroDireccion();
  }

  Future searchTerceroDireccion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/direccion_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final tercero_direccion = TerceroDireccion(
              id_tercero: data[i]['id_tercero'].toString(),
              id_sucursal_tercero: data[i]['id_sucursal_tercero'].toString(),
              id_direccion: data[i]['id_direccion'],
              direccion: data[i]['direccion'],
              id_pais: data[i]['id_pais'],
              id_depto: data[i]['id_depto'],
              id_ciudad: data[i]['id_ciudad'],
              telefono: data[i]['telefono'],
              tipo_direccion: data[i]['tipo_direccion'],
              nit: data[i]['nit'],
              flag_enviado: 'SI');
          await OperationDB.insertTerceroDireccion(tercero_direccion);
        }
      }
    }
    setState(() {
      porcentajeAvance = 25;
    });
    await getTipoPagoSincronizacion();
  }

  /////api obtiene todos los registros de cuota venta de la bd de postgres
  Future getCuotaVentaSincronizacion() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/cuotaventas_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
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
          await OperationDB.insertCuotaVenta(sale);
        }
      }
    }
    setState(() {
      porcentajeAvance = 10;
    });
    await searchTercero();
  }

  Future getFacturaSincronizacion() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/factura_app_movil"));
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
          await OperationDB.insertFactura(factura);
        }
      }
    }
    setState(() {
      porcentajeAvance = 30;
    });
    await getClasificacionItemSincronizacion();
  }

  Future getClasificacionItemSincronizacion() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/clasificacionItems_all"));
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
            /*  imagen: await convertToBase64(data[i]['imagen'].toString() != null
                ? data[i]['imagen'].toString()
                : '') */
            imagen: data[i]['imagen'].toString() != null
                ? data[i]['imagen'].toString()
                : '',
          );
          await OperationDB.insertClasificacionItem(claitem);
        }
      }
    }
    setState(() {
      porcentajeAvance = 35;
    });
    await getPrecioItemSincronizacion();
  }

  Future getPrecioItemSincronizacion() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/precioitem_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final precioItem = PrecioItems(
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
          await OperationDB.insertPrecioItem(precioItem);
        }
      }
    }

    setState(() {
      porcentajeAvance = 38;
    });
    await getPrecioItemDetSincronizacion();
  }

  Future getPrecioItemDetSincronizacion() async {
    final response =
        await http.get(Uri.parse("${Constant.URL}/precioitemdet_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        await OperationDB.deletePrecioItem();
        for (int i = 0; i < data.length; i++) {
          final precioItemDet = PrecioItemsDet(
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
          await OperationDB.insertPrecioItemDet(precioItemDet);
        }
      }
    }
    setState(() {
      porcentajeAvance = 42;
    });
    await getItemSincronizacion();
  }

  Future getItemSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/item_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        await OperationDB.deleteItem();
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
          await OperationDB.inserItem(item);
        }
      }
    }
    setState(() {
      porcentajeAvance = 50;
    });
    await getKitSincronizacion();
  }

  Future getKitSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/kit_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final kit = Kit(
              id_kit: data[i]['id_kit'].toString(),
              descripcion: data[i]['descripcion'].toString(),
              precio_kit: data[i]['precio_kit'].toString(),
              precio_kit_iva: data[i]['precio_kit_iva'].toString(),
              flag_vigencia: data[i]['flag_vigencia'].toString(),
              fecha_inicial: data[i]['fecha_inicial'].toString(),
              fecha_final: data[i]['fecha_final'].toString(),
              ultima_actualizacion: data[i]['ultima_actualizacion'].toString(),
              nit: data[i]['nit']);
          await OperationDB.insertKit(kit);
        }
      }
    }
    setState(() {
      porcentajeAvance = 54;
    });
    await getKitDetSincronizacion();
  }

  Future getKitDetSincronizacion() async {
    final response = await http.get(Uri.parse("${Constant.URL}/kit_det_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if (data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          final kitdet = KitDet(
              id_kit: data[i]['id_kit'].toString(),
              id_item: data[i]['id_item'].toString(),
              id_bodega: data[i]['id_bodega'].toString(),
              cantidad: data[i]['cantidad'].toString(),
              tasa_dcto: data[i]['tasa_dcto'].toString(),
              precio: data[i]['precio'].toString(),
              valor_total: data[i]['valor_total'].toString(),
              tasa_iva: data[i]['tasa_iva'].toString(),
              valor_iva: data[i]['valor_iva'].toString(),
              total: data[i]['total'].toString(),
              ultima_actualizacion: data[i]['ultima_actualizacion'].toString(),
              nit: data[i]['nit']);
          await OperationDB.insertKitDet(kitdet);
        }
      }
    }
    setState(() {
      porcentajeAvance = 58;
    });

    await getPedido();
  }

  //visual
  @override
  Widget build(BuildContext context) {
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
              action ? startSin() : Navigator.pushNamed(context, 'home');
            },
          ),
        ));
  }

  void startSin() async {
    print("empiza a recibir");
    final val = await validateConexion.checkInternetConnection();
    setState(() {
      _isConnected = val!;
    });
    if (!_isConnected) {
      _showMSG('Sin conexión a internet');
      return;
    }
    _submitDialog(context);
    setState(() {
      startSincro = true;
    });
    await SendataSincronizacion.initSincronizacion();
    await getCuotaVentaSincronizacion();
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
                      'Última sincronización  $date',
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
              startSincro
                  ? showPrimaryButton('En progreso $porcentajeAvance %', true)
                  : showPrimaryButton('Sincronizar', true),
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
