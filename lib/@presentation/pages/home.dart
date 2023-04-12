import 'package:pony_order/@presentation/components/btnForm.dart';
import 'package:pony_order/@presentation/components/btnSmall.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io' as Io;

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../db/operationDB.dart';
import '../../httpConexion/validateConexion.dart';
import '../../Common/Letras.dart';
import '../../Common/Constant.dart';
import '../../models/cliente.dart';
import '../../models/pedido.dart';
import '../../models/recibo_caja.dart';

import './sendData.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isConnected = false;
  bool _clientShow = false;
  bool _clientShowNoFound = false;
  bool _productosShow = false;
  bool _productosShowCat = false;
  bool _formShow = false;
  bool _formOrderShow = false;
  bool _formRecipeShow = false;
  bool _formHistoryShow = false;
  bool _formNewClientShow = false;
  bool _formNewClientShowDescuento = false;
  bool _checkedCartera = false;
  bool _checkedPedido = false;
  bool _checkedRecibo = false;
  bool _noDatos = true;
  late int _checked = 0;
  bool isCheckedDV = false;

  bool isValidEmail = true;

  //data
  bool focus = false;
  late String _search = '@';
  late int _count = 0;
  late String id_tercero = ''; //la cliente del dataClient para hacer el pedido
  late String id_vendedor = '';
  late String nombre_tercero = '';
  late String direccion_tercero = '';
  late String tlf_tercero = '';
  late String id_tipo_pago = '';
  late String forma_pago_tercero = '';
  late String id_empresa = '';
  late String id_suc_vendedor = '';
  late String id_sucursal_tercero = '';
  late String limite_credito = '0';
  //usuario login
  String _user = '';
  String _nit = '';
  String idPedidoUser = '';
  String idReciboUser = '';
  int _cantidadProducto = 1;
  String fecha_pedido = '';
  late String orden_compra = '';
  late String id_direccion = '';
  late String id_direccion_factura = '';
  //nuevo cliente

  bool isBanco = false;
  bool isCheque = false;
  String _value_itemsTypeDoc = '';
  String _value_itemsDepartamento = '';
  String _value_itemsClasification = '';
  String _value_itemsMedioContacto = '';
  String _value_itemsZona = '';
  String _value_itemsCiudad = '';
  String _value_itemsBarrio = '';
  late Object _body;
  List<dynamic> _datClient = [];
  List<dynamic> _datFactura = [];

  final myControllerNroDoc = TextEditingController();
  final myControllerDv = TextEditingController();
  final myControllerPrimerNombre = TextEditingController();
  final myControllerSegundoNombre = TextEditingController();
  final myControllerPrimerApellido = TextEditingController();
  final myControllerSegundoApellido = TextEditingController();
  final myControllerRazonSocial = TextEditingController();
  final myControllerDireccion = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerTelefono = TextEditingController();
  final myControllerTelefonoCelular = TextEditingController();
  final myControllerCantidadCart = TextEditingController();

//nuevo cliente

//nuevo pedido

  String _value_itemsFormaPago = '';
  late String _value_automatico = '';
  String _value_DireccionFactura = '0';
  String _value_DireccionMercancia = '0';

  late String forma_pago_pedido = '';
  List<dynamic> _datClasificacionProductos = [];
  late int _countClasificacion;

  late int _countClasificacionNivel = 0;
  List<dynamic> _datClasificacionProductosNivel = [];
  late String idClasificacion = '01';
  late String _id_padre = '';
  late String totalPedido = '0.00';
  late String totalSubTotal = '0.00';
  late String totalDescuento = '0.00';
  late String _saldoCartera = '0.00';

  //pantalla 2 de seleccion de productos para pedidos

  late int _countProductos = 0;
  List<dynamic> _datProductos = [];
  List<Map<String, dynamic>> _cartProductos = [];

  //variables de pedidos
  bool selectItem = false;
  final myControllerNroPedido = TextEditingController();
  final myControllerDescuentos = TextEditingController(text: "0");
  final myControllerObservacion = TextEditingController();
  final myControllerCantidad = TextEditingController(text: "1");
  final myControllerOrdenCompra = TextEditingController();
  final myControllerBuscarProd = TextEditingController();
  final myControllerBuscarCatego = TextEditingController();

  late String _value_itemsListPrecio = '0';
  late String _itemSelect = '';
  late double _precio = 0;
  late double _descuento = 0;
  late double limiteCreditoTercero = 0;
  late String listaPrecioTercero = '';

  //nuevo recibo de caja
  final myControllerNroRecibo = TextEditingController();
  final myControllerNroCheque = TextEditingController();
  String _value_itemsBanco = '';
  String _value_itemsTipoPago = '';

  //nuevo pedido
  get callback => false;

  @override
  void initState() {
    super.initState();
    _loadDataUserLogin();
  }

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

  String expresionRegular(double numero) {
    NumberFormat f = new NumberFormat("###,###,###.00#", "es_US");
    String result = f.format(numero);
    return result;
  }
 

  _loadDataUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('user') ?? '');
      _nit = (prefs.getString('nit') ?? '');
      idPedidoUser = (prefs.getString('idPedidoUser') ?? '');
      idReciboUser = (prefs.getString('idReciboUser') ?? '');
    });
    if (_nit != '') {
      if (id_vendedor == '') {
        searchVendedor(_nit.trim(), _user.trim());
      }
    }
  }

  String id_sucursal_tercero_cliente = '';
  String id_forma_pago_cliente = '';
  String id_precio_item_cliente = '';
  String id_lista_precio_cliente = '';
  String id_suc_vendedor_cliente = '';

  Future<void> searchVendedor(_nit, user) async {
    final vendedor = await OperationDB.getVendedor(_nit, _user);
    if (vendedor != false) {
      setState(() {
        id_vendedor = vendedor[0]['id_tercero'];
        id_sucursal_tercero_cliente =
            vendedor[0]['id_sucursal_tercero'].toString();
        id_forma_pago_cliente = vendedor[0]['id_forma_pago'];
        id_precio_item_cliente = vendedor[0]['id_precio_item'];
        id_lista_precio_cliente = vendedor[0]['id_lista_precio'];
        id_suc_vendedor_cliente = vendedor[0]['id_suc_vendedor'].toString();
      });
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        prefs.setString("id_vendedor", id_vendedor);
        prefs.setString("id_sucursal_tercero", id_sucursal_tercero_cliente);
        prefs.setString("id_forma_pago", id_forma_pago_cliente);
        prefs.setString("id_precio_item", id_precio_item_cliente);
        prefs.setString("id_lista_precio", id_lista_precio_cliente);
        prefs.setString("id_suc_vendedor", id_suc_vendedor_cliente);
      });
    }
    if (id_vendedor != '') {
      await searchClient(); //validar esto con pony
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Container(
              height: 250.0,
              width: 300.0,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Column(
                children: [
                  SizedBox(height: 15.0),
                  Text(
                    '¡Atención!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff06538D),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'No se obtuvo información del vendedor. \n Sincronice los datos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff0894FD),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 110,
                    height: 41.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff0894FD)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Center(
                          child: Text(
                            'Entendido',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'data');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
    }
  }

  Future<void> searchDigitoVerif() async {
    final val = await validateConexion.checkInternetConnection();
    setState(() {
      _isConnected = val!;
    });
    if (myControllerNroDoc.text.isNotEmpty &&
        _isConnected &&
        _value_itemsTypeDoc == '31') {
      final numeroId = myControllerNroDoc.text.trim();
      final response =
          await http.get(Uri.parse("${Constant.URL}/cliente_dv/$numeroId"));
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var success = jsonResponse['success'];
      var msg = jsonResponse['msg'];
      if (response.statusCode == 200 && success) {
        var data = jsonResponse['data'];
        setState(() {
          myControllerDv.text = data.toString();
        });
      } else {
        _showBarMsg('$msg', false);
      }
    }
  }

  late List<Map<String, dynamic>> itemsListPrecio = [];
  Future getListPrecio() async {
    final data = await OperationDB.getListPrecio(_nit);
    if (data != false) {
      setState(() {
        itemsListPrecio = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      setState(() {
        itemsListPrecio = [];
      });
      _showBarMsg('No se obtuvo el precio', false);
    }
  }

  late List<Map<String, dynamic>> _itemsTipoPago = [];
  Future getTipoPago() async {
    final data = await OperationDB.getTipoPago(_nit);
    if (data != false) {
      setState(() {
        _itemsTipoPago = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      setState(() {
        _itemsTipoPago = [];
      });
      _showBarMsg('Error', false);
    }
  }

  late List<Map<String, dynamic>> _itemsDepartamento = [];
  Future getItemDepartamento() async {
    final data = await OperationDB.getDeptoList(_nit);
    if (data != false) {
      setState(() {
        _itemsDepartamento = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      _showBarMsg('Error', false);
    }
  }

  late List<Map<String, dynamic>> _itemsBarrio = [];
  Future getItemBarrio(idCiudad) async {
    final data = await OperationDB.getBarrioList(_nit, idCiudad);
    if (data != false) {
      setState(() {
        _itemsBarrio = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      setState(() {
        _itemsBarrio = [];
      });
    }
  }

  late List<Map<String, dynamic>> _itemsClasification = [];
  Future getItemClasificacion() async {
    final data = await OperationDB.getTipoEmpresaList(_nit);
    if (data != false) {
      setState(() {
        _itemsClasification = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      _showBarMsg('Error', false);
    }
  }

  late List<Map<String, dynamic>> _itemsTypeDoc = [];
  Future getItemTypeIdentication() async {
    final data = await OperationDB.getTipoIdentificacionList(_nit);
    if (data != false) {
      setState(() {
        _itemsTypeDoc = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      _showBarMsg('Error', false);
    }
  }

  late List<Map<String, dynamic>> _itemsMedioContacto = [];
  Future getItemMedioContacto() async {
    final data = await OperationDB.getMedioContactoList(_nit);
    if (data != false) {
      setState(() {
        _itemsMedioContacto = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      _showBarMsg('No se obtuvo medio de contacto', false);
    }
  }

  late List<Map<String, dynamic>> _itemsZona = [];
  Future getItemZona() async {
    final data = await OperationDB.getZonaList(_nit);
    if (data != false) {
      setState(() {
        _itemsZona = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      _showBarMsg('No se obtuvo la zona', false);
    }
  }

  late List<Map<String, dynamic>> _itemsCiudad = [];
  Future getItemCiudad(iddepto) async {
    final data = await OperationDB.getCiudadList(_nit, iddepto);
    if (data != false) {
      setState(() {
        _itemsCiudad = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      setState(() {
        _itemsCiudad = [];
      });
      _showBarMsg('No se obtuvo la ciudad', false);
    }
  }

  late List<Map<String, dynamic>> _itemsBanco = [];
  Future getItemBanco() async {
    final data = await OperationDB.getBancoList(_nit);
    if (data != false) {
      setState(() {
        _itemsBanco = (data as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
      });
    } else {
      setState(() {
        _itemsBanco = [];
      });
      _showBarMsg('No se obtuvo el banco', false);
    }
  }

//fin data
  final myControllerSearch = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  Future<void> searchClient() async {
    isCheckedDV = false;
    myControllerNroDoc.clear();
    myControllerDv.clear();
    myControllerPrimerNombre.clear();
    myControllerSegundoNombre.clear();
    myControllerPrimerApellido.clear();
    myControllerSegundoApellido.clear();
    myControllerRazonSocial.clear();
    myControllerDireccion.clear();
    myControllerEmail.clear();
    myControllerTelefono.clear();
    myControllerTelefonoCelular.clear();
    final allClient =
        await OperationDB.getClient(_nit, _search.trim(), id_vendedor);
    if (allClient != false && id_vendedor != '') {
      setState(() {
        _count = allClient.length;
        _datClient = allClient;
        _clientShow = true;
        _clientShowNoFound = false;
        _productosShowCat = false;
        _productosShow = false;
        _formNewClientShowDescuento = false;
        _formNewClientShow = false;
      });
      if (_search == '@') {
        await ObtieneCarrito();
      }
    } else if (allClient == false && id_vendedor != '') {
      _showBarMsg('No existen clientes', false);
      setState(() {
        _clientShow = false;
        _clientShowNoFound = true;
        _productosShowCat = false;
        _productosShow = false;
        _formNewClientShowDescuento = false;
        _formNewClientShow = false;
      });
    } else {
      _clientShow = false;
      _clientShowNoFound = false;
      _showBarMsg(
          'No se obtuvo información del vendedor,sincronice los datos', false);
    }
  }

  List<dynamic> _dataCarteraNew = [];
  Future<void> saldoCartera(bool pedido) async {
    var data =
        await OperationDB.getSaldoCartera(id_tercero, id_sucursal_tercero);
    if (data != false) {
      setState(() {
        _saldoCartera =
            data[0]['DEBITO'] != null ? data[0]['DEBITO'].toString() : '0';
      });

      //documentos de la cartera
      final recibos =
          await OperationDB.getCarteraRecibo(id_tercero, id_sucursal_tercero);
      if (recibos != false) {
        setState(() {
          _dataCarteraNew = recibos;
        });
      } else {
        setState(() {
          _dataCarteraNew = [];
        });
      }

      var data1 = await OperationDB.getFormPago(id_tercero, _nit);
      if (data1 != false) {
        setState(() {
          id_tipo_pago = data1[0]['id_tipo_pago'];
          forma_pago_tercero = data1[0]['descripcion'];
        });
      } else {
        id_tipo_pago = '01';
        forma_pago_tercero = 'EFECTIVO';
      }
      if (_value_automatico != '' && pedido) {
        _direccionClient = [];
        _direccionClienMercancia = [];
        searchClientDireccion();
      }
    } else {
      _showBarMsg('No se obtuvo  el saldo', false);
    }
  }

  Future<void> searchFactura() async {
    final allFactura = await OperationDB.getFacturaId(id_tercero);
    if (allFactura != false) {
      setState(() {
        _datFactura = allFactura;
      });
    }
  }

  Future<void> _saveClient() async {
    final dv = myControllerDv.text != '' ? myControllerDv.text.trim() : "'-'";
    final nuevo_cliente = Cliente(
        id_tercero: myControllerNroDoc.text.trim(),
        id_sucursal_tercero: id_sucursal_tercero_cliente,
        id_tipo_identificacion: _value_itemsTypeDoc,
        dv: dv,
        nombre: isCheckedDV
            ? myControllerPrimerNombre.text.trim() +
                ' ' +
                myControllerSegundoNombre.text.trim() +
                ' ' +
                myControllerPrimerApellido.text.trim() +
                ' ' +
                myControllerSegundoApellido.text.trim()
            : myControllerRazonSocial.text.trim(),
        direccion: myControllerDireccion.text.trim(),
        id_pais: "",
        id_depto: _value_itemsDepartamento.toString(),
        id_ciudad: _value_itemsCiudad.toString(),
        id_barrio: _value_itemsBarrio.toString() != '' ? _value_itemsBarrio.toString() : '0',
        telefono: myControllerTelefono.text.trim() != '' ? myControllerTelefono.text.trim() : "''",
        telefono_celular: myControllerTelefonoCelular.text.trim(),
        id_actividad: _value_itemsClasification,
        fecha_creacion:
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
        nombre_sucursal: !isCheckedDV
            ? myControllerRazonSocial.text.trim()
            : myControllerPrimerNombre.text.trim() +
                ' ' +
                myControllerSegundoNombre.text.trim() +
                ' ' +
                myControllerPrimerApellido.text.trim() +
                ' ' +
                myControllerSegundoApellido.text.trim(),
        primer_apellido:
            isCheckedDV ? myControllerPrimerApellido.text.trim() : '',
        segundo_apellido:
            isCheckedDV ? myControllerSegundoApellido.text.trim() : '',
        primer_nombre: isCheckedDV ? myControllerPrimerNombre.text.trim() : '',
        segundo_nombre:
            isCheckedDV ? myControllerSegundoNombre.text.trim() : '',
        e_mail: myControllerEmail.text.trim(),
        id_forma_pago: id_forma_pago_cliente,
        id_precio_item: id_precio_item_cliente,
        id_lista_precio: id_lista_precio_cliente,
        id_vendedor: id_vendedor,
        id_medio_contacto: _value_itemsMedioContacto,
        id_zona: _value_itemsZona,
        id_suc_vendedor: id_suc_vendedor_cliente,
        nit: _nit,
        id_tipo_empresa: '',
        flag_persona_nat: isCheckedDV ? 'SI' : 'NO',
        usuario: '');
    final insert = await OperationDB.insertCliente(nuevo_cliente);
    if (insert) {
      final val = await validateConexion.checkInternetConnection();
      setState(() {
        _isConnected = val!;
      });
      _showBarMsg('Creación exitosa del cliente', true);
      _isConnected ? await SendataSincronizacion.sendTercero(false) : null;
      Navigator.pushNamed(context, 'home');
    } else {
      _showBarMsg('Error, identificación ya existe', false);
      Navigator.pushNamed(context, 'home');
    }
  }

  Future<void> getConsecutivo(bool pedido) async {
    var idTipoDoc = pedido ? idPedidoUser : idReciboUser;
    final allConse =
        await OperationDB.getConsecutivoTipoDoc(_nit, idTipoDoc, id_empresa);
    if (allConse != false) {
      _value_automatico = allConse[0]['consecutivo'].toString();
      if (_value_automatico != '') {
        await ObtieneCarrito();
        await saldoCartera(pedido);
      } else {
        setState(() {
          _formRecipeShow = true;
        });
      }
    } else {
      _showBarMsg('No se obtuvo consecutivo', false);
    }
  }

  Future<void> ObtieneCarrito() async {
    final data =
        await OperationDB.getCarrito(_nit, id_tercero, _value_automatico);
    if (data != false) {
      _cartProductos =
          (data as List).map((dynamic e) => e as Map<String, dynamic>).toList();

      if (_value_automatico == '' && id_tercero == '' && id_empresa == '') {
        nombre_tercero = _cartProductos[0]['nombre_sucursal'];
        _value_automatico = _cartProductos[0]['numero'].toString();
        id_empresa = _cartProductos[0]['id_empresa'];
        id_tercero = _cartProductos[0]['id_tercero'];
        orden_compra = _cartProductos[0]['orden_compra'];
        idPedidoUser = _cartProductos[0]['id_tipo_doc'];
        fecha_pedido = _cartProductos[0]['fecha'];
        _value_itemsFormaPago = _cartProductos[0]['id_forma_pago'];
        listaPrecioTercero = _cartProductos[0]['id_precio_item'];
        id_direccion = _cartProductos[0]['id_direccion'];
        id_direccion_factura = _cartProductos[0]['id_direccion_factura'];
      }
    }
    setState(() {
      totalPedido = valorTotal();
    });
  }

  late List<Map<String, dynamic>> _direccionClient = [];
  late List<Map<String, dynamic>> _direccionClienMercancia = [];
  Future<void> searchClientDireccion() async {
    final allDireccionMercancia =
        await OperationDB.getDireccion(_nit, id_tercero, 'Mercancia');
    if (allDireccionMercancia != false) {
      _direccionClienMercancia = (allDireccionMercancia as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
    } else {
      _showBarMsg('El cliente no registra dirección', false);
    }

    final allDireccion =
        await OperationDB.getDireccion(_nit, id_tercero, 'Factura');
    if (allDireccion != false && allDireccionMercancia != false) {
      setState(() {
        _direccionClient = (allDireccion as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();

        _clientShow = false;
        _clientShowNoFound = false;
        _formOrderShow = true;
        _productosShow = false;
        searchFactura(); //busca las facturas
      });
    } else {
      _showBarMsg('El cliente no registra dirección', false);
    }
  }

  Future<void> searchClasificacionProductos() async {
    _search = myControllerBuscarCatego.text.isNotEmpty
        ? myControllerBuscarCatego.text.trim()
        : '@';

    var data = await OperationDB.getClasificacionProductos(
        _nit, '1', '', true, _search);
    if (data != false) {
      _datClasificacionProductos = data;
      _countClasificacion = data.length;
      setState(() {
        if (_countClasificacion > 0) {
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
          _formOrderShow = false;
          _productosShow = true;
          _productosShow
              ? _productos(context, _datClasificacionProductos)
              : Container();
          getListPrecio();
        }
      });
    } else {
      _showBarMsg('ERROR SCP', false);
    }
  }

  Future<void> selectProducto() async {
    String _search = '@';
    var data = await OperationDB.getClasificacionProductos(
        _nit, '1', '', true, _search);
    if (data != false) {
      _datClasificacionProductos = data;
      _countClasificacion = data.length;
      setState(() {
        if (_countClasificacion > 0) {
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
          if (_search == '@') {
            _formOrderShow = false;
            _productosShow = true;
          }
          _productosShow
              ? _productos(context, _datClasificacionProductos)
              : Container();
        }
      });
    } else {
      _showBarMsg('ERROR SP1', false);
    }
  }

  Future<void> selectProductoNivel() async {
    var data = await OperationDB.getClasificacionProductos(
        _nit, '2', _id_padre, true, '@');
    if (data != false) {
      _datClasificacionProductosNivel = data;
      _countClasificacionNivel = data.length;
      setState(() {
        idClasificacion = '${_datClasificacionProductosNivel[0]['id_padre']}';
        searchProductosPedido();
      });
    } else {
      _showBarMsg('ERROR SPN2', false);
    }
  }

  Future<void> searchProductosPedido() async {
    final _search = myControllerBuscarProd.text.isNotEmpty
        ? myControllerBuscarProd.text.trim()
        : '@';

    var data = await OperationDB.getItems(
        _nit, idClasificacion, _search, listaPrecioTercero);
    if (data != false) {
      setState(() {
        _datProductos = data;
        _countProductos = data.length;
        _productosShow = false;
        _productosShowCat = true;
      });
    } else {
      setState(() {
        _datProductos = [];
        _countProductos = 0;
      });
      _showBarMsg('No tiene productos', false);
    }
  }

  void searchPrecioProductos(String idItem) async {
    var data = await OperationDB.getPrecioProducto(
        _nit, idItem, _value_itemsListPrecio);
    if (data != false) {
      setState(() {
        _precio = double.parse(data[0]['precio']);
        _descuento = data[0]['descuento_maximo'] != null
            ? double.parse(data[0]['descuento_maximo'])
            : 0;
      });
    } else {
      setState(() {
        _precio = 0;
        _descuento = 0;
      });
      _showBarMsg('No se obtuvo el precio de este producto', false);
    }
  }

  // Perform login
  void validateAndSubmit() {
    _search = myControllerSearch.text.trim();
    setState(() {
      searchClient();
    });
  }

  List<dynamic> _datPedido = [];
  List<dynamic> _datDetallePedido = [];
  //historial de pedido del cliente
  Future<void> getHistorialPedidosClienteDetalle() async {
    final data =
        await OperationDB.getHistorialPedidosClienteBasico(id_tercero, _nit);
    if (data != false) {
      final dataD = await OperationDB.getHistorialPedidosClienteDetalle(
          id_tercero, _nit, data[0]['numero']);
      if (dataD != false) {
        setState(() {
          _datPedido = data;
          _datDetallePedido = dataD;
          _checkedCartera = false;
          _checkedPedido = true;
          _checkedRecibo = false;
          _noDatos = false;
        });
      }
    } else {
      _checkedPedido = true;
      _checkedCartera = false;
      _checkedRecibo = false;
      _noDatos = true;
      _showBarMsg('No tiene pedidos este cliente', false);
    }
  }

  List<dynamic> _datRecibo = [];
  List<dynamic> _datDetalleRecibo = [];
  //historial de recibo del cliente
  Future<void> getHistorialReciboClienteDetalle() async {
    final data =
        await OperationDB.getHistorialReciboClienteBasico(id_tercero, _nit);
    if (data != false) {
      final dataD = await OperationDB.getHistorialReciboClienteDetalle(
          id_tercero, _nit, data[0]['numero']);
      if (dataD != false) {
        setState(() {
          _datRecibo = data;
          _datDetalleRecibo = dataD;
          _checkedCartera = false;
          _checkedPedido = false;
          _checkedRecibo = true;
        });
      }
    } else {
      _checkedRecibo = true;
      _checkedCartera = false;
      _checkedPedido = false;
      _noDatos = true;
      _showBarMsg('No tiene recibos este cliente', false);
    }
  }

  List<dynamic> _datCartera = [];
  //historial de cartera del cliente
  Future<void> getHistorialCarteraClienteBasico() async {
    final data =
        await OperationDB.getHistorialCarteraClienteBasico(id_tercero, _nit);
    if (data != false) {
      setState(() {
        _datCartera = data;
        _checkedCartera = true;
        _checkedPedido = false;
        _checkedRecibo = false;
        _noDatos = false;
      });
    } else {
      _checkedCartera = true;
      _checkedPedido = false;
      _checkedRecibo = false;
      _noDatos = true;
      _showBarMsg('No tiene cartera este cliente', false);
    }
  }

//fin api///////////////////////

//visual

  late DateTime _selectedDate = DateTime.now();
  //Method for showing the date picker
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2030)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        _selectedDate = pickedDate;
      });
    });
  }

  void validateEmail() {
    String email = myControllerEmail.text.trim();
    isValidEmail = EmailValidator.validate(email);
  }

  bool validateFormulario() {
    bool result = false;
    result = _value_itemsTypeDoc != '' ? true : false;

    if (result) {
      result = myControllerNroDoc.text.trim() != '' ? true : false;
    }

    if (result && isCheckedDV) {
      result = myControllerPrimerNombre.text.trim() != '' ? true : false;
    }

    if (result && isCheckedDV) {
      result = myControllerPrimerApellido.text.trim() != '' ? true : false;
    }

    if (result && !isCheckedDV) {
      result = myControllerRazonSocial.text.trim() != '' ? true : false;
    }

    if (result) {
      result = myControllerDireccion.text.trim() != '' ? true : false;
    }
 
    if (result) {
      result = myControllerTelefonoCelular.text.trim() != '' ? true : false;
    }

    if (result && !isValidEmail) {
      result = false;
    }

    if (result) {
      result = _value_itemsClasification.trim() != '' ? true : false;
    }

    if (result) {
      result = _value_itemsMedioContacto.trim() != '' ? true : false;
    }

    if (result) {
      result = _value_itemsZona.trim() != '' ? true : false;
    }

    if (result) {
      result = _value_itemsDepartamento.trim() != '' ? true : false;
    }

    if (result) {
      result = _value_itemsCiudad.trim() != '' ? true : false;
    }

    return result;
  }
 
  Future<bool> _onWillPop() async {
    if (_drawerscaffoldkey.currentState!.isDrawerOpen && _nit != '') {
      Navigator.pop(context);
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          leadingWidth: 40.0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () => {
                  _drawerscaffoldkey.currentState!.isDrawerOpen
                      ? Navigator.pop(context)
                      : _drawerscaffoldkey.currentState!.openDrawer()
                },
                child: Icon(
                  Icons.menu,
                  color: Color(0xff0090ce),
                  size: 30,
                ),
              ),
            ),
          ),
          actions: [
            _getCarritoLleno(),
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xff0090ce),
                    size: 30,
                  ),
                ),
                onTap: () => {
                      _drawerscaffoldkey.currentState!.isEndDrawerOpen
                          ? Navigator.pop(context)
                          : _drawerscaffoldkey.currentState!.openEndDrawer()
                    }),
          ],
          title: Text(
            'Clientes',
            style: TextStyle(
                color: Color(0xff0f538d),
                fontSize: 24.0,
                fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
              child: Container(
                height: 2.0,
                color: Color(0xff0090ce),
              ),
              preferredSize: Size(0.0, 0.0)),
        ),
        body: Scaffold(
          key: _drawerscaffoldkey,
          drawer: _menu(context),
          endDrawer:
              _shoppingCart(context, _cartProductos, _cartProductos.length),
          body: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        children: [
                          _formShow ||
                                  _formOrderShow ||
                                  _formRecipeShow ||
                                  _formHistoryShow ||
                                  _formNewClientShow ||
                                  _formNewClientShowDescuento
                              ? Container()
                              : !_productosShow && !_productosShowCat
                                  ? TextField(
                                      controller: myControllerSearch,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (String str) {
                                        setState(() {
                                          validateAndSubmit();
                                        });
                                      },
                                      onChanged: (text) {
                                        if (text.isEmpty) {
                                          validateAndSubmit();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: !_productosShow
                                            ? 'Buscar cliente (identificación ó nombre)'
                                            : 'Buscar Categoria',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: EdgeInsets.only(
                                            top: 20, bottom: 0, left: 15.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                            color: Color(0xff0f538d),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          borderSide: BorderSide(
                                              color: Color(0xffc7c7c7),
                                              width: 1.2),
                                        ),
                                        suffixIcon: GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 17.0, right: 12.0),
                                            child: Icon(
                                              Icons.search,
                                              color: focus
                                                  ? Color(0xff0f538d)
                                                  : Color(0xffc7c7c7),
                                            ),
                                          ),
                                          onTap: validateAndSubmit,
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xffc7c7c7)),
                                        labelStyle: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            color: Colors.black),
                                        alignLabelWithHint: true,
                                      ),
                                    )
                                  : SizedBox(height: 10.0),
                          SizedBox(height: 10.0),
                          _clientShow && !_clientShowNoFound
                              ? _client(context, _datClient)
                              : Container(),
                          _clientShowNoFound && !_clientShow
                              ? _clientNotFound(context)
                              : Container(),
                          _productosShow
                              ? _productos(context, _datClasificacionProductos)
                              : Container(),
                          _formShow ? _form(context) : Container(),
                          _formOrderShow
                              ? _formOrder(context, null)
                              : Container(),
                          _formRecipeShow ? _formRecipe(context) : Container(),
                          _formHistoryShow
                              ? _formHistory(context)
                              : Container(),
                          _formNewClientShow
                              ? _formNewClient(context)
                              : Container(),
                          _formNewClientShowDescuento
                              ? _formNewClientDescuento(context)
                              : Container(),
                          _productosShowCat
                              ? _shoppingCat(context, idClasificacion)
                              : Container(),
                          _formOrderShow
                              ? _formOrderButton(context)
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget _getCarritoLleno() {
    if (_cartProductos.length > 0) {
      return Container(
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffCB1B1B),
          border: Border.all(
            color: Color(0xffCB1B1B),
            width: 10,
          ),
        ),
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: Text(
          _cartProductos.length.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void callbackHistory(data) {
    //historial
    setState(() {
      id_tercero = '${data['id_tercero']}';
      nombre_tercero = '${data['nombre_sucursal']}  ';
      direccion_tercero = '${data['direccion']}';
      tlf_tercero = data['telefono_celular'] != null
          ? data['telefono_celular']
          : data['telefono'];
      id_empresa = '${data['id_empresa']}';
      id_sucursal_tercero = '${data['id_sucursal_tercero']}';
      limite_credito = '${data['limite_credito']}';
      _formHistoryShow = true;
      _clientShow = false;
      _clientShowNoFound = false;
      _productosShow = false;
    });
    getHistorialCarteraClienteBasico();
  }

  void callbackRecipe(data) {
    //recibo
    setState(() {
      id_tercero = '${data['id_tercero']}';
      nombre_tercero =
          '${data['nombre_completo'].toString()}  ${data['nombre_sucursal'].toString()} ';
      id_empresa = '${data['id_empresa']}';
      id_suc_vendedor = '${data['id_suc_vendedor']}';
      id_sucursal_tercero = '${data['id_sucursal_tercero']}';
      limite_credito = '${data['limite_credito']}';
    });
  }

  Widget _client(BuildContext context, data) {
    double height = MediaQuery.of(context).size.height;
    //listado de clientes en el home
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText('Se encontraron $_count resultados',
            maxLines: 1,
            style: TextStyle(
                color: Color(0xff0f538d),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic)),
        SizedBox(height: 10.0),
        SizedBox(
          height: height - 270.0,
          child: ListView.builder(
            itemCount: _count,
            itemBuilder: (context, i) => _ItemClient('$_count', _datClient[i]),
          ),
        ),
        SizedBox(height: 10.0),
        BtnForm(
            text: 'Crear cliente',
            color: Color(0xff0894FD),
            callback: () => {
                  setState(() {
                    getItemTypeIdentication();
                    getItemDepartamento();
                    getItemClasificacion();
                    getItemMedioContacto();
                    getItemZona();
                    _clientShow = false;
                    _clientShowNoFound = false;
                    _formShow = true;
                  })
                }),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _clientNotFound(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Se encontraron $_count resultados',
            style: TextStyle(
                color: Color(0xff0f538d),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic)),
        SizedBox(height: 200.0),
        BtnForm(
            text: 'Crear cliente',
            color: Color(0xff0894FD),
            callback: () => {
                  setState(() {
                    getItemTypeIdentication();
                    getItemDepartamento();
                    getItemClasificacion();
                    getItemMedioContacto();
                    getItemZona();
                    _clientShow = false;
                    _clientShowNoFound = false;
                    _formShow = true;
                  })
                }),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget InputCallback(
      BuildContext context, hintText, iconCallback, callback, controller) {
    final _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Focus(
        onFocusChange: (e) {
          setState(() {
            focus = e;
          });
        },
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.done,
          onChanged: (text) {
            if (text.isEmpty) {
              callback();
            }
          },
          onSubmitted: (String str) {
            setState(() {
              if (controller.text.isNotEmpty) {
                callback();
              }
            });
          },
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.only(top: 20, bottom: 0, left: 15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Color(0xff0f538d),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Color(0xffc7c7c7), width: 1.2),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                if (controller.text.isNotEmpty) {
                  callback();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 17.0, right: 12.0),
                child: Icon(
                  iconCallback,
                  color: focus ? Color(0xff0f538d) : Color(0xffc7c7c7),
                ),
              ),
            ),
            hintStyle: TextStyle(fontSize: 16.0, color: Color(0xffc7c7c7)),
            labelStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
            alignLabelWithHint: true,
          ),
        ),
      ),
    );
  }

  Widget _productos(BuildContext context, data) {
    //listado de clientes en el home
    final nombre = nombre_tercero.toUpperCase();
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nuevo Pedido',
          style: TextStyle(
              color: Color(0xff0f538d),
              fontSize: 24.0,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 15.0,
        ),
        AutoSizeText(
          '$nombre',
          maxLines: 1,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff0894FD)),
        ),
        SizedBox(
          height: 10.0,
        ),
        InputCallback(context, 'Buscar Categoria', Icons.search,
            searchClasificacionProductos, myControllerBuscarCatego),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: _size.height - 400,
          child: ListView(
            children: [
              _ItemProductos(data),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          width: _size.width,
          height: 40.0,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
              color: Color(0xffE8E8E8),
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Total',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff06538D))),
              Text(
                '\$ ' + expresionRegular(double.parse(totalPedido.toString())),
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff06538D)),
              )
            ],
          ),
        ),
        SizedBox(height: 15.0),
        Row(
          children: [
            Container(
                width: _size.width * 0.5 - 30,
                child: Container(
                  width: _size.width,
                  height: 41.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xffCB1B1B)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _productosShow = false;
                          _productosShowCat = false;
                          _formOrderShow = true;
                        });
                      },
                    ),
                  ),
                )),
            SizedBox(width: 10.0),
            Container(
                width: _size.width * 0.5 - 30,
                child: Container(
                  width: _size.width,
                  height: 41.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: (_cartProductos.length > 0 &&
                              double.parse(totalPedido) > 0)
                          ? Color(0xff0894FD)
                          : Color.fromARGB(255, 146, 144, 144)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        (_cartProductos.length > 0 &&
                                double.parse(totalPedido) > 0)
                            ? createPedido()
                            : modalSinPedido();
                      },
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }

  Widget _shoppingCart(BuildContext context, data, index) {
    final _size = MediaQuery.of(context).size;
    final nombre = nombre_tercero.toUpperCase();
    return SafeArea(
      child: Container(
        width: _size.width,
        height: _size.height - 90,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView(children: [
          _cartProductos.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Carrito de compras',
                          style: TextStyle(
                              color: Color(0xff0f538d),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.disabled_by_default_outlined,
                            color: Color(0xff0f538d),
                            size: 30.0,
                          ),
                          onTap: () {
                            myControllerBuscarProd.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    AutoSizeText(
                        maxLines: 1,
                        '$nombre',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      height: 12.0,
                    ),
                    AutoSizeText(
                      maxLines: 1,
                      'Búsqueda de productos en el carrito',
                      style: TextStyle(
                          color: Color(0xff0f538d),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InputCallback(context, 'Buscar producto', Icons.search,
                        callback, myControllerBuscarProd),
                    SizedBox(height: 15.0),
                    Container(
                      width: 185.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                          color: Color(0xff06538D),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Material(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff06538D),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5.0),
                          onTap: () => {
                            setState(() {
                              Navigator.pop(context);
                              _productosShowCat = false;
                              _clientShow = false;
                              _clientShowNoFound = false;
                              _formShow = false;
                              searchClasificacionProductos();
                            }),
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5.0),
                                AutoSizeText(
                                  maxLines: 1,
                                  minFontSize: 10,
                                  'Categorias',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: _size.height - 560,
                      child: ListView.builder(
                          itemCount: _cartProductos.length,
                          itemBuilder: (context, i) =>
                              _ItemCategoryOrderCart(_cartProductos[i], i)),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                        controller: myControllerObservacion,
                        decoration: InputDecoration(
                          disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0.8, color: Color(0xff707070))),
                          labelText: 'Observaciones',
                          hintText: 'Ingrese observacion',
                        )),
                    SizedBox(height: 30.0),
                    Container(
                      width: _size.width,
                      height: 40.0,
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Total',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff06538D))),
                          Text(
                            '\$ ' +
                                expresionRegular(
                                    double.parse(totalPedido.toString())),
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff06538D)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Container(
                            width: _size.width * 0.5 - 30,
                            child: Container(
                              width: _size.width,
                              height: 41.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Color(0xffCB1B1B)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Center(
                                    child: Text(
                                      'Vaciar carrito',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  onTap: () => {
                                    setState(() {
                                      removeCarrito();
                                    }),
                                  },
                                ),
                              ),
                            )),
                        SizedBox(width: 10.0),
                        Container(
                            width: _size.width * 0.5 - 30,
                            child: Container(
                              width: _size.width,
                              height: 41.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: (_cartProductos.length > 0 &&
                                          double.parse(totalPedido) > 0)
                                      ? Color(0xff0894FD)
                                      : Color.fromARGB(255, 146, 144, 144)),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Center(
                                    child: Text(
                                      'Guardar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  onTap: () {
                                    (_cartProductos.length > 0 &&
                                            double.parse(totalPedido) > 0)
                                        ? createPedido()
                                        : modalSinPedido();
                                  },
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Carrito de compras',
                          style: TextStyle(
                              color: Color(0xff0f538d),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.disabled_by_default_outlined,
                            color: Color(0xff0f538d),
                            size: 30.0,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 60.0),
                    SizedBox(width: 20.0),
                    SizedBox(
                      height: 400.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Card(
                            elevation: 10,
                            child: new Column(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    SizedBox(width: 50.0),
                                    new Container(
                                      child: Image(
                                        height: 250.0,
                                        width: 250.0,
                                        image: AssetImage(
                                            'assets/images/carrito_vacio.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                new Row(
                                  children: [
                                    SizedBox(width: 88.0),
                                    Container(
                                        width: _size.width * 0.5 - 30,
                                        child: Container(
                                          width: _size.width,
                                          height: 41.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: Color(0xff0894FD)),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              child: Center(
                                                child: Text(
                                                  'Cerrar',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context); 
                                              },
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0),
                  ],
                ),
        ]),
      ),
    );
  }

  Widget _shoppingCat(BuildContext context, id) {
    final _size = MediaQuery.of(context).size;
    final nombre = nombre_tercero.toUpperCase();
    return SafeArea(
      child: Container(
        width: _size.width,
        height: _size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ), 
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nuevo Pedido',
                      style: TextStyle(
                          color: Color(0xff0f538d),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                AutoSizeText('$nombre',
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 12.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                InputCallback(context, 'Buscar producto', Icons.search,
                    searchProductosPedido, myControllerBuscarProd),
                SizedBox(height: 15.0),
                Container(
                  width: 183.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                      color: Color(0xff06538D),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xff06538D),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      onTap: () => {
                        setState(() {
                          myControllerBuscarProd.clear();
                          _productosShowCat = false;
                          _productosShow = true;
                        }),
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            AutoSizeText(
                              maxLines: 1,
                              minFontSize: 10,
                              'Categorias',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                _countClasificacionNivel > 1
                    ? _categoriasProduc(context)
                    : SizedBox(
                        height: 5.0,
                      ),
                SizedBox(
                  height: _size.height - 480,
                  child: ListView(
                    children: [
                      for (var i = 0; i < _countProductos; i++) ...[
                        _ItemCategoryOrderState(i, _datProductos[i]),
                        SizedBox(height: 10.0),
                      ]
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  width: _size.width,
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Total',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff06538D))),
                      Text(
                        '\$ ' +
                            expresionRegular(
                                double.parse(totalPedido.toString())),
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff06538D)),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Container(
                        width: _size.width * 0.5 - 30,
                        child: Container(
                          width: _size.width,
                          height: 41.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Color(0xffCB1B1B)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Center(
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _productosShow = false;
                                  _productosShowCat = false;
                                  _formOrderShow = true;
                                });
                              },
                            ),
                          ),
                        )),
                    SizedBox(width: 10.0),
                    Container(
                        width: _size.width * 0.5 - 30,
                        child: Container(
                          width: _size.width,
                          height: 41.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: (_cartProductos.length > 0 &&
                                      double.parse(totalPedido) > 0)
                                  ? Color(0xff0894FD)
                                  : Color.fromARGB(255, 146, 144, 144)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Center(
                                child: Text(
                                  'Guardar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              onTap: () {
                                (_cartProductos.length > 0 &&
                                        double.parse(totalPedido) > 0)
                                    ? createPedido()
                                    : modalSinPedido();
                              },
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(int index, String idItem, String descripcion, int cantidad) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              actions: <Widget>[
                _ItemCategoryOrderEdit(index, idItem, descripcion, cantidad)
              ],
            ));
  }

  Widget _menu(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff4f4f4),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: const ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.money,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Transacciones',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                color: Color(0xff0091CE),
                child: ListTile(
                  minLeadingWidth: 20,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consultas',
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 1.0),
                          color: Colors.white,
                          height: 1.0,
                          width: _size.width * 0.45)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.document_scanner,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Pedidos',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'order'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.text_snippet_rounded,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Recibos de caja',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'receipts'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.paid,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Cuota de venta',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'sale'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.shopping_bag_rounded,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Unidades',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'units'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.remove_red_eye,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Visitados',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'visiteds'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: ListTile(
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.backup,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Sincronización',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'data'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: ListTile(
                  onTap: () async {
                    OperationDB.closeDB();
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.clear();
                    preferences.setInt("value", 0);
                    Navigator.pushNamed(context, 'login');
                  },
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Cerrar sesión',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formHistory(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            maxLines: 1,
            'Visualice el historial del cliente',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff06538D)),
          ),
          SizedBox(
            height: 15.0,
          ),
          AutoSizeText(
            maxLines: 1,
            '$nombre_tercero',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff0894FD)),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            decoration: BoxDecoration(
                color: Color(0xffE8E8E8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Color(0xffC7C7C7), width: 1.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.assignment_ind_rounded,
                              color: Color(0xff707070), size: 20.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Identificación',
                                style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('$id_tercero',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Color(0xff707070), size: 20.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Dirección',
                                style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('$direccion_tercero',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.phone,
                              color: Color(0xff707070), size: 20.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Teléfono',
                                style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('$tlf_tercero',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            width: _size.width,
            height: 40.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _btnHistory(context, 'Cartera',
                    _checkedCartera ? Color(0xff06538D) : Color(0xff0894FD),
                    () {
                  setState(() {
                    getHistorialCarteraClienteBasico();
                  });
                }),
                SizedBox(
                  width: 8.0,
                ),
                _btnHistory(context, 'Pedido',
                    _checkedPedido ? Color(0xff06538D) : Color(0xff0894FD), () {
                  setState(() {
                    getHistorialPedidosClienteDetalle();
                  });
                }),
                SizedBox(
                  width: 8.0,
                ),
                _btnHistory(context, 'Recibo',
                    _checkedRecibo ? Color(0xff06538D) : Color(0xff0894FD), () {
                  setState(() {
                    getHistorialReciboClienteDetalle();
                  });
                }),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _noDatos ? _totalHistorySinDatos(context) : Container(),
          _checkedCartera && !_noDatos
              ? _totalHistoryCartera(context)
              : Container(),
          _checkedPedido && !_noDatos
              ? _totalHistoryPedido(context)
              : Container(),
          _checkedRecibo && !_noDatos
              ? _totalHistoryRecibo(context)
              : Container(),
        ],
      ),
    );
  }

  //No tiene datos el historial

  Widget _totalHistorySinDatos(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            decoration: BoxDecoration(
                color: Color(0xffE8E8E8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Este cliente no tiene datos.',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 21.0,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200.0,
          ),
          Container(
            width: _size.width,
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Color(0xff0894FD)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, 'home');
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalHistoryCartera(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
                color: Color(0xffE8E8E8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total de cartera',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$ ' +
                      expresionRegular(double.parse(_saldoCartera.toString())),
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            width: _size.width,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Color(0xffE8E8E8),
                ),
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datos de Cartera',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('N° Documento',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('${_datCartera[0]['numero']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.credit_card,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Débito',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text(
                          '\$ ' +
                              expresionRegular(double.parse(
                                  _datCartera[0]['debito'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Días',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('${_datCartera[0]['numero']} Días',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 190.0,
          ),
          Container(
            width: _size.width,
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Color(0xff0894FD)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, 'home');
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalHistoryPedido(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final total_item = _datDetallePedido.length;
    return Container(
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
                color: Color(0xffE8E8E8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total de Pedido',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$ ' +
                      expresionRegular(
                          double.parse(_datPedido[0]['total'].toString())),
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            width: _size.width,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Color(0xffE8E8E8),
                ),
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datos de pedido',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.credit_card,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('N° Factura',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('${_datPedido[0]['numero']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Fecha de factura',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('${_datPedido[0]['fecha']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Este pedido $total_item tiene items',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Color(0xff06538D)),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 160.0,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: total_item,
              itemBuilder: (context, i) =>
                  ItemProductOrderHistoryNew(_datDetallePedido[i], i),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: _size.width,
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Color(0xff0894FD)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, 'home');
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget ItemProductOrderHistoryNew(data, i) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                color: Color(0xffF4F4F4)),
            width: _size.width,
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data['descripcion_item']}',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff707070),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Código',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['id_item']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Cantidad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['cantidad']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Precio Unidad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(
                          '\$ ' +
                              expresionRegular(
                                  double.parse(data['precio'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(
                          '\$ ' +
                              expresionRegular(
                                  double.parse(data['total_prod'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 5.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _totalHistoryRecibo(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final total_item = _datDetalleRecibo.length;
    return Container(
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
                color: Color(0xffE8E8E8),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total de recibo',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$ ' +
                      expresionRegular(
                          double.parse(_datRecibo[0]['total'].toString())),
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            width: _size.width,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Color(0xffE8E8E8),
                ),
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datos de Recibo',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.credit_card,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('N° Recibo',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('${_datRecibo[0]['numero']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Fecha de recibo',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('${_datRecibo[0]['fecha']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Color(0xff0894FD), size: 18.0),
                          SizedBox(
                            width: 4.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 57,
                            child: Text('Días',
                                style: TextStyle(
                                    color: Color(0xff0894FD),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: _size.width * 0.5 - 33,
                      child: Text('${_datRecibo[0]['dias']} Días',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Este recibo tiene $total_item items',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Color(0xff06538D)),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            height: 160.0,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                for (var i = 0; i < total_item; i++) ...[
                  if (_datDetalleRecibo.isNotEmpty) ...[
                    ItemProductOrderHistoryReciboNew(_datDetalleRecibo[i], i),
                    SizedBox(height: 10.0),
                  ],
                ],
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: _size.width,
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Color(0xff0894FD)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Aceptar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, 'home');
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget ItemProductOrderHistoryReciboNew(data, i) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Documento - cruce',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['id_tipo_doc_cruce']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Número - Cruce',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['numero_cruce']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Valor',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(
                          '\$' +
                              expresionRegular(
                                  double.parse(data['debito'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _btnHistory(
      BuildContext context, String text, Color color, VoidCallback callback) {
    final _size = MediaQuery.of(context).size;
    return Container(
      height: 50.0,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(6.0), color: color),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6.0),
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          onTap: callback,
        ),
      ),
    );
  }

  Widget _formNewClient(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clientes / Nuevo recibo',
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff06538D)),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$nombre_tercero',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0091CE)),
              ),
              Container(
                  height: 35.0,
                  width: 35.0,
                  decoration: BoxDecoration(
                      color: Color(0xff0091CE),
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Icon(
                    Icons.my_library_books_sharp,
                    size: 20.0,
                    color: Colors.white,
                  ))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: _size.width,
            height: 1.0,
            color: Color(0xff707070),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Documentos pendientes',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Color(0xff06538D)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: _size.width,
                  height: 1.0,
                  color: Color(0xff707070),
                ),
                TextField(
                    controller: myControllerObservacion,
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.8, color: Color(0xff707070))),
                      labelText: 'Observaciones',
                      hintText: 'Ingrese observacion',
                    )),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: _size.height - 520,
                  child: ListView(
                    children: [
                      for (var i = 0; i < _dataDocumentPend.length; i++) ...[
                        _ItemDocumentClient(_dataDocumentPend[i], i),
                        SizedBox(height: 5.0),
                      ]
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  height: 30.0,
                  width: _size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sub Total',
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '\$ ' +
                            expresionRegular(
                                double.parse(totalRecibo.toString())),
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 30.0,
                  width: _size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Descuentos',
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '\$ ' +
                            expresionRegular(
                                double.parse(totalReciboDescuento.toString())),
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 30.0,
                  width: _size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '\$ ' +
                            expresionRegular(
                                double.parse(totalReciboPagado.toString())),
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Container(
                      width: _size.width * 0.5 - 35,
                      child: BtnSmall(
                          text: 'Cancelar',
                          color: Color(0xffCB1B1B),
                          callback: () {
                            setState(() {
                              Navigator.pushNamed(context, 'home');
                            });
                          }),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: _size.width * 0.5 - 35,
                      child: BtnSmall(
                          text: 'Descuentos',
                          color: Color(0xff0894FD),
                          callback: () {
                            setState(() {
                              searchConcepto();
                            });
                          }),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formNewClientDescuento(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clientes / Nuevo recibo',
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff06538D)),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$nombre_tercero',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0091CE)),
              ),
              Container(
                  height: 35.0,
                  width: 35.0,
                  decoration: BoxDecoration(
                      color: Color(0xff0091CE),
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Icon(
                    Icons.my_library_books_sharp,
                    size: 20.0,
                    color: Colors.white,
                  ))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: _size.width,
            height: 1.0,
            color: Color(0xff707070),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Descuentos',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Color(0xff06538D)),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: _size.width,
                  height: 1.0,
                  color: Color(0xff707070),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: _size.height - 480,
                  child: ListView(
                    children: [
                      for (var i = 0; i < _dataDescuento.length; i++) ...[
                        _ItemDescuento(_dataDescuento[i], i),
                        SizedBox(height: 5.0),
                      ]
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  height: 30.0,
                  width: _size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sub Total',
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '\$ ' +
                            expresionRegular(
                                double.parse(totalRecibo.toString())),
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 30.0,
                  width: _size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Descuentos',
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '\$ ' +
                            expresionRegular(
                                double.parse(totalReciboDescuento.toString())),
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 30.0,
                  width: _size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Color(0xffE8E8E8), width: 1.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '\$ ' +
                            expresionRegular(
                                double.parse(totalReciboPagado.toString())),
                        style: TextStyle(
                            color: Color(0xff06538D),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Container(
                      width: _size.width * 0.5 - 35,
                      child: BtnSmall(
                          text: 'Documentos',
                          color: Color(0xffCB1B1B),
                          callback: () {
                            setState(() {
                              _formNewClientShow = true;
                              _formNewClientShowDescuento = false;
                            });
                          }),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: _size.width * 0.5 - 35,
                      child: BtnSmall(
                          text: 'Guardar',
                          color: Color(0xff0894FD),
                          callback: () {
                            createRecibo();
                          }),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 

  Widget _formRecipe(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: _size.height - AppBar().preferredSize.height - 70,
          width: _size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clientes / Nuevo recibo',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff06538D)),
              ),
              SizedBox(height: 20.0),
              _itemForm(context, 'Recibo N°', '$_value_automatico',
                  myControllerNroRecibo, false, 'number', false, callback),
              InkWell(
                onTap: () {
                  _pickDateDialog();
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    enabled: true,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                      Icon(Icons.arrow_drop_down, color: Color(0xff06538D)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              _itemForm(context, 'Nombre', '$nombre_tercero', null, true,
                  'text', false, callback),
              _itemForm(
                  context,
                  'Total cartera',
                  '\$ ' +
                      expresionRegular(double.parse(_saldoCartera.toString())),
                  null,
                  true,
                  'number',
                  false,
                  callback),
              
              SizedBox(height: 10),
              DropdownFormField<Map<String, dynamic>>(
                onEmptyActionPressed: () async {},
                searchTextStyle: TextStyle(
                    color: Color(0xff06538D),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    hintStyle: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700),
                    labelText: "Forma de pago"),
                onSaved: (dynamic str) {
                  _value_itemsTipoPago = str['value'];
                },
                onChanged: (dynamic str) {
                  _value_itemsTipoPago = str['value'];

                  if (_value_itemsTipoPago == '01') {
                    isBanco = false;
                    isCheque = false;
                    myControllerNroCheque.clear();
                  } else if (_value_itemsTipoPago != '01' &&
                      _value_itemsTipoPago != '02') {
                    isBanco = true;
                    isCheque = false;
                    myControllerNroCheque.clear();
                  } else if (_value_itemsTipoPago == '02') {
                    isCheque = true;
                    isBanco = false;
                  }
                },
                validator: (dynamic str) {},
                displayItemFn: (dynamic item) => Text(
                  (item ?? {})['label'] ?? '',
                  style: TextStyle(fontSize: 16),
                ),
                findFn: (dynamic str) async => _itemsTipoPago,
                selectedFn: (dynamic item1, dynamic item2) {
                  if (item1 != null && item2 != null) {
                    return item1['label'] == item2['label'];
                  }
                  return false;
                },
                filterFn: (dynamic item, str) =>
                    item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
                dropdownItemFn: (dynamic item, int position, bool focused,
                        bool selected, Function() onTap) =>
                    ListTile(
                  title: Text(item['label']),
                  tileColor: focused
                      ? Color.fromARGB(20, 0, 0, 0)
                      : Colors.transparent,
                  onTap: onTap,
                ),
              ),
              SizedBox(height: 10),
              DropdownFormField<Map<String, dynamic>>(
                onEmptyActionPressed: () async {},
                searchTextStyle: TextStyle(
                    color: Color(0xff06538D),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    hintStyle: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700),
                    labelText: "Banco"),
                onSaved: (dynamic str) {
                  _value_itemsBanco = str['value'];
                },
                onChanged: (dynamic str) {
                  _value_itemsBanco = str['value'];
                },
                validator: (dynamic str) {},
                displayItemFn: (dynamic item) => Text(
                  (item ?? {})['label'] ?? '',
                  style: TextStyle(fontSize: 16),
                ),
                findFn: (dynamic str) async => _itemsBanco,
                selectedFn: (dynamic item1, dynamic item2) {
                  if (item1 != null && item2 != null) {
                    return item1['label'] == item2['label'];
                  }
                  return false;
                },
                filterFn: (dynamic item, str) =>
                    item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
                dropdownItemFn: (dynamic item, int position, bool focused,
                        bool selected, Function() onTap) =>
                    ListTile(
                  title: Text(item['label']),
                  tileColor: focused
                      ? Color.fromARGB(20, 0, 0, 0)
                      : Colors.transparent,
                  onTap: onTap,
                ),
              ),
 
              _itemForm(context, 'N° cheque', '00000', myControllerNroCheque,
                  false, 'number', isCheque, callback),
              SizedBox(height: 30.0),
              Container(
                  width: _size.width, height: 1.0, color: Color(0xffC7C7C7)),
              SizedBox(height: 30.0),
            ],
          ),
        ),
        Positioned(
          bottom: 10.0,
          child: Row(
            children: [
              Container(
                  width: _size.width * 0.5 - 25,
                  child: Container(
                    width: _size.width,
                    height: 41.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xffCB1B1B)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Center(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.pushNamed(context, 'home');
                          });
                        },
                      ),
                    ),
                  )),
              SizedBox(width: 10.0),
              Container(
                  width: _size.width * 0.5 - 25,
                  child: Container(
                    width: _size.width,
                    height: 41.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff0894FD)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Center(
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            if (_value_itemsTipoPago == '') {
                              _showBarMsg('Indique una forma de pago', false);
                            } else if ((_value_itemsTipoPago == '03' ||
                                    _value_itemsTipoPago == '04') &&
                                _value_itemsBanco == '') {
                              _showBarMsg('Indique un banco', false);
                            } else if (_value_itemsTipoPago == '02' &&
                                myControllerNroCheque.text.trim() == '') {
                              _showBarMsg('Indique el N° Cheque', false);
                            } else {
                              _formRecipeShow = false;
                              _formNewClientShow = true;
                            }
                          });
                        },
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget _formOrderButton(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return SizedBox(
        child: Row(
      children: [
        Container(
            width: _size.width * 0.5 - 25,
            child: Container(
              width: _size.width,
              height: 41.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(0xffCB1B1B)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Center(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _clientShow = false;
                      _formOrderShow = false;
                      _search = '@';
                      searchClient();
                    });
                  },
                ),
              ),
            )),
        SizedBox(width: 10.0),
        Container(
            width: _size.width * 0.5 - 25,
            child: Container(
              width: _size.width,
              height: 41.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(0xff0894FD)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Center(
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _value_DireccionMercancia =
                          _direccionClienMercancia.length == 1
                              ? _direccionClienMercancia[0]['value']
                              : _value_DireccionMercancia;
                      _value_DireccionFactura = _direccionClient.length == 1
                          ? _direccionClient[0]['value']
                          : _value_DireccionFactura;
                    });
                    (_value_DireccionMercancia.toString() != '0' &&
                            _value_DireccionFactura.toString() != '0')
                        ? searchClasificacionProductos()
                        : _showBarMsg('Seleccione las direcciones', false);
                  },
                ),
              ),
            ))
      ],
    ));
  }

  Widget _formOrder(BuildContext context, data_tercero_pedido) {
    //crear nuevo pedido
    final _size = MediaQuery.of(context).size;
    return SizedBox(
      height: _size.height - 190,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Text(
            'Completa los campos para crear un nuevo pedido',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff06538D)),
          ),
          SizedBox(height: 20.0),
          _itemForm(context, 'Pedido', '$_value_automatico',
              myControllerNroPedido, true, 'number', false, callback),
          InkWell(
            onTap: () {
              _pickDateDialog();
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Fecha',
                enabled: true,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  Icon(Icons.arrow_drop_down, color: Color(0xff06538D)),
                ],
              ),
            ),
          ),
          _itemForm(context, 'Nombre', '$nombre_tercero', null, true, 'text',
              false, callback),
          SelectFormField(
            style: TextStyle(
                color: Color(0xff06538D),
                fontSize: 14.0,
                fontWeight: FontWeight.w600),

            type: SelectFormFieldType.dropdown, // or can be dialog
            labelText: 'Dir. envío factura',
            initialValue: _direccionClient.length == 1
                ? _direccionClient[0]['value']
                : null,
            items: _direccionClient,
            onChanged: (val) => setState(() => _value_DireccionFactura = val),
          ),
          SelectFormField(
            style: TextStyle(
                color: Color(0xff06538D),
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
            type: SelectFormFieldType.dropdown, // or can be dialog

            labelText: 'Dir. envío mercancia',
            initialValue: _direccionClienMercancia.length == 1
                ? _direccionClienMercancia[0]['value']
                : null,
            items: _direccionClienMercancia,
            onChanged: (val) => setState(() => _value_DireccionMercancia = val),
          ),
          _itemForm(context, 'Orden de compra', '', myControllerOrdenCompra,
              false, 'text', false, callback),
          _itemForm(context, 'Forma de pago', '$forma_pago_tercero', null, true,
              'text', false, callback),
          SizedBox(height: 30.0),
          Container(width: _size.width, height: 1.0, color: Color(0xffC7C7C7)),
          SizedBox(height: 30.0),
          Text(
            'Crédito',
            style: TextStyle(
                color: Color(0xff0091CE),
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.0),
          _itemForm(
              context,
              'Cupo crédito',
              '\$ ' + expresionRegular(double.parse(limite_credito.toString())),
              null,
              true,
              'number',
              false,
              callback),
          _itemSelectForm(
              context,
              'Total cartera',
              '\$ ' + expresionRegular(double.parse(_saldoCartera.toString())),
              '',
              null),
          SizedBox(height: 20.0),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _datFactura.length > 0
                          ? showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Container(
                                    height: 510.0,
                                    width: 340.4,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 15.0),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: _size.width * 0.5 - 40,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'N° Factura',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff06538D),
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: _size.width * 0.5 - 90,
                                                  child: Text(
                                                    '${_datFactura[0]['numero']}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff707070),
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: _size.width * 0.5 - 40,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Fecha de factura',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff06538D),
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: _size.width * 0.5 - 90,
                                                  child: Text(
                                                    '${_datFactura[0]['fecha']}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff707070),
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20.0),
                                            for (var i = 0;
                                                i < _datFactura.length;
                                                i++) ...[
                                              _ItemProductOrder(
                                                  _datFactura[i], i),
                                            ],
                                            SizedBox(height: 10.0),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: _size.width * 0.5 - 50,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff06538D),
                                                        fontSize: 17.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: _size.width * 0.5 - 110,
                                              child: Text(
                                                '\$ ' +
                                                    expresionRegular(double
                                                        .parse(_datFactura[0]
                                                                ['total_fac']
                                                            .toString())),
                                                style: TextStyle(
                                                    color: Color(0xff06538D),
                                                    fontSize: 17.0,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: _size.width * 0.6,
                                              height: 40.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: Color(0xff0894FD)),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Center(
                                                    child: Text(
                                                      'Aceptar',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          : _showBarMsg(
                              'Este cliente no tiene facturas', false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          maxLines: 1,
                          'Ver la última factura del cliente',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xff0f538d),
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xff06538D),
                          size: 18.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0)
        ],
      ),
    );
  }

  void _seeTotalCartera(context, _size) {
    _dataCarteraNew.length > 0
        ? showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Container(
                  height: 500.0,
                  width: 340.4,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.0),
                          SizedBox(
                            height: _size.height - 520,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: [
                                for (var i = 0;
                                    i < _dataCarteraNew.length;
                                    i++) ...[
                                  _ItemDocumentClientCartera(
                                      _dataCarteraNew[i], i),
                                  SizedBox(height: 5.0),
                                ]
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: _size.width * 0.58,
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Color(0xff0894FD)),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Center(
                                  child: Text(
                                    'Aceptar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          )
        : _showBarMsg('Este cliente no tiene cartera', false);
  }

  Widget _ItemDocumentClientCartera(data, i) {
    final _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
          color: Color(0xffE8E8E8), borderRadius: BorderRadius.circular(6.0)),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  'Tipo:',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  '${data['tipo_doc']}',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  'Número:',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  '${data['numero']}',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  'Saldo:',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  '\$ ' +
                      expresionRegular(double.parse(data['DEBITO'].toString())),
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  'Vencimiento:',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: _size.width * 0.5 - 80,
                child: Text(
                  '${data['vencimiento']}',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    //nuevo cliente
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          'Completa los campos para crear un nuevo cliente',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(height: 20.0),
        
        DropdownFormField<Map<String, dynamic>>(
          onEmptyActionPressed: () async {},
          searchTextStyle: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              labelText: 'Tipo de documento'),
          onSaved: (dynamic str) {
            _value_itemsTypeDoc = str['value'];
          },
          onChanged: (dynamic str) => setState(() => {
                _value_itemsTypeDoc = str['value'],
                if (_value_itemsTypeDoc == '31')
                  {searchDigitoVerif(), isCheckedDV = false}
                else
                  {
                    myControllerDv.clear(),
                    if (_value_itemsTypeDoc == '13')
                      {isCheckedDV = true}
                    else
                      {isCheckedDV = false}
                  }
              }),
          validator: (dynamic str) {},
          displayItemFn: (dynamic item) => Text(
            (item ?? {})['label'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          findFn: (dynamic str) async => _itemsTypeDoc.toList(),
          selectedFn: (dynamic item1, dynamic item2) {
            if (item1 != null && item2 != null) {
              return item1['label'] == item2['label'];
            }
            return false;
          },
          filterFn: (dynamic item, str) =>
              item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
          dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) =>
              ListTile(
            title: Text(item['label']),
            tileColor:
                focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            onTap: onTap,
          ),
        ),
        _itemForm(context, 'N° de documento', '', myControllerNroDoc, false,
            'number', true, searchDigitoVerif),
        CheckboxListTile(
            checkColor: Color(0xff06538D),
            title: Text(
              'Persona Natural',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                  color: Color(0xff06538D)),
            ),
            value: this.isCheckedDV,
            onChanged: (bool? value) {
              setState(() {
                isCheckedDV = !isCheckedDV;
              });
            }),
        _itemForm(
            context, 'DV.', '', myControllerDv, true, 'text', false, callback),
        _itemForm(context, 'Primer nombre', '', myControllerPrimerNombre,
            !isCheckedDV, 'name', isCheckedDV, callback),
        _itemForm(context, 'Segundo nombre', '', myControllerSegundoNombre,
            !isCheckedDV, 'name', false, callback),
        _itemForm(context, 'Primer apellido', '', myControllerPrimerApellido,
            !isCheckedDV, 'name', isCheckedDV, callback),
        _itemForm(context, 'Segundo apellido', '', myControllerSegundoApellido,
            !isCheckedDV, 'name', false, callback),
        _itemForm(context, 'Razón social', '', myControllerRazonSocial,
            isCheckedDV, 'text', !isCheckedDV, callback),
        _itemForm(context, 'Dirección', '', myControllerDireccion, false,
            'text', true, false),
        _itemForm(context, 'Email', '', myControllerEmail, false, 'email', true,
            validateEmail),
        _itemForm(context, 'Teléfono fijo', '', myControllerTelefono, false,
            'phone', false, callback),
        _itemForm(context, 'Teléfono celular', '', myControllerTelefonoCelular,
            false, 'phone', true, callback),
        SizedBox(height: 10),
        DropdownFormField<Map<String, dynamic>>(
          onEmptyActionPressed: () async {},
          searchTextStyle: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              labelText: 'Clasificación'),
          onSaved: (dynamic str) {
            _value_itemsClasification = str['value'];
          },
          onChanged: (dynamic str) {
            _value_itemsClasification = str['value'];
          },
          validator: (dynamic str) {},
          displayItemFn: (dynamic item) => Text(
            (item ?? {})['label'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          findFn: (dynamic str) async => _itemsClasification,
          selectedFn: (dynamic item1, dynamic item2) {
            if (item1 != null && item2 != null) {
              return item1['label'] == item2['label'];
            }
            return false;
          },
          filterFn: (dynamic item, str) =>
              item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
          dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) =>
              ListTile(
            title: Text(item['label']),
            tileColor:
                focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            onTap: onTap,
          ),
        ),
        SizedBox(height: 10),
        DropdownFormField<Map<String, dynamic>>(
          onEmptyActionPressed: () async {},
          searchTextStyle: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              labelText: 'Medio contacto'),
          onSaved: (dynamic str) {
            _value_itemsMedioContacto = str['value'];
          },
          onChanged: (dynamic str) {
            _value_itemsMedioContacto = str['value'];
          },
          validator: (dynamic str) {},
          displayItemFn: (dynamic item) => Text(
            (item ?? {})['label'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          findFn: (dynamic str) async => _itemsMedioContacto,
          selectedFn: (dynamic item1, dynamic item2) {
            if (item1 != null && item2 != null) {
              return item1['label'] == item2['label'];
            }
            return false;
          },
          filterFn: (dynamic item, str) =>
              item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
          dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) =>
              ListTile(
            title: Text(item['label']),
            tileColor:
                focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            onTap: onTap,
          ),
        ),
        SizedBox(height: 10),
        DropdownFormField<Map<String, dynamic>>(
          onEmptyActionPressed: () async {},
          searchTextStyle: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              labelText: 'Zona'),
          onSaved: (dynamic str) {
            _value_itemsZona = str['value'];
          },
          onChanged: (dynamic str) {
            _value_itemsZona = str['value'];
          },
          validator: (dynamic str) {},
          displayItemFn: (dynamic item) => Text(
            (item ?? {})['label'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          findFn: (dynamic str) async => _itemsZona,
          selectedFn: (dynamic item1, dynamic item2) {
            if (item1 != null && item2 != null) {
              return item1['label'] == item2['label'];
            }
            return false;
          },
          filterFn: (dynamic item, str) =>
              item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
          dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) =>
              ListTile(
            title: Text(item['label']),
            tileColor:
                focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            onTap: onTap,
          ),
        ),
        SizedBox(height: 10),
        DropdownFormField<Map<String, dynamic>>(
          onEmptyActionPressed: () async {},
          searchTextStyle: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              labelText: 'Departamento'),
          onSaved: (dynamic str) {
            _value_itemsDepartamento = str['value'];
          },
          onChanged: (dynamic str) {
            _value_itemsDepartamento = str['value'];
            getItemCiudad(_value_itemsDepartamento);
          },
          validator: (dynamic str) {},
          displayItemFn: (dynamic item) => Text(
            (item ?? {})['label'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          findFn: (dynamic str) async => _itemsDepartamento,
          selectedFn: (dynamic item1, dynamic item2) {
            if (item1 != null && item2 != null) {
              return item1['label'] == item2['label'];
            }
            return false;
          },
          filterFn: (dynamic item, str) =>
              item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
          dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) =>
              ListTile(
            title: Text(item['label']),
            tileColor:
                focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            onTap: onTap,
          ),
        ),
        SizedBox(height: 10),
        DropdownFormField<Map<String, dynamic>>(
          onEmptyActionPressed: () async {},
          searchTextStyle: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              labelText: 'Ciudad'),
          onSaved: (dynamic str) {
            _value_itemsCiudad = str['value'];
          },
          onChanged: (dynamic str) {
            _value_itemsCiudad = str['value'];
            getItemBarrio(_value_itemsCiudad);
          },
          validator: (dynamic str) {},
          displayItemFn: (dynamic item) => Text(
            (item ?? {})['label'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          findFn: (dynamic str) async => _itemsCiudad,
          selectedFn: (dynamic item1, dynamic item2) {
            if (item1 != null && item2 != null) {
              return item1['label'] == item2['label'];
            }
            return false;
          },
          filterFn: (dynamic item, str) =>
              item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
          dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) =>
              ListTile(
            title: Text(item['label']),
            tileColor:
                focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            onTap: onTap,
          ),
        ),
        SizedBox(height: 10),
        DropdownFormField<Map<String, dynamic>>(
          onEmptyActionPressed: () async {},
          searchTextStyle: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
              hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              labelText: 'Barrio'),
          onSaved: (dynamic str) {
            _value_itemsBarrio = str['value'];
          },
          onChanged: (dynamic str) {
            _value_itemsBarrio = str['value'];
          },
          validator: (dynamic str) {},
          displayItemFn: (dynamic item) => Text(
            (item ?? {})['label'] ?? '',
            style: TextStyle(fontSize: 16),
          ),
          findFn: (dynamic str) async => _itemsBarrio,
          selectedFn: (dynamic item1, dynamic item2) {
            if (item1 != null && item2 != null) {
              return item1['label'] == item2['label'];
            }
            return false;
          },
          filterFn: (dynamic item, str) =>
              item['label'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
          dropdownItemFn: (dynamic item, int position, bool focused,
                  bool selected, Function() onTap) =>
              ListTile(
            title: Text(item['label']),
            tileColor:
                focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
            onTap: onTap,
          ),
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Container(
                width: _size.width * 0.5 - 25,
                child: Container(
                  width: _size.width,
                  height: 41.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xffCB1B1B)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _clientShow = false;
                          _clientShowNoFound = false;
                          _formShow = false;
                          _formNewClientShow = false;
                          _search = '@';
                          searchClient();
                        });
                      },
                    ),
                  ),
                )),
            SizedBox(width: 10.0),
            Container(
                width: _size.width * 0.5 - 25,
                child: Container(
                  width: _size.width,
                  height: 41.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: validateFormulario()
                          ? Color(0xff0894FD)
                          : Color.fromARGB(255, 146, 144, 144)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (!validateFormulario()) {
                            _showBarMsg(
                                'Debe completar los campos correctamente',
                                false);
                          } else {
                            _saveClient();
                          }
                        });
                      },
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget itemOrder(
    data,
  ) {
    final nombre = data['nombre_sucursal'];
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                color: Colors.blue),
            width: _size.width,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$nombre',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Text(
                        'Ver detalles',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 3.0),
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 15.0,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'N° Pedido',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['numero']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Fecha',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['fecha']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(
                          '\$ ' +
                              expresionRegular(
                                  double.parse(data['total'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 5.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemForm(BuildContext context, String label, String hintText,
      controller, enable, String type, bool isRequired, callback) {
    final _size = MediaQuery.of(context).size;
    var typeInput;
    var format;
    var cant;
    switch (type) {
      case 'number':
        typeInput = TextInputType.number;
        cant = 15;
        format = FilteringTextInputFormatter.digitsOnly;
        break; // The switch statement must be told to exit, or it will execute every case.
      case 'email':
        cant = 40;
        typeInput = TextInputType.emailAddress;
        format = FilteringTextInputFormatter.singleLineFormatter;
        break;
      case 'phone':
        cant = 13;
        typeInput = TextInputType.phone;
        format = FilteringTextInputFormatter.digitsOnly;
        break;
      case 'text':
        cant = 30;
        typeInput = TextInputType.text;
        format = FilteringTextInputFormatter.singleLineFormatter;
        break;
      case 'name':
        cant = 30;
        typeInput = TextInputType.name;
        format = FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'));
        break;
    }
    return Row(
      children: [
        Container(
          width: _size.width * 0.5 - 20,
          child: Text(
            label,
            style: TextStyle(
                color: Color(0xff06538D),
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: _size.width * 0.5 - 20,
          child: Focus(
            onFocusChange: (e) {
              setState(() {
                if (callback != false && !e && controller.text.isNotEmpty) {
                  callback();
                }
              });
            },
            child: TextField(
              readOnly: enable,
              keyboardType: typeInput,
              inputFormatters: <TextInputFormatter>[
                format,                
                LengthLimitingTextInputFormatter(cant)
              ],
              textCapitalization: TextCapitalization.characters,
              controller: controller,
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                errorText: isRequired && controller.text.isEmpty
                    ? 'Es requerido'
                    : !isValidEmail &&
                            controller.text.isNotEmpty &&
                            type == 'email'
                        ? 'Email inválido'
                        : null,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 14.0,
                ),
                contentPadding: EdgeInsets.only(bottom: 0, top: 0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ItemProductOrder(data, i) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width * 0.8,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                color: Color(0xffF4F4F4)),
            width: _size.width,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: [
                Text(
                  '${data['descripcion_item']}',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff707070),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 60,
                      child: Row(
                        children: [
                          Text(
                            'Código',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['id_item']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 60,
                      child: Row(
                        children: [
                          Text(
                            'Cantidad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 60,
                      child: Text('${data['cantidad']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 60,
                      child: Row(
                        children: [
                          Text(
                            'Precio Unidad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 60,
                      child: Text(
                          '\$ ' +
                              expresionRegular(
                                  double.parse(data['precio'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 60,
                      child: Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 60,
                      child: Text(
                          '\$ ' +
                              expresionRegular(
                                  double.parse(data['total'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 5.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemSelectForm(BuildContext context, String label, String hintText,
      String title, callback) {
    final _size = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          width: _size.width * 0.5 - 20,
          child: Text(
            label,
            style: TextStyle(
                color: Color(0xff06538D), fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: _size.width * 0.5 - 20,
          child: TextField(
            style: TextStyle(
              color: Color(0xff707070),
              fontSize: 14.0,
            ),
            readOnly: true,
            decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.8, color: Color(0xff707070))),
                enabled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 14.0,
                ),
                contentPadding: EdgeInsets.only(bottom: 0, top: 15),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _seeTotalCartera(context, _size);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 24.0,
                    color: Color(0xff00437C),
                  ),
                )),
          ),
        )
      ],
    );
  }

  Widget _ItemClient(hintText, data) {
    final nombre = data['nombre_sucursal'].toUpperCase();
    final tlf_cliente = data['telefono_celular'] != null
        ? data['telefono_celular']
        : data['telefono'];
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: AutoSizeText(
              maxLines: 1,
              '$nombre',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Color(0xff0f538d),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Dirección',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: AutoSizeText('${data['direccion']}',
                          maxLines: 2,
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Teléfono',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(tlf_cliente,
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          AutoSizeText(
                            maxLines: 2,
                            'Límite credito',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['limite_credito']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Ciudad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('${data['ciudad']}',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _size.width / 2 - 60,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.blue),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Center(
                            child: Text(
                              'Pedidos',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (_cartProductos.isNotEmpty &&
                                  data['id_tercero'] != id_tercero) {
                                modalNuevoPedido(context, data);
                              } else {
                                id_tercero = '${data['id_tercero']}';
                                nombre_tercero =
                                    '${data['nombre_sucursal'].toString()}  ';

                                limiteCreditoTercero =
                                    double.parse(data['limite_credito']);
                                listaPrecioTercero =
                                    '${data['lista_precio'].toString()}';
                                _value_itemsFormaPago =
                                    data['id_forma_pago'] != ''
                                        ? data['id_forma_pago']
                                        : '01';
                                id_empresa = '${data['id_empresa']}';
                                id_suc_vendedor = '${data['id_suc_vendedor']}';
                                id_sucursal_tercero =
                                    '${data['id_sucursal_tercero']}';
                                limite_credito = '${data['limite_credito']}';
                                getConsecutivo(true);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: _size.width / 4 - 20,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[300]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Center(
                            child: Text(
                              'Recibos de caja',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xff0f538d),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              id_tercero = '${data['id_tercero']}';
                              nombre_tercero =
                                  '${data['nombre_sucursal'].toString()}  ';
                              id_empresa = '${data['id_empresa']}';
                              id_suc_vendedor = '${data['id_suc_vendedor']}';
                              id_sucursal_tercero =
                                  '${data['id_sucursal_tercero']}';
                              limite_credito = '${data['limite_credito']}';
                            });
                            searchDocumentPend(data);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: _size.width / 4 - 20,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[300]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Center(
                              child: AutoSizeText(
                                maxLines: 1,
                                'Historial',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff0f538d),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            onTap: () {
                              getConsecutivo(false);
                              callbackHistory(data);
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getImagenBase64(String imagen) {

    const Base64Codec base64 = Base64Codec();
    Uint8List _bytes = base64.decode(imagen);
    
    return Container(
       child: Row(     
        children:[ _bytes == null
            ? const CircularProgressIndicator()
            : Image.memory(
                Uint8List.fromList(_bytes),
                fit: BoxFit.cover,
              ),
              Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              ' ',
                              maxLines: 1,
                              minFontSize: 10,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
            )
             );               

  }

  Widget _ItemProductos(data) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        for (var i = 0; i < _countClasificacion; i++) ...[
          InkWell(
            child:  Container(
                    decoration: BoxDecoration(
                image: DecorationImage(
                image:
                //  AssetImage('assets/images/producto-sin-imagen.png'),
                NetworkImage("${Constant.URL}/seeImagen/${data[i]['imagen']}"),
                fit: BoxFit.cover,
                ),                    
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '${data[i]['descripcion']}',
                              maxLines: 1,
                              minFontSize: 10,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            onTap: () {
              setState(() {
                idClasificacion = '${data[i]['id_clasificacion']}';
                _id_padre = idClasificacion;
                selectProductoNivel();
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _ItemCategoryOrderState(i, data) {
    final _size = MediaQuery.of(context).size;
    final saldo =
        data['saldo_inventario'] != 'null' ? data['saldo_inventario'] : 0;
    return Container(
      width: _size.width,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: AutoSizeText(
              maxLines: 2,
              '${data['descripcion']}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  labelText: 'Lista de precios',
                  items: itemsListPrecio,
                  initialValue: itemsListPrecio.length > 0
                      ? itemsListPrecio[0]['value']
                      : null,
                  onChanged: (val) => setState(() => {
                        _value_itemsListPrecio = val,
                        if (_value_itemsListPrecio != '0')
                          {
                            _itemSelect = data['id_item'],
                            searchPrecioProductos('${data['id_item']}'),
                          }
                      }),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.label_important,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            'Precio unidad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(
                          (_itemSelect == data['id_item'])
                              ? '\$ ' + expresionRegular(_precio)
                              : '\$ ' +
                                  expresionRegular(
                                      double.parse(data['precio'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_box,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 60,
                            child: Text(
                              'Unidades disponibles',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(
                          expresionRegular(double.parse(saldo.toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Container(
                      width: 120.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: (_itemSelect == data['id_item'] &&
                                          _precio > 0) &&
                                      !validExistCarrito(data['id_item']) ||
                                  (_itemSelect != data['id_item'] &&
                                          double.parse(
                                                  data['precio'].toString()) >
                                              0) &&
                                      !validExistCarrito(data['id_item'])
                              ? Colors.blue
                              : Colors.grey[300]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Center(
                            child: Text(
                              'Agregar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          onTap: (_itemSelect == data['id_item'] &&
                                      _precio > 0) ||
                                  (_itemSelect != data['id_item'] &&
                                      double.parse(data['precio'].toString()) >
                                          0)
                              ? () {
                                  if (validExistCarrito(data['id_item'])) {
                                    _showBarMsg(
                                        'Este producto ya existe en el carrito',
                                        false);
                                  } else {
                                    if (_itemSelect != data['id_item'] &&
                                        double.parse(
                                                data['precio'].toString()) >
                                            0) {
                                      _precio = double.parse(
                                          data['precio'].toString());
                                    }
                                    _itemSelect = data['id_item'];
                                    _showAlert(
                                        i,
                                        data['id_item'],
                                        data['descripcion'],
                                        int.parse(data['saldo_inventario']));
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _ItemCategoryOrderEdit(index, idItem, descripcion, cantidad) {
    final _size = MediaQuery.of(context).size;
    double maxWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      width: maxWidth,
      height: 360.0,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: AutoSizeText(
              maxLines: 2,
              '$descripcion',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.label_important,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: _size.width > 600
                                ? _size.width * 0.5 - 130
                                : _size.width * 0.5 - 80,
                            child: AutoSizeText(
                              maxLines: 1,
                              'Precio Unidad',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width > 600
                          ? _size.width * 0.5 - 160
                          : _size.width * 0.5 - 90,
                      child: AutoSizeText(
                          maxLines: 1,
                          ' \$ ' + expresionRegular(_precio),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_box,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: _size.width > 600
                                ? _size.width * 0.5 - 130
                                : _size.width * 0.5 - 80,
                            child: AutoSizeText(
                              maxLines: 2,
                              'Unidades disponibles',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width > 600
                          ? _size.width * 0.5 - 160
                          : _size.width * 0.5 - 90,
                      child: AutoSizeText(
                          maxLines: 1,
                          expresionRegular(double.parse(cantidad.toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 120,
                      child: AutoSizeText(
                        maxLines: 1,
                        'Cantidad',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                        width: _size.width * 0.5 - 65,
                        child: Container(
                          width: _size.width,
                          height: 35.0,
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_cantidadProducto > 1) {
                                        _cantidadProducto = int.parse(
                                            myControllerCantidad.text.trim());
                                        _cantidadProducto--;
                                        myControllerCantidad.text =
                                            _cantidadProducto.toString();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 30.0,
                                    height: 35.0,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            bottomLeft: Radius.circular(15.0))),
                                    child:
                                        Icon(Icons.remove, color: Colors.white),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Color(0xffC7C7C7)),
                                  color: Colors.white,
                                ),
                                width: _size.width > 600
                                    ? _size.width * 0.5 - 330
                                    : _size.width * 0.5 - 126,
                                height: 35.0,
                                child: Center(
                                  child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: myControllerCantidad,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.8,
                                                color: Color(0xff707070))),
                                      )),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _cantidadProducto = int.parse(
                                          myControllerCantidad.text.trim());
                                      _cantidadProducto++;
                                      myControllerCantidad.text =
                                          _cantidadProducto.toString();
                                    });
                                  },
                                  child: Container(
                                    width: 30.0,
                                    height: 35.0,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight:
                                                Radius.circular(15.0))),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        )),
                  ],
                ),
                TextField(
                    controller: myControllerDescuentos,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.8, color: Color(0xff707070))),
                      labelText: 'Descuento',
                      hintText: 'Ingrese descuento $_descuento',
                    )),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: OutlinedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                ),
                              ),
                              Text("Cancelar")
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                ),
                              ),
                              Text("Continuar")
                            ],
                          ),
                          style: ButtonStyle(
                              //backgroundColor: Colors.blue,
                              ),
                          onPressed: () {
                            if (!validExistCarrito(idItem)) {
                              _addProductoPedido(descripcion, idItem);
                            }
                          }),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //listado de carrito
  Widget _ItemCategoryOrderCart(data, index) {
    var cantidad = int.parse(data['cantidad'].toString());
    double total = 0.0;
    total = data['total'];
    final descripcion = data['descripcion'];
    final _size = MediaQuery.of(context).size;
    double width_px = _size.width;
    return Container(
      width: width_px,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 300.0, bottom: 0.0),
                      child: Icon(
                        Icons.do_disturb_on,
                        color: Color(0xffCB1B1B),
                        size: 20,
                      ),
                    ),
                    onTap: () => {
                          _showDialog(context, index),
                        }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  maxLines: 2,
                  '$descripcion',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width_px * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.label_important,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Precio unidad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width_px * 0.5 - 40,
                      child: Text(
                          '\$ ' +
                              expresionRegular(
                                  double.parse(data['precio'].toString())),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width_px * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_box,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: width_px * 0.5 - 60,
                            child: Text(
                              'Total',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width_px * 0.5 - 40,
                      child: Text('\$ ' + expresionRegular(total),
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: width_px * 0.5 - 40,
                      child: Text(
                        'Cantidad',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                        width: width_px * 0.5 - 40,
                        child: Container(
                          width: width_px,
                          height: 30.0,
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (cantidad > 1) {
                                        OperationDB.updateCantidad(
                                            _cartProductos[index]['id_item'],
                                            _value_automatico,
                                            false);
                                        ObtieneCarrito();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            bottomLeft: Radius.circular(15.0))),
                                    child:
                                        Icon(Icons.remove, color: Colors.white),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Color(0xffC7C7C7)),
                                  color: Colors.white,
                                ),
                                width: width_px > 600
                                    ? width_px * 0.5 - 330
                                    : width_px * 0.5 - 120,
                                height: 30.0,
                                child: Center(
                                  child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: myControllerCantidadCart,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (String str) {
                                        if (str.isNotEmpty) {
                                          OperationDB.updateCantidadFinal(
                                              _cartProductos[index]['id_item'],
                                              _value_automatico,
                                              int.parse(myControllerCantidadCart
                                                  .text
                                                  .trim()));
                                          myControllerCantidadCart.clear();
                                          ObtieneCarrito();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: cantidad.toString(),
                                        hintStyle: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w700),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.8,
                                                color: Color(0xff707070))),
                                      )),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (cantidad >= 0) {
                                        OperationDB.updateCantidad(
                                            _cartProductos[index]['id_item'],
                                            _value_automatico,
                                            true);
                                        ObtieneCarrito();
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight:
                                                Radius.circular(15.0))),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _categoriasProduc(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40.0,
          width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < _countClasificacionNivel; i++) ...[
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: i == _checked
                          ? Color(0xff06538D)
                          : Color(0xff0894FD)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            '${_datClasificacionProductosNivel[i]['descripcion'].toString()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _checked = i;
                          idClasificacion =
                              '${_datClasificacionProductosNivel[i]['id_padre_clasificacion']}';
                          searchProductosPedido();
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  //alert eliminar producto en carrito

  void _showDialog(BuildContext context, int index) {
    final _size = MediaQuery.of(context).size;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            height: 210.0,
            width: _size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Color(0xff06538D), size: 25.0),
                    SizedBox(width: 10.0),
                    Text(
                      'Atención',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff06538D),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                AutoSizeText(
                  minFontSize: 14,
                  maxLines: 2,
                  '¿Desea eliminar el siguiente item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.35 - 10,
                      height: 41.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xffCB1B1B)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Center(
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: _size.width * 0.35 - 10,
                      height: 41.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xff0894FD)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Center(
                            child: Text(
                              'Eliminar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          onTap: () {
                            OperationDB.deleteProductoCarrito(
                                _cartProductos[index]['id_item']);
                            setState(() {
                              _cartProductos.removeAt(index);
                              totalPedido = valorTotal();
                            });
                            sendCarritoBD();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  _addProductoPedido(String descripcion, String idItem) {
    final cantidad = int.parse(myControllerCantidad.text.trim());
    final total = double.parse(cantidad.toString()) * _precio;

    _cartProductos.add({
      "descripcion": descripcion,
      "id_item": idItem,
      "precio": _precio,
      "cantidad": cantidad,
      "total_dcto": double.parse(myControllerDescuentos.text.trim()),
      "dcto": double.parse(myControllerDescuentos.text.trim()),
      "id_precio_item": _value_itemsListPrecio != '0'
          ? _value_itemsListPrecio
          : listaPrecioTercero,
      "total": total
    });

    setState(() {
      totalPedido = valorTotal();
      myControllerCantidad.clear();
      myControllerDescuentos.clear();
      myControllerDescuentos.text = '0';
      myControllerCantidad.text = '1';
      _cantidadProducto = 1;
      sendCarritoBD();
    });
    Navigator.of(context).pop();
    _showBarMsg('Has agregado estos productos a tu carrito', true);
  }

  Future sendCarritoBD() async {
    final totalCosto = double.parse(totalPedido) + double.parse(totalDescuento);

    final carrito = Carrito(
        nit: _nit,
        id_tercero: '$id_tercero',
        nombre_sucursal: '$nombre_tercero',
        id_empresa: '$id_empresa',
        id_tipo_doc: idPedidoUser,
        id_vendedor: id_vendedor,
        numero: int.parse(_value_automatico),
        id_suc_vendedor: id_suc_vendedor,
        fecha:
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
        id_forma_pago: '$_value_itemsFormaPago',
        id_precio_item: '$listaPrecioTercero',
        id_direccion: _value_DireccionMercancia,
        subtotal: '$totalSubTotal',
        total_costo: totalCosto.toString(),
        total_dcto: '$totalDescuento',
        total: '$totalPedido',
        orden_compra: myControllerOrdenCompra.text.trim(),
        observacion: 'CARRITO',
        letras: _letras,
        id_direccion_factura: _value_DireccionFactura,
        usuario: _user);
    for (var i = 0; i < _cartProductos.length; i++) {
      final carritodetalle = CarritoDet(
          nit: _nit,
          id_tercero: '$id_tercero',
          numero: int.parse(_value_automatico),
          descripcion: _cartProductos[i]['descripcion'],
          id_item: _cartProductos[i]['id_item'],
          cantidad: _cartProductos[i]['cantidad'].toString(),
          precio: _cartProductos[i]['precio'].toString(),
          total_dcto: _cartProductos[i]['total_dcto'].toString(),
          dcto: _cartProductos[i]['dcto'].toString(),
          id_precio_item: _cartProductos[i]['id_precio_item']);
      //guardar el carrito en la BD ENVIADO
      await OperationDB.insertCarrito(carrito, carritodetalle);
    }
  }

  valorTotal() {
    double total = 0.0;
    double total_descuento = 0.0;
    for (int i = 0; i < _cartProductos.length; i++) {
      double descuento = 0.0;
      double totalProducto = 0.0;
      totalProducto = double.parse(_cartProductos[i]['total'].toString());
      descuento = double.parse(_cartProductos[i]['total_dcto'].toString());

      totalProducto = totalProducto - descuento;
      total_descuento = total_descuento + descuento;
      total = total + totalProducto;
    }
    totalDescuento = total_descuento.toStringAsFixed(2);
    totalPedido = total.toStringAsFixed(2);

    return total.toStringAsFixed(2);
  }

  void removeCarrito() {
    OperationDB.deleteCarrito();
    _cartProductos = [];
    totalPedido = '0.00';
    totalSubTotal = '0.00';
    totalDescuento = '0.00';
    _letras = '';
  }

  bool validExistCarrito(String idItem) {
    bool flag = false;
    findById(_cartProductos) => _cartProductos['id_item'] == idItem;
    var result = _cartProductos.where(findById);
    if (result.isNotEmpty) {
      flag = true;
    }
    return flag;
  }

  modalNuevoPedido(
    BuildContext context,
    data,
  ) {
    Widget cancelButton = ElevatedButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(
          Color(0xffCB1B1B),
        ),
      ),
    );

    Widget continueButton = ElevatedButton(
      child: Text("Continuar"),
      onPressed: () {
        OperationDB.deleteCarrito();
        _cartProductos = [];
        totalPedido = '0.00';
        totalSubTotal = '0.00';
        totalDescuento = '0.00';
        totalPedido = valorTotal();
        _letras = '';
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("¡Espera!"),
      content: Text(
          'Tiene productos en el carrito que pertenecen a otro cliente, si continua estos se descartarán.'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  modalSinPedido() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            height: 230.0,
            width: 300.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                AutoSizeText(
                  maxLines: 1,
                  '¡Espera!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                AutoSizeText(
                  maxLines: 2,
                  'Debes asignar productos para realizar el pedido',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff0894FD),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 120,
                  height: 41.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xff0894FD)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: AutoSizeText(
                          'Entendido',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future createPedido() async {
    if (id_sucursal_tercero == '' || id_suc_vendedor == '') {
      var data1 = await OperationDB.getidSuc(id_tercero, _nit);
      if (data1 != false) {
        setState(() {
          id_sucursal_tercero = data1[0]['id_sucursal_tercero'].toString();
          id_suc_vendedor = data1[0]['id_suc_vendedor'].toString();
        });
      }
    }

    await numeroAletra(totalPedido.toString());
    _submitDialog(context);

    final total_costo =
        double.parse(totalPedido) + double.parse(totalDescuento);
    var flag_pedido = true;
    var flag_pedido_det = true;
    var dia = (_selectedDate.day).toString();
    var mes = (_selectedDate.month).toString();
    final ano = _selectedDate.year;

    dia = dia.length == 1 ? '0$dia' : dia;
    mes = mes.length == 1 ? '0$mes' : mes;

    final fecha_final = '$ano-$mes-$dia';
    orden_compra =
        orden_compra != '' ? orden_compra : myControllerOrdenCompra.text.trim();

    final nuevo_pedido = Pedido(
        nit: _nit,
        id_tercero: '$id_tercero',
        id_empresa: '$id_empresa',
        id_sucursal: "01",
        id_tipo_doc: idPedidoUser,
        numero: '$_value_automatico',
        id_sucursal_tercero: id_sucursal_tercero,
        id_vendedor: id_vendedor,
        id_suc_vendedor: '$id_suc_vendedor',
        fecha: fecha_final,
        vencimiento: fecha_final,
        fecha_entrega: fecha_final,
        fecha_trm: fecha_final,
        id_forma_pago: '$_value_itemsFormaPago',
        id_precio_item: '$listaPrecioTercero',
        id_direccion: _value_DireccionMercancia != '0'
            ? _value_DireccionMercancia
            : id_direccion,
        id_moneda: "COLP",
        trm: "1",
        subtotal: '$totalSubTotal',
        total_costo: total_costo.toString(),
        total_iva: "0",
        total_dcto: '$totalDescuento',
        total: '$totalPedido',
        total_item: "0",
        orden_compra: orden_compra,
        estado: "PENDIENTE",
        flag_autorizado: "SI",
        comentario: "PRUEBA",
        observacion: myControllerObservacion.text.trim(),
        letras: _letras,
        id_direccion_factura: _value_DireccionFactura != '0'
            ? _value_DireccionFactura
            : id_direccion_factura,
        usuario: _user,
        id_tiempo_entrega: "0",
        flag_enviado: "NO");

    flag_pedido = await OperationDB.insertPedido(nuevo_pedido, true);
    await OperationDB.editarPedido(_value_automatico);

    for (var i = 0; i < _cartProductos.length; i++) {
      final subtotal = double.parse(_cartProductos[i]['precio'].toString()) *
          double.parse(_cartProductos[i]['cantidad'].toString());
      final total = (double.parse(_cartProductos[i]['precio'].toString()) *
              double.parse(_cartProductos[i]['cantidad'].toString())) -
          double.parse(_cartProductos[i]['dcto'].toString());
      final nuevo_pedido_det = PedidoDet(
          nit: _nit,
          id_empresa: '$id_empresa',
          id_sucursal: "01",
          id_tipo_doc: idPedidoUser,
          numero: '$_value_automatico',
          consecutivo: i + 1,
          id_item: _cartProductos[i]['id_item'],
          descripcion_item: _cartProductos[i]['descripcion'],
          id_bodega: "01",
          cantidad: _cartProductos[i]['cantidad'].toString(),
          precio: _cartProductos[i]['precio'].toString(),
          precio_lista: "0",
          tasa_iva: "19",
          total_iva: "0",
          tasa_dcto_fijo: "0",
          total_dcto_fijo: "0",
          total_dcto: _cartProductos[i]['total_dcto'].toString(),
          costo: "0",
          subtotal: subtotal.toString(),
          total: total.toString(),
          total_item: "0",
          id_unidad: "Und",
          cantidad_kit: "0",
          cantidad_de_kit: "0",
          recno: "0",
          id_precio_item: _cartProductos[i]['id_precio_item'],
          factor: "1",
          id_impuesto_iva: "IVA19",
          total_dcto_adicional: "0",
          tasa_dcto_adicional: "0",
          id_kit: "",
          precio_kit: "0",
          tasa_dcto_cliente: "0",
          total_dcto_cliente: "0");
      flag_pedido_det =
          await OperationDB.insertPedidoDet(nuevo_pedido_det, true);
    }

    if (flag_pedido && flag_pedido_det) {
      await OperationDB.updateConsecutivo(
          int.parse(_value_automatico), _nit, idPedidoUser, id_empresa);

      final val = await validateConexion.checkInternetConnection();
      setState(() {
        _isConnected = val!;
      });

      Navigator.pop(context);
      modalExitosa();
      _isConnected ? await SendataSincronizacion.createPedidoAPI() : null;
    } else {
      _showBarMsg('Error en la creación del pedido', false);
    }
  }

  void modalExitosa() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            height: 283.0,
            width: 283.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Image(
                  height: 90.0,
                  image: AssetImage('assets/images/icon-check.png'),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Creación de pedido exitoso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: 90,
                  height: 41.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xff0894FD)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: Text(
                          'Aceptar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        removeCarrito();
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'home');
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  ///////////////////////////////////RECIBOS DE CAJA////////////////////

  void modalExitosaRecibo() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            height: 283.0,
            width: 283.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Image(
                  height: 90.0,
                  image: AssetImage('assets/images/icon-check.png'),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Creación de Recibo exitoso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.0),
                Container(
                  width: 90,
                  height: 41.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xff0894FD)),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Center(
                        child: Text(
                          'Aceptar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'home');
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  bool _pay = false;
  bool _confirm = false;
  bool seeDescuento = false;
  late int _isPagar = 99999;
  late int _isPagarDescuento = 99999;
  List<dynamic> _dataDocumentPend = [];
  List<dynamic> _documentosPagados = [];
  late String restanteRecibo = '0.00';
  late String abonoRecibo = '0.00';

  List<dynamic> _dataDescuento = [];
  List<dynamic> _dataDescuentoAgregados = [];
  late String totalRecibo = '0.00';
  late String totalReciboPagado = '0.00';
  late String totalReciboDescuento = '0.00';
  final myControllerValorPagoRecibo = TextEditingController();
  final myControllerDescuentorec = TextEditingController();

  late String _letras = '';

  bool filterRestablece(id) {
    var flag = false;
    var val = _documentosPagados.singleWhere((obj) => obj["id"] == id,
        orElse: () => null);
    if (val != null) {
      flag = true;
    }

    return flag;
  }

  bool filterRestableceDescuento(id) {
    var flag = false;
    var val = _dataDescuentoAgregados.singleWhere((obj) => obj["id"] == id,
        orElse: () => null);
    if (val != null) {
      flag = true;
    }

    return flag;
  }

  String filterAbono(id) {
    var monto = '0.00';
    var val = _documentosPagados.singleWhere((obj) => obj["id"] == id,
        orElse: () => null);
    if (val != null) {
      var monto1 = val['monto_pagar'];
      monto = monto1.toStringAsFixed(2);
    }
    return monto;
  }

  String filterAbonoDescuento(id) {
    var monto = '0.00';
    var val = _dataDescuentoAgregados.singleWhere((obj) => obj["id"] == id,
        orElse: () => null);
    if (val != null) {
      var monto1 = val['monto_descontar'];
      monto = monto1.toStringAsFixed(2);
    }
    return monto;
  }

  void searchDocumentPend(data) async {
    final recibos =
        await OperationDB.getCarteraRecibo(id_tercero, id_sucursal_tercero);

    if (recibos != false) {
      _dataDocumentPend = recibos;

      getTipoPago();
      getItemBanco();
      getConsecutivo(false);
      setState(() {
        _clientShow = false;
        _clientShowNoFound = false;
        _productosShow = false;
        _formRecipeShow = true;
      });
    } else {
      _showBarMsg('No tiene documentos', false);
    }
  }

  //descuentos poara el recibo  //cambiar a bd
  Future<void> searchConcepto() async {
    final conceptos = await OperationDB.getConcepto(_nit);
    if (conceptos != false) {
      setState(() {
        _dataDescuento = conceptos;
        _formNewClientShow = false;
        _formNewClientShowDescuento = true;
      });
    } else {
      _showBarMsg('Error no se obtuvo el concepto', false);
    }
  }

  @override
  Widget _ItemDocumentClient(data, i) {
    final _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
          color: Color(0xffE8E8E8), borderRadius: BorderRadius.circular(6.0)),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: _size.width * 0.5 - 50,
                child: Text(
                  'Tipo:',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: _size.width * 0.5 - 42,
                child: Text(
                  '${data['tipo_doc']}',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: _size.width * 0.5 - 42,
                child: Text(
                  'Número:',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: _size.width * 0.5 - 42,
                child: Text(
                  '${data['numero']}',
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: _size.width * 0.5 - 42,
                child: Text(
                  'Saldo:',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: _size.width * 0.5 - 42,
                child: Text(
                  '\$ ' +
                      expresionRegular(double.parse(data['DEBITO'].toString())),
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          !filterRestablece(i) && i != _isPagar
              ? noPay(context, data, i)
              : Container(),
          !filterRestablece(i) && _pay && i == _isPagar
              ? pay(context, data)
              : Container(),
          filterRestablece(i) ? confirm(context, data, i) : Container()
        ],
      ),
    );
  }

  Widget noPay(BuildContext context, data, i) {
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Días:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['DIAS']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Cuota:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['cuota']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Vencimiento:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['vencimiento']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
            ),
            SizedBox(
                width: _size.width * 0.5 - 42,
                child: BtnSmall(
                    text: 'Pagar',
                    color: Color(0xff0894FD),
                    callback: () {
                      setState(() {
                        _pay = true;
                        _isPagar = i;
                      });
                    })),
          ],
        ),
      ],
    );
  }

  Widget pay(BuildContext context, data) {
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Días:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['DIAS']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Cuota:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['cuota']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Vencimiento:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['vencimiento']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Valor a pagar:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: TextField(
                readOnly: false,
                controller: myControllerValorPagoRecibo,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
                decoration: InputDecoration(
                  hintText: '',
                  hintStyle: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                  ),
                  contentPadding: EdgeInsets.only(bottom: 0, top: 0),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            SizedBox(
                width: _size.width * 0.5 - 62,
                child: BtnSmall(
                    text: 'Cancelar',
                    color: Color(0xffCB1B1B),
                    callback: () {
                      setState(() {
                        myControllerValorPagoRecibo.clear();
                        _pay = false;
                        _isPagar = 99999;
                      });
                    })),
            SizedBox(
              width: 40.0,
            ),
            SizedBox(
                width: _size.width * 0.5 - 62,
                child: BtnSmall(
                    text: 'Confirmar',
                    color: Color(0xff0894FD),
                    callback: () {
                      //  setState(() {
                      documentoPagar();
                      //  });
                    })),
          ],
        ),
      ],
    );
  }

  Widget confirm(BuildContext context, data, i) {
    final restante = double.parse(data['DEBITO'].toString()) -
        double.parse(filterAbono(i).toString());
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Abono:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '\$ ' +
                    expresionRegular(double.parse(filterAbono(i).toString())),
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Restante:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '\$ ' + expresionRegular(double.parse(restante.toString())),
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Días:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['DIAS']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Cuota:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['cuota']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                'Vencimiento:',
                style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text(
                '${data['vencimiento']}',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 13.0,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            SizedBox(
                width: _size.width * 0.5 - 62,
                child: BtnSmall(
                    text: 'Reestablecer',
                    color: Color(0xffCB1B1B),
                    callback: () {
                      setState(() {
                        documentoPagarDelete(data);
                      });
                    })),
            SizedBox(
              width: 40.0,
            ),
            SizedBox(
                width: _size.width * 0.5 - 62,
                child: BtnSmall(
                    text: 'Pagar', color: Color(0xff707070), callback: () {})),
          ],
        ),
      ],
    );
  }

  //Widget
  Widget _ItemDescuento(data, i) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
          color: Color(0xffE8E8E8), borderRadius: BorderRadius.circular(6.0)),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  !filterRestableceDescuento(i) && i != _isPagarDescuento
                      ? _listDescuento(context, data, i)
                      : Container(),
                  filterRestableceDescuento(i) ||
                          seeDescuento && i == _isPagarDescuento
                      ? _seeDescuento(context, data, i)
                      : Container(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listDescuento(BuildContext context, data, i) {
    final _size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: _size.width * 0.7,
              child: Row(
                children: [
                  SizedBox(
                    width: _size.width * 0.6,
                    child: Text(
                      '${data['descripcion']}',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Container(
              width: 120.0,
              height: 40.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), color: Colors.blue),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Center(
                      child: Text(
                        'Agregar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        seeDescuento = true;
                        _isPagarDescuento = i;
                      });
                    }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _seeDescuento(BuildContext context, data, i) {
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: _size.width * 0.7,
              child: Row(
                children: [
                  SizedBox(
                    width: _size.width * 0.6,
                    child: Text(
                      '${data['descripcion']}',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  _showDialogDescuento(context, data);
                },
                icon: Icon(
                  Icons.do_disturb_on,
                  color: Color(0xffCB1B1B),
                  size: 20.0,
                )),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        !filterRestableceDescuento(i)
            ? Row(
                children: [
                  SizedBox(
                    width: _size.width * 0.5 - 80,
                    child: Text(
                      'Valor:',
                      style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: _size.width * 0.5 - 60,
                    child: TextField(
                      readOnly: false,
                      controller: myControllerDescuentorec,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                      ),
                      decoration: InputDecoration(
                        hintText: '',
                        hintStyle: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 13.0,
                        ),
                        contentPadding: EdgeInsets.only(bottom: 0, top: 0),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        agregarDescuento();
                        setState(() {
                          seeDescuento = false;
                          _isPagarDescuento = 99999;
                        });
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.blue,
                        size: 20.0,
                      )),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: _size.width * 0.5 - 80,
                    child: Text(
                      'Valor:',
                      style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: _size.width * 0.5 - 60,
                    child: TextField(
                      readOnly: false,
                      controller: myControllerDescuentorec,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                      ),
                      decoration: InputDecoration(
                        hintText: '\$ ' +
                            expresionRegular(double.parse(
                                filterAbonoDescuento(i).toString())),
                        hintStyle: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 13.0,
                        ),
                        contentPadding: EdgeInsets.only(bottom: 0, top: 0),
                      ),
                    ),
                  ),
                ],
              )
      ],
    );
  }

  void _showDialogDescuento(BuildContext context, data) {
    final _size = MediaQuery.of(context).size;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            height: 230.0,
            width: _size.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Color(0xff06538D), size: 25.0),
                    SizedBox(width: 10.0),
                    Text(
                      'Atención',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff06538D),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                AutoSizeText(
                  minFontSize: 15,
                  maxLines: 2,
                  '¿Desea eliminar el siguiente item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.35 - 10,
                      height: 41.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xffCB1B1B)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Center(
                            child: AutoSizeText(
                              'Cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: _size.width * 0.35 - 10,
                      height: 41.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xff0894FD)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Center(
                            child: AutoSizeText(
                              'Eliminar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          onTap: () {
                            _dataDescuentoAgregados.removeWhere(
                                (_dataDescuentoAgregados) =>
                                    _dataDescuentoAgregados['id_concepto'] ==
                                    data['id_concepto']);
                            Navigator.pop(context);
                            setState(() {
                              seeDescuento = false;
                              _isPagarDescuento = 99999;
                              totalReciboPagado =
                                  valorTotalRecibo(_documentosPagados);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  //agregar carrito de recibo
  documentoPagar() {
    final abonoReciboUnico =
        double.parse(myControllerValorPagoRecibo.text.trim());

    final restanteReciboUnico =
        double.parse(_dataDocumentPend[_isPagar]['DEBITO'].toString()) -
            abonoReciboUnico;

    if (restanteReciboUnico >= 0) {
      _documentosPagados.add({
        "id": _isPagar,
        "tipo_doc": _dataDocumentPend[_isPagar]['tipo_doc'],
        "numero": _dataDocumentPend[_isPagar]['numero'],
        "debito": _dataDocumentPend[_isPagar]['DEBITO'],
        "credito": _dataDocumentPend[_isPagar]['credito'],
        "cuota": _dataDocumentPend[_isPagar]['cuota'],
        "dias": _dataDocumentPend[_isPagar]['DIAS'],
        "fecha": _dataDocumentPend[_isPagar]['fecha'],
        "vencimiento": _dataDocumentPend[_isPagar]['vencimiento'],
        "id_sucursal": _dataDocumentPend[_isPagar]['id_sucursal'],
        "id_empresa": _dataDocumentPend[_isPagar]['id_empresa'],
        "monto_pagar": double.parse(abonoReciboUnico.toString()),
        "restante": restanteReciboUnico,
        "letras": _letras,
      });

      myControllerValorPagoRecibo.clear();
      setState(() {
        _pay = false;
        _confirm = true;
        restanteRecibo = restanteReciboUnico.toStringAsFixed(2);
        abonoRecibo = abonoReciboUnico.toStringAsFixed(2);
        totalReciboPagado = valorTotalRecibo(_documentosPagados);
      });
    } else {
      _showBarMsg('EL MONTO DEBE SER MENOR O IGUAL', false);
    }
  }

  //agregar carrito de recibo
  agregarDescuento() {
    var montoDescuento = double.parse(myControllerDescuentorec.text.trim());
    _dataDescuentoAgregados.add({
      "id": _isPagarDescuento,
      "id_concepto": _dataDescuento[_isPagarDescuento]['id_concepto'],
      "monto_descontar": double.parse(montoDescuento.toString())
    });

    myControllerDescuentorec.clear();
    setState(() {
      totalReciboPagado = valorTotalRecibo(_documentosPagados);
    });
  }

  //eliminar recibo del carrito de recibo
  documentoPagarDelete(data) {
    _documentosPagados.removeWhere(
        (_documentosPagados) => _documentosPagados['numero'] == data['numero']);
    setState(() {
      _confirm = false;
      _pay = true;
      totalReciboPagado = valorTotalRecibo(_documentosPagados);
    });
  }

  String valorTotalRecibo(List<dynamic> _documentosPagados) {
    double total = 0.0;
    double descuento = 0.0;
    for (int i = 0; i < _documentosPagados.length; i++) {
      total = total + _documentosPagados[i]['monto_pagar'];
    }
    for (int i = 0; i < _dataDescuentoAgregados.length; i++) {
      descuento = descuento + _dataDescuentoAgregados[i]['monto_descontar'];
    }
    numeroAletra(totalRecibo);
    setState(() {
      totalRecibo = total.toStringAsFixed(2);
      totalReciboDescuento = descuento.toStringAsFixed(2);
    });
    total = total - descuento;
    return total.toStringAsFixed(2);
  }

  void removeCarritoRecibo() {
    _documentosPagados = [];
    totalReciboPagado = '0.00';
    totalReciboDescuento = '0.00';
    totalRecibo = '0.00';
    _dataDocumentPend = [];
  }

  Future createRecibo() async {
    _submitDialog(context);
    if (id_sucursal_tercero == '' || id_suc_vendedor == '') {
      var data1 = await OperationDB.getidSuc(id_tercero, _nit);
      if (data1 != false) {
        setState(() {
          id_sucursal_tercero = data1[0]['id_sucursal_tercero'].toString();
          id_suc_vendedor = data1[0]['id_suc_vendedor'].toString();
        });
      }
    }

    await numeroAletra(totalPedido.toString());

    var dia = (_selectedDate.day).toString();
    var mes = (_selectedDate.month).toString();
    final ano = _selectedDate.year;

    dia = dia.length == 1 ? '0$dia' : dia;
    mes = mes.length == 1 ? '0$mes' : mes;

    final fecha_otra = '$dia/$mes/$ano';
    var flag_recibo = false;
    for (var i = 0; i < _documentosPagados.length; i++) {
      final cuentaTercero = CuentaTercero(
          nit: _nit,
          id_empresa: '$id_empresa',
          id_sucursal: "01",
          tipo_doc: idReciboUser,
          numero: int.parse(_value_automatico),
          cuota: _documentosPagados[i]['cuota'],
          dias: _documentosPagados[i]['dias'],
          id_tercero: id_tercero,
          id_vendedor: id_vendedor,
          id_sucursal_tercero: int.parse(id_sucursal_tercero),
          fecha: fecha_otra,
          vencimiento: fecha_otra,
          credito: _documentosPagados[i]['monto_pagar'].toString(),
          dctomax: "0",
          debito: "0",
          id_destino: "",
          id_proyecto: "",
          id_empresa_cruce: _documentosPagados[i]['id_empresa'].toString(),
          id_sucursal_cruce: _documentosPagados[i]['id_sucursal'].toString(),
          tipo_doc_cruce: _documentosPagados[i]['tipo_doc'].toString(),
          numero_cruce: _documentosPagados[i]['numero'].toString(),
          cuota_cruce: _documentosPagados[i]['cuota'].toString(),
          flag_enviado: 'NO');
      flag_recibo = await OperationDB.insertCuentaTercero(cuentaTercero);
    }

    if (flag_recibo) {
      await createReciboCartera();
    } else {
      _showBarMsg('Error en la creacion del Recibo', false);
    }
  }

  Future createReciboCartera() async {
    late int cuota_cruce_cpd = 0;
    late int cuota = 0;
    late int conse = 0;

    var flagCartera = false;
    await numeroAletra(totalReciboPagado);
    var dia = (_selectedDate.day).toString();
    var mes = (_selectedDate.month).toString();
    final ano = _selectedDate.year;

    dia = dia.length == 1 ? '0$dia' : dia;
    mes = mes.length == 1 ? '0$mes' : mes;

    final fechaFinal = '$ano-$mes-$dia';
    final cartera = CarteraProveedores(
        nit: _nit,
        id_empresa: id_empresa,
        id_sucursal: "1",
        id_tipo_doc: idReciboUser,
        numero: int.parse(_value_automatico),
        total: totalReciboPagado,
        fecha: fechaFinal,
        vencimiento: fechaFinal,
        id_moneda: "COLP",
        letras: _letras,
        id_tercero: id_tercero,
        id_sucursal_tercero: int.parse(id_sucursal_tercero),
        id_recaudador: "0",
        fecha_trm:
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
        trm: "1",
        observaciones: myControllerObservacion.text.trim(),
        usuario: _user,
        flag_enviado: 'NO');
    flagCartera = await OperationDB.insertCarteraProveedores(cartera);
    //detalle
    if (flagCartera) {
      final carteraDetDocIni = CarteraProveedoresDet(
          id_empresa: id_empresa,
          id_sucursal: "1",
          id_tipo_doc: idReciboUser,
          numero: int.parse(_value_automatico),
          consecutivo: conse = conse + 1,
          id_empresa_cruce: _documentosPagados[0]['id_empresa'].toString(),
          id_sucursal_cruce: _documentosPagados[0]['id_sucursal'].toString(),
          id_tipo_doc_cruce: idReciboUser,
          numero_cruce: int.parse(_value_automatico),
          debito: totalReciboPagado,
          credito: "0",
          id_vendedor: id_vendedor,
          id_forma_pago: _value_itemsTipoPago,
          documento_forma_pago: "",
          cuota: cuota = cuota + 1,
          distribucion: "FP",
          descripcion: _value_itemsTipoPago == '01'
              ? 'Pago en Efectivo por el valor de $totalReciboPagado '
              : '',
          id_suc_recaudador: 1,
          total_factura: "0",
          id_concepto: "",
          id_moneda: "COLP",
          id_destino: "",
          id_proyecto: "",
          cuota_cruce: cuota_cruce_cpd = cuota_cruce_cpd + 1,
          id_banco: _value_itemsBanco,
          fecha: _documentosPagados[0]['fecha'].toString(),
          vencimiento: _documentosPagados[0]['vencimiento'].toString(),
          id_tercero: id_tercero,
          id_sucursal_tercero: int.parse(id_sucursal_tercero),
          id_recaudador: "",
          fecha_trm: fechaFinal,
          trm: "1",
          nit: _nit);
      await OperationDB.insertCarteraProveedoresDet(carteraDetDocIni);

      for (var i = 0; i < _documentosPagados.length; i++) {
        //documentos pagados
        final carteraDetDoc = CarteraProveedoresDet(
            id_empresa: id_empresa,
            id_sucursal: "1",
            id_tipo_doc: idReciboUser,
            numero: int.parse(_value_automatico),
            consecutivo: conse = conse + 1,
            id_empresa_cruce: _documentosPagados[i]['id_empresa'].toString(),
            id_sucursal_cruce: _documentosPagados[i]['id_sucursal'].toString(),
            id_tipo_doc_cruce: _documentosPagados[i]['tipo_doc'],
            numero_cruce: _documentosPagados[i]['numero'],
            debito: "0",
            credito: _documentosPagados[i]['monto_pagar'].toString(),
            id_vendedor: id_vendedor,
            id_forma_pago: _value_itemsTipoPago,
            documento_forma_pago: "",
            cuota: cuota = _documentosPagados[i]['cuota'],
            distribucion: "DC",
            descripcion: ' Abonó el documento',
            id_suc_recaudador: 1,
            total_factura: "0",
            id_concepto: "",
            id_moneda: "COLP",
            id_destino: "",
            id_proyecto: "",
            cuota_cruce: cuota_cruce_cpd =
                int.parse(_documentosPagados[i]['cuota'].toString()),
            id_banco: _value_itemsBanco,
            fecha: _documentosPagados[i]['fecha'].toString(),
            vencimiento: _documentosPagados[i]['vencimiento'].toString(),
            id_tercero: id_tercero,
            id_sucursal_tercero: int.parse(id_sucursal_tercero),
            id_recaudador: "",
            fecha_trm: fechaFinal,
            trm: "1",
            nit: _nit);
        await OperationDB.insertCarteraProveedoresDet(carteraDetDoc);
      }

      for (var i = 0; i < _dataDescuentoAgregados.length; i++) {
        final carteraDetDesc = CarteraProveedoresDet(
            id_empresa: id_empresa,
            id_sucursal: "1",
            id_tipo_doc: idReciboUser,
            numero: int.parse(_value_automatico),
            consecutivo: conse = conse + 1,
            id_empresa_cruce: _documentosPagados[0]['id_empresa'].toString(),
            id_sucursal_cruce: _documentosPagados[0]['id_empresa'].toString(),
            id_tipo_doc_cruce: idReciboUser,
            numero_cruce: int.parse(_value_automatico),
            debito: _dataDescuentoAgregados[i]['monto_descontar'].toString(),
            credito: "0",
            id_vendedor: id_vendedor,
            id_forma_pago: _value_itemsTipoPago,
            documento_forma_pago: "",
            cuota: cuota,
            distribucion: "CN",
            descripcion:
                'Pago de descuento ${_dataDescuentoAgregados[i]['monto_descontar']} ',
            id_suc_recaudador: 1,
            total_factura: "0",
            id_concepto: _dataDescuentoAgregados[i]['id_concepto'],
            id_moneda: "COLP",
            id_destino: "",
            id_proyecto: "",
            cuota_cruce: cuota_cruce_cpd = cuota_cruce_cpd + 1,
            id_banco: _value_itemsBanco,
            fecha: _documentosPagados[0]['fecha'].toString(),
            vencimiento: _documentosPagados[0]['vencimiento'].toString(),
            id_tercero: id_tercero,
            id_sucursal_tercero: int.parse(id_sucursal_tercero),
            id_recaudador: "",
            fecha_trm: fechaFinal,
            trm: "1",
            nit: _nit);
        await OperationDB.insertCarteraProveedoresDet(carteraDetDesc);
      }

      await OperationDB.updateConsecutivo(
          int.parse(_value_automatico), _nit, idReciboUser, id_empresa);

      final val = await validateConexion.checkInternetConnection();
      setState(() {
        _isConnected = val!;
      });

      Navigator.pop(context);
      modalExitosaRecibo();
      removeCarritoRecibo();
      _isConnected ? await SendataSincronizacion.createReciboApi() : null;
    }
  }

  Future<void> numeroAletra(String numero) async {
    _submitDialog(context);
    final val = await validateConexion.checkInternetConnection();
    setState(() {
      _isConnected = val!;
    });

    if (_isConnected) {
      final response =
          await http.get(Uri.parse("${Constant.URL}/letras/$numero"));
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var success = jsonResponse['success'];
      if (response.statusCode == 200 && success) {
        var data = jsonResponse['data'];
        setState(() {
          _letras = data;
        });
      }  
    }  

    Navigator.pop(context);
  }

  void _showBarMsg(msg, bool type) {
    showTopSnackBar(
      context,
      animationDuration: const Duration(seconds: 1),
      type
          ? CustomSnackBar.info(
              message: msg,
            )
          : CustomSnackBar.error(
              message: msg,
            ),
    );
  }

//visual
}
