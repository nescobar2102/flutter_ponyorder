import 'package:pony_order/@presentation/components/btnForm.dart';
import 'package:pony_order/@presentation/components/btnSmall.dart';
import 'package:pony_order/@presentation/components/inputCallback.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderEdit.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderHistoryRecibo.dart';
import 'package:pony_order/@presentation/components/itemClient.dart';
import 'package:pony_order/@presentation/components/itemProductOrder.dart';
import 'package:pony_order/@presentation/components/itemProductOrderHistory.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _clientShow = false;
  bool _productosShow = false;
  bool _productosShowCat = false;
  bool _formShow = false;
  bool _formOrderShow = false;
  bool _formRecipeShow = false;
  bool _formHistoryShow = false;
  bool _formNewClientShow = false;
  bool _formNewClientShowDescuento = false;
  bool _checkedCartera = true;
  bool _checkedPedido = false;
  bool _checkedRecibo = false;
  bool? _checked = false;
  bool isCheckedDV = false;
  bool isReadOnly = true;
  bool isOnline = true;

  String _url = 'http://localhost:3000';
  //data
  bool focus = false;
  late String _search = '@';
  late int _count;
  late String id_tercero = ''; //la cliente del dataClient para hacer el pedido
  late String nombre_tercero = '';
  late String direccion_tercero = '';
  late String tlf_tercero = '';
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

  //nuevo cliente
  String _valueChanged = '';
  String _valueToValidate = '';
  String _valueSaved = '';
  String _value_itemsTypeDoc = '';
  String _value_itemsDepartamento = '';
  String _value_itemsClasification = '';
  String _value_itemsMedioContacto = '';
  String _value_itemsZona = '';
  String _value_itemsCiudad = '';
  String _value_itemsBarrio = '';
  late Object _body;
  List<dynamic> _datClient = [];

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
//nuevo cliente
  List<Map<String, dynamic>> _itemsTypeDoc = [
    {"value": "", "label": "Seleccione"},
    {"value": "13", "label": "Cédula de Ciudadanía"},
    {"value": "31", "label": "Número de indentificación Tributaria - Nit"}
  ];

  List<Map<String, dynamic>> _itemsClasification = [
    {"value": "", "label": "Seleccione"},
    {"value": "01", "label": "COMERCIAL"},
    {"value": "02", "label": "MUEBLES Y OFICINAS MODULARES"},
    {"value": "03", "label": "SERVICIOS"}
  ];

  List<Map<String, dynamic>> _itemsCiudad = [
    {"value": "", "label": "Seleccione"},
    {"value": "76001", "label": "Cali"},
    {"value": "76016", "label": "Buenaventura"}
  ];
  List<Map<String, dynamic>> _itemsBarrio = [
    {"value": "", "label": "Seleccione"},
    {"value": "76001001", "label": "Las acacias"},
    {"value": "76001002", "label": "Los Andes"}
  ];
//nuevo pedido
  List<Map<String, dynamic>> _itemsFormaPago = [
    {"value": "", "label": "Seleccione"},
    {"value": "01", "label": "EFECTIVO"},
    {"value": "02", "label": "CREDITO 8 DIAS"},
    {"value": "03", "label": "CREDITO 30 DIAS"}
  ];
  String _value_itemsFormaPago = '';
  late String _value_automatico = '';
  late String _value_automaticoRecibo = '';
  String _value_DireccionFactura = '';
  String _value_DireccionMercancia = '';

  late String forma_pago_pedido = '';
  List<dynamic> _datClasificacionProductos = [];
  late int _countClasificacion;

  late int _countClasificacionNivel = 0;
  List<dynamic> _datClasificacionProductosNivel = [];
  late String idClasificacion = '01';
  late String _id_padre = '-';
  late String totalPedido = '0.00';
  late String totalSubTotal = '0.00';
  late String totalDescuento = '0.00';
  late String _saldoCartera = '0.00';

  //pantalla 2 de seleccion de productos para pedidos
  late String _searchProducto = '@';
  late int _countProductos = 0;
  List<dynamic> _datProductos = [];
  List<dynamic> _cartProductos = [];

  List<Map<String, dynamic>> _itemsListPrecio = [
    {"value": "", "label": "Seleccione"},
    {"value": "01", "label": "precios distribuidor"},
  ];

  //variables de pedidos
  List<dynamic> _addProductos = [];
  bool selectItem = false;
  final myControllerNroPedido = TextEditingController();
  final myControllerDescuentos = TextEditingController();
  final myControllerObservacion = TextEditingController();
  final myControllerCantidad = TextEditingController();
  final myControllerOrdenCompra = TextEditingController();

  late String _precioList = '';
  late String _value_itemsListPrecio = '';
  late String _itemSelect = '';
  late double _precio = 0;
  late double _descuento = 0;
  late double limiteCreditoTercero = 0;
  late String listaPrecioTecero = '';

  //nuevo recibo de caja
  final myControllerNroRecibo = TextEditingController();
  final myControllerNroCheque = TextEditingController();
  String _value_itemsFormaPagoRecibo = '';
  String _value_itemsBanco = '';
  String _value_itemsTipoPago = '';

  //nuevo pedido
  List<Map<String, dynamic>> _itemsBanco = [
    {"value": "", "label": "Seleccione"},
    {"value": "07", "label": "Bancolombia"},
    {"value": "23", "label": "Banco de Occidente"},
  ];

  List<Map<String, dynamic>> _itemsTipoPago = [
    {"value": "", "label": "Seleccione"},
    {"value": "01", "label": "EFECTIVO"},
    {"value": "02", "label": "TRANSFERENCIA BANCOLOMBIA"},
    {"value": "03", "label": "PAGO CON CHEQUES"},
  ];

  @override
  void initState() {
    super.initState();
    _loadDataUserLogin();
  }

  /// This implementation is just to simulate a load data behavior
  /// from a data base sqlite or from a API

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
      print("el usuario es $_user $_nit");
      if (_nit != '') {
        searchClient();
      }
    });
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
          message: msg,
        ),
      );
    }
  }

  late List<Map<String, dynamic>> _itemsDepartamento;
  Future getItemDepartamento() async {
    final response = await http.get(Uri.parse("$_url/app_depto/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      setState(() {
        _itemsDepartamento = (convert.jsonDecode(response.body)["data"] as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();

        print("object _itemsDepartamento   $_itemsDepartamento");
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future getItemClasification() async {
    final response =
        await http.get(Uri.parse("$_url/app_tipoidentificacion_all"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      setState(() {
        //_item_type_identification = data;
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  late List<Map<String, dynamic>> _itemsMedioContacto;
  Future getItemMedioContacto() async {
    final response = await http.get(Uri.parse("$_url/app_medioContacto/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      setState(() {
        _itemsMedioContacto =
            (convert.jsonDecode(response.body)["data"] as List)
                .map((dynamic e) => e as Map<String, dynamic>)
                .toList();

        print("object app_medioContacto   $_itemsMedioContacto");
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  late List<Map<String, dynamic>> _itemsZona;
  Future getItemZona() async {
    final response = await http.get(Uri.parse("$_url/app_zona/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      setState(() {
        _itemsZona = (convert.jsonDecode(response.body)["data"] as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();

        print("object _itemsZona   $_itemsZona");
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future getItemCiudad() async {
    final response = await http.get(Uri.parse("$_url/app_ciudades/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future getItemBarrio() async {
    final response = await http.get(Uri.parse("$_url/app_barrio/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      setState(() {});
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }
//fin data

  final myControllerSearch = TextEditingController();

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  Future<void> searchClient() async {
    _body = {
      'nit': _nit,
      'nombre': (_search.isNotEmpty && _search != '') ? _search : null,
    };
    final response =
        await http.post(Uri.parse("$_url/clientes"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      _datClient = jsonResponse['data'];
      _count = jsonResponse['count'];
      if (_count > 0) {
        setState(() {
          _clientShow = true;
          _productosShow = false;
        });
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future<void> saldoCartera(bool pedido) async {
    final response = await http
        .get(Uri.parse("$_url/saldo_cartera/$id_tercero/$id_sucursal_tercero"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      setState(() {
        _saldoCartera = data[0]['debito'].toString();
      });
      if (_value_automatico != '' && pedido) {
        _direccionClient = [];
        searchClientDireccion();
      }
    } else {
      Navigator.pop(context);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future<void> _saveClient() async {
    print("Save client");

    final response = await http.post(Uri.parse("$_url/nuevo_cliente_app"),
        body: ({
          "id_tercero": myControllerNroDoc.text,
          "id_sucursal_tercero": "1",
          "id_tipo_identificacion": _value_itemsTypeDoc,
          "dv": myControllerDv.text,
          "nombre": isCheckedDV ? myControllerPrimerNombre.text : '',
          "direccion": myControllerDireccion.text,
          "id_pais": "57",
          "id_depto": _value_itemsDepartamento,
          "id_ciudad": _value_itemsCiudad,
          "id_barrio": _value_itemsBarrio,
          "telefono": myControllerTelefono.text,
          "nombre_sucursal": !isCheckedDV
              ? myControllerRazonSocial.text
              : myControllerPrimerApellido.text +
                  myControllerSegundoApellido.text,
          "primer_apellido": isCheckedDV ? myControllerPrimerApellido.text : '',
          "segundo_apellido":
              isCheckedDV ? myControllerSegundoApellido.text : '',
          "primer_nombre": isCheckedDV ? myControllerPrimerNombre.text : '',
          "segundo_nombre": isCheckedDV ? myControllerSegundoNombre.text : '',
          "e_mail": myControllerEmail.text,
          "telefono_celular": myControllerTelefono.text,
          "id_forma_pago": "01",
          "id_precio_item": "01",
          "id_vendedor": "16499705",
          "id_medio_contacto": _value_itemsMedioContacto,
          "id_zona": _value_itemsZona,
          "id_direccion": "1",
          "tipo_direccion": "Factura",
          "id_suc_vendedor": "1",
          'nit': _nit,
          "id_tipo_empresa": _value_itemsClasification
        }));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      print('response crear cliente http: $msg $success ');
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Container(
              height: 283.0,
              width: 100.0,
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
                    'Creación de cliente exitosa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff06538D),
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 100.0,
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
                          Navigator.pushNamed(context, 'home');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
      setState(() {
        Navigator.pushNamed(context, 'home');
      });
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message: msg,
        ),
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future<void> getConsecutivo(bool pedido) async {
    print("id de tercero a buscar $id_tercero $nombre_tercero");
    var idTipoDoc = pedido ? idPedidoUser : idReciboUser;
    final response = await http
        .get(Uri.parse("$_url/tipodoc_consecutivo_app/$_nit/$idTipoDoc"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      _value_automatico = data[0]['consecutivo'].toString();
      if (_value_automatico != '') {
        saldoCartera(pedido);
      } else {
        setState(() {
          _formRecipeShow = true;
        });
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  late List<Map<String, dynamic>> _direccionClient;
  Future<void> searchClientDireccion() async {
    _body = {
      'nit': _nit,
      'id_tercero':
          (id_tercero.isNotEmpty && id_tercero != '') ? id_tercero : null,
    };
    final response =
        await http.post(Uri.parse("$_url/clientes_direccion"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      setState(() {
        _direccionClient = (convert.jsonDecode(response.body)["data"] as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();
        Navigator.pop(context);
        _clientShow = false;
        _formOrderShow = true;
        _productosShow = false;
      });
    } else {
      Navigator.pop(context);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future<void> searchClasificacionProductos() async {
    print("searchClasificacionProductos------------------------------ ");
    _body = {'nit': _nit, 'nombre': '@', 'nivel': '1', 'id_padre': '-'};
    final response = await http
        .post(Uri.parse("$_url/clasificacion_productos_nivel"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      _datClasificacionProductos = jsonResponse['data'];
      _countClasificacion = jsonResponse['count'];
      setState(() {
        if (_countClasificacion > 0) {
          print(
              "mosrtart la clasificacion unidades $_datClasificacionProductos");
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
          _formOrderShow = false;
          _productosShow = true;
          _productosShow
              ? _productos(context, _datClasificacionProductos)
              : Container();
        }
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future<void> selectProducto() async {
    _body = {'nit': _nit, 'nombre': '@', 'nivel': '1', 'id_padre': '-'};
    final response = await http
        .post(Uri.parse("$_url/clasificacion_productos_nivel"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      _datClasificacionProductos = jsonResponse['data'];

      _countClasificacion = jsonResponse['count'];
      setState(() {
        if (_countClasificacion > 0) {
          print(
              "mosrtart la clasificacion unidades $_datClasificacionProductos");
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
          _formOrderShow = false;
          _productosShow = true;
          _productosShow
              ? _productos(context, _datClasificacionProductos)
              : Container();
        }
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future<void> selectProductoNivel() async {
    _body = {'nit': _nit, 'nombre': '@', 'nivel': '2', 'id_padre': _id_padre};
    final response = await http
        .post(Uri.parse("$_url/clasificacion_productos_nivel"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      _datClasificacionProductosNivel = jsonResponse['data'];

      _countClasificacionNivel = jsonResponse['count'];
      setState(() {
        idClasificacion =
            '${_datClasificacionProductosNivel[0]['id_clasificacion']}';
        searchProductosPedido();
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  Future<void> searchProductosPedido() async {
    _body = {
      'nit': _nit,
      'id_clasificacion': idClasificacion,
      'descripcion': (_searchProducto.isNotEmpty && _searchProducto != '')
          ? _searchProducto
          : '@',
    };
    final response = await http.post(Uri.parse("$_url/items"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      _datProductos = jsonResponse['data'];
      _countProductos = jsonResponse['count'];
      setState(() {
        _productosShow = false;
        _productosShowCat = true;
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  void searchPrecioProductos(String idItem) async {
    _body = {
      'nit': _nit,
      'id_item': idItem,
      'id_precio_item': _value_itemsListPrecio
    };
    final response =
        await http.post(Uri.parse("$_url/precio_items_app"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      setState(() {
        _precio = double.parse(jsonResponse['data'][0]['precio']);
        _itemSelect = jsonResponse['data'][0]['id_item'];
        _descuento = double.parse(jsonResponse['data'][0]['descuento_maximo']);
        print("El de mierdad precio precio $_precio $_itemSelect $_descuento");
      });
    }
  }

  // Perform login
  void validateAndSubmit() {
    _search = myControllerSearch.text;
    setState(() {
      searchClient();
    });
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
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
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
                    })
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
                                      decoration: InputDecoration(
                                        hintText: !_productosShow
                                            ? 'Buscar cliente'
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
                          _clientShow
                              ? _client(context, _datClient)
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

  void callbackHistory(data) {
    //historial
    setState(() {
      id_tercero = '${data['id_tercero']}';
      nombre_tercero =
          '${data['nombre_completo']}  ${data['nombre_sucursal']} ';
      direccion_tercero = '${data['direccion']}';
      tlf_tercero = '${data['telefono']}';
      id_empresa = '${data['id_empresa']}';
      id_sucursal_tercero = '${data['id_sucursal_tercero']}';
      limite_credito = '${data['limite_credito']}';
      _formHistoryShow = true;
      _clientShow = false;
      _productosShow = false;
    });
  }

  void callbackRecipe(data) {
    //recibo
    setState(() {
      id_tercero = '${data['id_tercero']}';
      nombre_tercero =
          '${data['nombre_completo'].toString()}  ${data['nombre_sucursal'].toString()} ';
      forma_pago_tercero = '${data['forma_pago'].toString()}';
      _value_itemsFormaPago = data['id_forma_pago'];
      id_empresa = '${data['id_empresa']}';
      id_suc_vendedor = '${data['id_suc_vendedor']}';
      id_sucursal_tercero = '${data['id_sucursal_tercero']}';
      limite_credito = '${data['limite_credito']}';
    });
  }

  Widget _client(BuildContext context, data) {
    //listado de clientes en el home
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Se encontraron $_count resultados',
            style: TextStyle(
                color: Color(0xff0f538d),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic)),
        SizedBox(height: 10.0),
        for (var i = 0; i < _count; i++) ...[
          _ItemClient('$_count', _datClient[i]),
        ],
        SizedBox(height: 30.0),
        BtnForm(
            text: 'Crear cliente',
            color: Color(0xff0894FD),
            callback: () => {
                  setState(() {
                    getItemTypeIdentication();
                    getItemDepartamento();
                    getItemClasification();
                    _itemsMedioContacto = [];
                    getItemMedioContacto();
                    _itemsZona = [];
                    getItemZona();
                    getItemCiudad();
                    getItemBarrio();
                    _clientShow = false;
                    _formShow = true;
                  })
                }),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _productos(BuildContext context, data) {
    //listado de clientes en el home
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nuevo Pedido',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          '$nombre_tercero',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff0894FD)),
        ),
        SizedBox(
          height: 10.0,
        ),
        InputCallback(
            hintText: 'Buscar Categoria',
            iconCallback: Icons.search,
            callback: () => {}),
        SizedBox(
          height: 20.0,
        ),
        _ItemProductos(data),
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
                          /*     _search = '@';
                          searchClient(); */
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
                      color: _cartProductos.length > 0
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
                        _cartProductos.length > 0
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
    return SafeArea(
      child: Container(
        width: _size.width,
        height: _size.height - AppBar().preferredSize.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView(
          children: [
            Column(
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
                    Icon(
                      Icons.disabled_by_default_outlined,
                      color: Color(0xff0f538d),
                      size: 30.0,
                    )
                  ],
                ),
                SizedBox(height: 12.0),
                Text('$nombre_tercero',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Búsqueda de productos en el carrito',
                  style: TextStyle(
                      color: Color(0xff0f538d),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                InputCallback(
                    hintText: 'Buscar producto',
                    iconCallback: Icons.search,
                    callback: () => {}),
                SizedBox(height: 15.0),
                Container(
                  width: 160.0,
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
                          print("volver a la categortia desde el carrito");
                          Navigator.pop(context);
                          _productosShowCat = false;
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
                            Text(
                              'Categorias',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700),
                            )
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
                  height: 310.0,
                  child: ListView(
                    children: [
                      for (var i = 0; i < data.length; i++) ...[
                        _ItemCategoryOrderCart(data[i], i),
                        SizedBox(height: 10.0),
                      ]
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                TextField(
                    controller: myControllerObservacion,
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.8, color: Color(0xff707070))),
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
                                  print("vaciar carrito");
                                  removeCarrito();
                                  _clientShow = true;
                                  _productosShowCat = false;
                                  _productosShow = false;
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
                              color: _cartProductos.length > 0
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
                                print("guardar pedido desde carrito");
                                _cartProductos.length > 0
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

  Widget _shoppingCat(BuildContext context, id) {
    final _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: _size.width,
        height: _size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        // padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nuevo Pedido 2',
                      style: TextStyle(
                          color: Color(0xff0f538d),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Text('$nombre_tercero',
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
                InputCallback(
                    hintText: 'Buscar producto',
                    iconCallback: Icons.search,
                    callback: () => {
                          setState(() {
                            print(" *-*-*-*  buscar productos*-*-*-*  ");
                          })
                        }),
                SizedBox(height: 15.0),
                Container(
                  width: 160.0,
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
                            Text(
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
                  height: 310.0,
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
                                  /*   _search = '@';
                                  searchClient(); */
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
                              color: _cartProductos.length > 0
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
                                print("guardar pedido");
                                _cartProductos.length > 0
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
                    Icons.attach_money_sharp,
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
                  onTap: () => Navigator.pushNamed(context, 'login'),
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
          Text(
            'Visualice el historial del cliente',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff06538D)),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
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
                    _checkedCartera = true;
                    _checkedPedido = false;
                    _checkedRecibo = false;
                  });
                }),
                SizedBox(
                  width: 8.0,
                ),
                _btnHistory(context, 'Pedido',
                    _checkedPedido ? Color(0xff06538D) : Color(0xff0894FD), () {
                  setState(() {
                    _checkedCartera = false;
                    _checkedPedido = true;
                    _checkedRecibo = false;
                  });
                }),
                SizedBox(
                  width: 8.0,
                ),
                _btnHistory(context, 'Recibo',
                    _checkedRecibo ? Color(0xff06538D) : Color(0xff0894FD), () {
                  setState(() {
                    _checkedCartera = false;
                    _checkedPedido = false;
                    _checkedRecibo = true;
                  });
                }),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          _checkedCartera ? _totalHistoryCartera(context) : Container(),
          _checkedPedido ? _totalHistoryPedido(context) : Container(),
          _checkedRecibo ? _totalHistoryRecibo(context) : Container(),
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
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$ ' +
                      expresionRegular(double.parse(_saldoCartera.toString())),
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
                      child: Text('Cr 74 # 37 - 38',
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
                      child: Text('\$ 347.281',
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
                      child: Text('3 Días',
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
                      _checkedCartera = true;
                      _checkedPedido = false;
                      _checkedRecibo = false;
                      _formHistoryShow = false;
                      _clientShow = false;
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
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$ 347.281',
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
                      child: Text('6243',
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
                      child: Text('11/12/21',
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
            'Este pedido tiene 5 items',
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
                ItemProductOrderHistory(callback: () {}),
                SizedBox(height: 10.0),
                ItemProductOrderHistory(callback: () {}),
                SizedBox(height: 10.0),
                ItemProductOrderHistory(callback: () {}),
                SizedBox(height: 10.0),
                ItemProductOrderHistory(callback: () {})
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
                      _checkedCartera = true;
                      _checkedPedido = false;
                      _checkedRecibo = false;
                      _formHistoryShow = false;
                      _clientShow = false;
                      _productosShow = false;
                    });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalHistoryRecibo(BuildContext context) {
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
                  'Total de recibo',
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '\$ 347.281',
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
                      child: Text('6243',
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
                      child: Text('12/21/21',
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
                      child: Text('3 Días',
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
            'Este pedido tiene 5 items',
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
                ItemProductOrderHistoryRecibo(callback: () {}),
                SizedBox(height: 10.0),
                ItemProductOrderHistoryRecibo(callback: () {}),
                SizedBox(height: 10.0),
                ItemProductOrderHistoryRecibo(callback: () {}),
                SizedBox(height: 10.0),
                ItemProductOrderHistoryRecibo(callback: () {}),
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
                      _checkedCartera = true;
                      _checkedPedido = false;
                      _checkedRecibo = false;
                      _formHistoryShow = false;
                      _clientShow = false;
                      _productosShow = false;
                    });
                  }),
            ),
          ),
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
                  height: 20.0,
                ),
                SizedBox(
                  height: 420.0,
                  child: ListView(
                    children: [
                      for (var i = 0; i < _dataDocumentPend.length; i++) ...[
                        _ItemDocumentClient(_dataDocumentPend[i], i),
                        SizedBox(height: 10.0),
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
                              _clientShow = false;
                              _formNewClientShow = false;
                              _search = '@';
                              removeCarritoRecibo();
                              searchClient();
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
                  height: 420.0,
                  child: ListView(
                    children: [
                      for (var i = 0; i < _dataDescuento.length; i++) ...[
                        _ItemDescuento(_dataDescuento[i], i),
                        SizedBox(height: 10.0),
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

                            setState(() {
                              /*   _clientShow = false;
                              _formNewClientShow = true;   */
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
                  myControllerNroRecibo, true),
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
              _itemForm(context, 'Nombre', '$nombre_tercero', null, false),
              _itemForm(
                  context,
                  'Total cartera',
                  '\$ ' +
                      expresionRegular(double.parse(_saldoCartera.toString())),
                  null,
                  false),
              SelectFormField(
                style: TextStyle(
                    color: Color(0xff06538D),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
                type: SelectFormFieldType.dropdown, // or can be dialog
                labelText: 'Forma de pago',
                items: _itemsTipoPago,
                onChanged: (val) => setState(() => _value_itemsTipoPago = val),
                onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                validator: (val) {
                  setState(() => _valueToValidate = val ?? '');
                  return null;
                },
              ),
              SelectFormField(
                style: TextStyle(
                    color: Color(0xff06538D),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
                type: SelectFormFieldType.dropdown, // or can be dialog
                labelText: 'Banco',
                items: _itemsBanco,
                onChanged: (val) => setState(() => _value_itemsBanco = val),
                onSaved: (val) => setState(() => _valueSaved = val ?? ''),
                validator: (val) {
                  setState(() => _valueToValidate = val ?? '');
                  return null;
                },
              ),
              _itemForm(
                  context, 'N° cheque', '00000', myControllerNroCheque, false),
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
                            _clientShow = false;
                            _formRecipeShow = false;
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
                            _formRecipeShow = false;
                            _formNewClientShow = true;
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

  Widget _formOrder(BuildContext context, data_tercero_pedido) {
    //crear nuevo pedido
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            myControllerNroPedido, true),
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
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'
                    // DateFormat.dMMy().format(_selectedDate),
                    ),
                Icon(Icons.arrow_drop_down, color: Color(0xff06538D)),
              ],
            ),
          ),
        ),
        // ElevatedButton(onPressed: _pickDateDialog, child: Text('Fecha')),
        /*    _itemForm(
            context,
            'Fecha',
            _selectedDate == null //ternary expression to check if date is null
                ? 'No date was chosen!'
                : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            null,
            true), */
        _itemForm(context, 'Nombre', '$nombre_tercero', null, true),
        SelectFormField(
          style: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),

          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Dir. envío factura',
          items: _direccionClient,
          onChanged: (val) => setState(() => _value_DireccionFactura = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          style: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),

          type: SelectFormFieldType.dropdown, // or can be dialog

          labelText: 'Dir. envío mercancia',
          items: _direccionClient,
          onChanged: (val) => setState(() => _value_DireccionMercancia = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        _itemForm(
            context, 'Orden de compra', '', myControllerOrdenCompra, false),
        _itemForm(context, 'Forma de pago', '$forma_pago_tercero', null, true),
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
            expresionRegular(double.parse(limite_credito.toString())),
            null,
            false),
        _itemSelectForm(
            context,
            'Total cartera',
            '\$ ' + expresionRegular(double.parse(_saldoCartera.toString())),
            'Selecciona'),
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
                        searchClasificacionProductos();
                      },
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(height: 10.0)
      ],
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
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Tipo de documento',
          items: _itemsTypeDoc.toList(),
          onChanged: (val) => setState(() => _value_itemsTypeDoc = val),
          onSaved: (val) => print(val),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        _itemForm(context, 'N° de documento', '', myControllerNroDoc, false),
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
                print(value);
                isCheckedDV = !isCheckedDV;
                isReadOnly = !isReadOnly;
              });
            }),
        _itemForm(context, 'DV.', 'PersonaNatural', myControllerDv, false),
        _itemForm(
            context, 'Primer nombre', '', myControllerPrimerNombre, isReadOnly),
        _itemForm(context, 'Segundo nombre', '', myControllerSegundoNombre,
            isReadOnly),
        _itemForm(context, 'Primer apellido', '', myControllerPrimerApellido,
            isReadOnly),
        _itemForm(context, 'Segundo apellido', '', myControllerSegundoApellido,
            isReadOnly),
        _itemForm(
            context, 'Razón social', '', myControllerRazonSocial, isCheckedDV),
        _itemForm(context, 'Dirección', '', myControllerDireccion, false),
        _itemForm(context, 'Email', '', myControllerEmail, false),
        _itemForm(context, 'Teléfono fijo', '', myControllerTelefono, false),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Clasificación',
          items: _itemsClasification,
          onChanged: (val) => setState(() => _value_itemsClasification = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Medio contacto',
          items: _itemsMedioContacto,
          onChanged: (val) => setState(() => _value_itemsMedioContacto = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Zona',
          items: _itemsZona,
          onChanged: (val) => setState(() => _value_itemsZona = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Departamento',
          items: _itemsDepartamento,
          onChanged: (val) => setState(() => _value_itemsDepartamento = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Ciudad',
          items: _itemsCiudad,
          onChanged: (val) => setState(() => _value_itemsCiudad = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Barrio',
          items: _itemsBarrio,
          onChanged: (val) => setState(() => _value_itemsBarrio = val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
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
                      color: Color(0xff0894FD)),
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
                          _saveClient();
                          _clientShow = false;
                          _formShow = false;
                        });
                        /* showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Container(
                                height: 283.0,
                                width: _size.width * 0.7,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.0),
                                    Image(
                                      height: 90.0,
                                      image: AssetImage(
                                          'assets/images/icon-check.png'),
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      'Creación de cliente exitosa',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff06538D),
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 30.0),
                                    Container(
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
                              )),
                        );*/
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

  Widget _itemForm(
      BuildContext context, String label, String hintText, controller, enable) {
    final _size = MediaQuery.of(context).size;
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
          child: TextField(
            readOnly: enable,
            controller: controller,
            style: TextStyle(
              color: Color(0xff707070),
              fontSize: 14.0,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Color(0xff707070),
                fontSize: 14.0,
              ),
              contentPadding: EdgeInsets.only(bottom: 0, top: 0),
            ),
          ),
        )
      ],
    );
  }

  Widget _itemSelectForm(
      BuildContext context, String label, String hintText, String title) {
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
            readOnly: false,
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
                  onTap: () {},
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
    print('-----------Howdy, ${data['nombre_completo']}!');
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
            child: Text(
              '${data['nombre_completo']} (${data['nombre_sucursal']})',
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
                      child: Text('${data['direccion']}',
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
                      child: Text('${data['telefono']}',
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
                          Text(
                            'Límite crediticio',
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
                              _submitDialog(context);
                              id_tercero = '${data['id_tercero']}';
                              nombre_tercero =
                                  '${data['nombre_completo'].toString()}  ${data['nombre_sucursal'].toString()} ';
                              forma_pago_tercero =
                                  '${data['forma_pago'].toString()}';
                              limiteCreditoTercero =
                                  double.parse(data['limite_credito']);
                              listaPrecioTecero =
                                  '${data['lista_precio'].toString()}';
                              _value_itemsFormaPago = data['id_forma_pago'];
                              id_empresa = '${data['id_empresa']}';
                              id_suc_vendedor = '${data['id_suc_vendedor']}';
                              id_sucursal_tercero =
                                  '${data['id_sucursal_tercero']}';
                              limite_credito = '${data['limite_credito']}';
                              getConsecutivo(true);
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
                                  '${data['nombre_completo'].toString()}  ${data['nombre_sucursal'].toString()} ';
                              forma_pago_tercero =
                                  '${data['forma_pago'].toString()}';
                              _value_itemsFormaPago = data['id_forma_pago'];
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
                              child: Text(
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

  Widget _ItemProductos(data) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        for (var i = 0; i < _countClasificacion; i++) ...[
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/${data[i]['imagen']}.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                print(
                    "Tapped on id_clasificacion${data[i]['id_clasificacion']}");
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
            child: Text(
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
                  items: _itemsListPrecio,
                  onChanged: (val) => setState(() => {
                        _value_itemsListPrecio = val,
                        print("se busca el precio $_value_itemsListPrecio"),
                        searchPrecioProductos('${data['id_item']}'),
                      }),
                  onSaved: (val) => print(val),
                  /*    validator: (val) {
                  setState(() => _valueToValidate = val ?? '');
                  return null;
                }, */
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
                      width: _size.width * 0.5 - 40,
                      child: Text(
                          _itemSelect == data['id_item'] &&
                                  data['precio'] != null
                              ? '\$ ' + expresionRegular(_precio)
                              : '\$  0.00',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
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
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(expresionRegular(data['saldo_inventario']),
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
                    Container(),
                    Container(
                      width: 160.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: _itemSelect == data['id_item'] && _precio > 0
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          onTap: _itemSelect == data['id_item'] && _precio > 0
                              ? () {
                                  _showAlert(
                                      i,
                                      data['id_item'],
                                      data['descripcion'],
                                      data['saldo_inventario']);
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
      height: 350.0,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
            child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text(
                            'Precio Unidad \n \$ ' + expresionRegular(_precio),
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              'Unidades disponibles        ' +
                                  expresionRegular(cantidad),
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                /*  TextField(
                    controller: myControllerCantidad,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.8, color: Color(0xff707070))),
                      labelText: 'Cantidad',
                      hintText: 'Ingrese cantidad',
                    )) */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 65,
                      child: Text(
                        'Cantidad',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                        width: _size.width * 0.5 - 75,
                        child: Container(
                          width: _size.width,
                          height: 30.0,
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_cantidadProducto > 0) {
                                        _cantidadProducto--;

                                        myControllerCantidad.text =
                                            _cantidadProducto.toString();
                                        print(
                                            "cantidad resta $_cantidadProducto");
                                      }
                                    });
                                  },
                                  child: Container(
                                    //   Container(
                                    width: 25.0,
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
                                width: _size.width * 0.5 - 160,
                                height: 30.0,
                                child: Center(
                                  child: TextField(
                                      controller: myControllerCantidad,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 0.8,
                                                  color: Color(0xff707070))),
                                          labelText:
                                              _cantidadProducto.toString(),
                                          hintText:
                                              _cantidadProducto.toString())),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      _cantidadProducto++;
                                      myControllerCantidad.text =
                                          _cantidadProducto.toString();
                                      print("cantidad suma $_cantidadProducto");
                                    });
                                  },
                                  child: Container(
                                    width: 25.0,
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
                TextField(
                    controller: myControllerDescuentos,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
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
                      padding: const EdgeInsets.all(4.0),
                      child: OutlinedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
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
                      padding: const EdgeInsets.all(4.0),
                      child: OutlinedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                ),
                              ),
                              Text("Continuar")
                            ],
                          ),
                          onPressed: () {
                            _addProductoPedido(descripcion, idItem);
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
    double total = 0.0;
    print("listado de carrito $data");
    total = data['precio'] * data['cantidad'];

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data['descripcion']}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      print("eliminar producto del carrito");
                      _showDialog(context, index);
                      /*      dbHelper!.deleteCartItem(
                                         provider.cart[index].id!);
                                     provider
                                         .removeItem(provider.cart[index].id!);
                                     provider.removeCounter(); */
                    },
                    icon: Icon(
                      Icons.do_disturb_on,
                      color: Color(0xffCB1B1B),
                      size: 20.0,
                    )),
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
                      width: _size.width * 0.5 - 40,
                      child: Text('\$ ' + expresionRegular(data['precio']),
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
                      width: _size.width * 0.5 - 40,
                      child: Text(expresionRegular(total),
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
                      child: Text(
                        'Cantidad',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                        width: _size.width * 0.5 - 40,
                        child: Container(
                          width: _size.width,
                          height: 30.0,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 35.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(15.0))),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Color(0xffC7C7C7)),
                                  color: Colors.white,
                                ),
                                width: _size.width * 0.5 - 110,
                                height: 30.0,
                                child: Center(
                                    child: Text(
                                  '${data['cantidad']}',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                )),
                              ),
                              Container(
                                width: 35.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0))),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              )
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
                      color: i == 0 ? Color(0xff06538D) : Color(0xff0894FD)),
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
                          idClasificacion =
                              '${_datClasificacionProductosNivel[i]['id_clasificacion']}';
                          print(
                              "----------filtrar por categoria $idClasificacion");
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
                SizedBox(height: 20.0),
                Text(
                  '¿Desea eliminar el siguiente item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30.0),
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
                            print("Aceptar $index");
                            _cartProductos.removeAt(index);
                            print("Aceptar $_cartProductos");
                            setState(() {
                              totalPedido = valorTotal(_cartProductos);
                              numeroAletra(totalPedido.toString());
                            });

                            Navigator.of(context).pop();
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

  _addProductoPedido(
    String descripcion,
    String idItem,
  ) {
    _cartProductos.add({
      "descripcion": descripcion,
      "id_item": idItem,
      "precio": _precio,
      "cantidad": double.parse(myControllerCantidad.text),
      "total_dcto": double.parse(myControllerDescuentos.text),
      "dcto": double.parse(myControllerDescuentos.text),
      "id_precio_item": _value_itemsListPrecio != ''
          ? _value_itemsListPrecio
          : listaPrecioTecero,
    });
    Navigator.of(context).pop();
    setState(() {
      myControllerCantidad.clear();
      myControllerDescuentos.clear();
      _cantidadProducto = 1;
      totalPedido = valorTotal(_cartProductos);
      numeroAletra(totalPedido.toString());
    });
  }

  String valorTotal(List<dynamic> _cartProductos) {
    double total = 0.0;
    double total_descuento = 0.0;
    for (int i = 0; i < _cartProductos.length; i++) {
      double descuento = 0.0;
      double totalProducto = 0.0;

      totalProducto =
          _cartProductos[i]['precio'] * _cartProductos[i]['cantidad'];
      descuento = totalProducto * (_cartProductos[i]['total_dcto'] / 100);

      totalProducto = totalProducto - descuento;
      total_descuento = total_descuento + descuento;
      total = total + totalProducto;
    }
    totalDescuento = total_descuento.toStringAsFixed(2);
    print(total.toStringAsFixed(2));
    return total.toStringAsFixed(2);
  }

  void removeCarrito() {
    _cartProductos = [];
    totalPedido = '0.00';
    totalSubTotal = '0.00';
    totalDescuento = '0.00';
    numeroAletra('');
  }

  modalSinPedido() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            height: 210.0,
            width: 300.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Espera!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Debes asignar productos para \n realizar el pedido',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff0894FD),
                      fontSize: 18.0,
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
    final response = await http.post(
      Uri.parse('$_url/synchronization_pedido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, dynamic>{
        'pedidos': [
          {
            'nit': _nit,
            'id_tercero': '$id_tercero',
            "id_empresa": '$id_empresa',
            "id_sucursal": "01",
            "id_tipo_doc": idPedidoUser,
            "numero": '$_value_automatico',
            "id_sucursal_tercero": "1",
            "id_vendedor": "16499705",
            "id_suc_vendedor": '$id_suc_vendedor',
            "fecha": '$_selectedDate',
            "vencimiento": '$_selectedDate',
            "fecha_entrega": '$_selectedDate',
            "fecha_trm": '$_selectedDate',
            "id_forma_pago": '$_value_itemsFormaPago',
            "id_precio_item": '$listaPrecioTecero',
            "id_direccion": _value_DireccionMercancia,
            "id_moneda": "COLP",
            "trm": "1",
            "subtotal": '$totalSubTotal',
            "total_costo":
                double.parse(totalPedido) + double.parse(totalDescuento),
            "total_iva": "1900",
            "total_dcto": '$totalDescuento',
            "total": '$totalPedido',
            "total_item": "10000",
            "orden_compra": myControllerOrdenCompra.text,
            "estado": "PENDIENTE",
            "flag_autorizado": "SI",
            "comentario": "PRUEBA",
            "observacion": myControllerObservacion.text,
            "letras": _letras,
            "id_direccion_factura": _value_DireccionFactura,
            "usuario": _user,
            "id_tiempo_entrega": "22",
            "flag_enviado": "NO",
            "app_movil": true,
            "pedido_det": [
              for (var i = 0; i < _cartProductos.length; i++) ...[
                {
                  'nit': _nit,
                  'id_tercero': '$id_tercero',
                  "id_empresa": '$id_empresa',
                  "id_sucursal": "01",
                  "id_tipo_doc": idPedidoUser,
                  "numero": '$_value_automatico',
                  "consecutivo": i + 1,
                  "id_item": _cartProductos[i]['id_item'],
                  "descripcion_item": _cartProductos[i]['descripcion'],
                  "id_bodega": "01",
                  "cantidad": _cartProductos[i]['cantidad'],
                  "precio": _cartProductos[i]['precio'],
                  "precio_lista": "10000",
                  "tasa_iva": "19",
                  "total_iva": "1900",
                  "tasa_dcto_fijo": "0",
                  "total_dcto_fijo": "0",
                  "total_dcto": (_cartProductos[i]['precio'] *
                          _cartProductos[i]['cantidad']) *
                      (_cartProductos[i]['total_dcto'] / 100),
                  "costo": "7500",
                  "subtotal": _cartProductos[i]['precio'] *
                      _cartProductos[i]['cantidad'],
                  "total": (_cartProductos[i]['precio'] *
                          _cartProductos[i]['cantidad']) -
                      ((_cartProductos[i]['precio'] *
                              _cartProductos[i]['cantidad']) *
                          (_cartProductos[i]['total_dcto'] / 100)),
                  "total_item": "10000",
                  "id_unidad": "Und",
                  "cantidad_kit": "0",
                  "cantidad_de_kit": "0",
                  "recno": "0",
                  "id_precio_item": _cartProductos[i]['id_precio_item'],
                  "factor": "1",
                  "id_impuesto_iva": "IVA19",
                  "total_dcto_adicional": "0",
                  "tasa_dcto_adicional": "0",
                  "id_kit": "",
                  "precio_kit": "0",
                  "tasa_dcto_cliente": "0",
                  "total_dcto_cliente": "0"
                }
              ],
            ]
          }
        ]
      }),
    );

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 201 && success) {
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
                          setState(() {
                            _clientShow = true;
                            _productosShowCat = false;
                            _productosShow = false;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la creacion del pedido",
        ),
      );
    }
  }

  ///////////////////////////////////RECIBOS DE CAJA////////////////////
  ///
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

  Future<void> searchDocumentPend(data) async {
    final response =
        //   await http.get(Uri.parse("$_url/cuentaportercero/$_nit/$id_tercero"));
        await http.get(
            Uri.parse("$_url/cartera_recibo/$id_tercero/$id_sucursal_tercero"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      _dataDocumentPend = jsonResponse['data'];

      getConsecutivo(false);
      setState(() {
        _clientShow = false;
        _productosShow = false;
        _formRecipeShow = true;
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  //descuentos poara el recibo
  Future<void> searchConcepto() async {
    print("buscar lso descuentos");
    final response = await http.get(Uri.parse("$_url/concepto_all"));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      setState(() {
        _dataDescuento = jsonResponse['data'];
        _formNewClientShow = false;
        _formNewClientShowDescuento = true;
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
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
                width: _size.width * 0.5 - 42,
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
                      expresionRegular(double.parse(data['debito'].toString())),
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
                '${data['dias']}',
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
                '${data['dias']}',
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
                      setState(() {
                        _pay = false;
                        _confirm = true;
                        numeroAletra(myControllerValorPagoRecibo.text);
                        documentoPagar();
                      });
                    })),
          ],
        ),
      ],
    );
  }

  Widget confirm(BuildContext context, data, i) {
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
                '\$ ' +
                    expresionRegular(double.parse(restanteRecibo.toString())),
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
                '${data['dias']}',
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
                        _confirm = false;
                        _pay = true;
                        documentoPagarDelete();
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
    final _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
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
    print("asdasd asdasd asdasd asdasd asdasd  $i");
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Text(
              '${data['descripcion']}',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
                width: _size.width * 0.5 - 62,
                child: BtnSmall(
                    text: 'Agregar',
                    color: Color(0xff0894FD),
                    callback: () {
                      setState(() {
                        seeDescuento = true;
                        _isPagarDescuento = i;
                      });
                    })),
            SizedBox(
              width: 40.0,
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
          children: [
            Text(
              '${data['descripcion']}',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
            IconButton(
                onPressed: () {
                  print("eliminar producto del carrito");
                  //  _showDialog(context, i);
                  _showDialogDescuento(context, i);
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

        /*      Row(
              
                children: [ 
                  _itemForm(
                      context,
                      'Valor:',
                      '\$ ' +
                          expresionRegular(
                              double.parse(filterAbonoDescuento(i).toString())),
                      null,
                      false),
                ],
              ), */
      ],
    );
  }

  void _showDialogDescuento(BuildContext context, int index) {
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
                SizedBox(height: 20.0),
                Text(
                  '¿Desea eliminar el siguiente item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff06538D),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 30.0),
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
                            print("Aceptar $index");
                            _dataDescuentoAgregados.removeAt(index);
                            print("Aceptar $_dataDescuentoAgregados");
                            setState(() {
                              seeDescuento = false;
                              _isPagarDescuento = 99999;
                              totalReciboPagado =
                                  valorTotalRecibo(_documentosPagados);
                              //   numeroAletra(totalRecibo.toString());
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
    var restanteReciboUnico =
        double.parse(_dataDocumentPend[_isPagar]['debito'].toString()) -
            double.parse(myControllerValorPagoRecibo.text);

    var abonoReciboUnico = double.parse(myControllerValorPagoRecibo.text);

    print("restare del $restanteReciboUnico  $abonoReciboUnico $_isPagar");

    _documentosPagados.add({
      "id": _isPagar,
      "tipo_doc": _dataDocumentPend[_isPagar]['tipo_doc'],
      "numero": _dataDocumentPend[_isPagar]['numero'],
      "debito": _dataDocumentPend[_isPagar]['debito'],
      "credito": _dataDocumentPend[_isPagar]['credito'],
      "cuota": _dataDocumentPend[_isPagar]['cuota'],
      "dias": _dataDocumentPend[_isPagar]['dias'],
      "vencimiento": _dataDocumentPend[_isPagar]['vencimiento'],
      "id_sucursal": _dataDocumentPend[_isPagar]['id_sucursal'],
      "id_empresa": _dataDocumentPend[_isPagar]['id_empresa'],
      "monto_pagar": double.parse(abonoReciboUnico.toString()),
      "restante": restanteReciboUnico,
      "letras": _letras,
    });

    print("------recibos q se van a pagar----- $_documentosPagados");
    myControllerValorPagoRecibo.clear();
    setState(() {
      restanteRecibo = restanteReciboUnico.toStringAsFixed(2);
      abonoRecibo = abonoReciboUnico.toStringAsFixed(2);
      totalReciboPagado = valorTotalRecibo(_documentosPagados);
    });
  }

  //agregar carrito de recibo
  agregarDescuento() {
    var montoDescuento = double.parse(myControllerDescuentorec.text);

    _dataDescuentoAgregados.add({
      "id": _isPagarDescuento,
      "id_concepto": _dataDescuento[_isPagarDescuento]['id_concepto'],
      "monto_descontar": double.parse(montoDescuento.toString())
    });
    print("----------- $_dataDescuentoAgregados");
    myControllerDescuentorec.clear();
    setState(() {
      totalReciboPagado = valorTotalRecibo(_documentosPagados);
    });
  }

  //eliminar recibo del carrito de recibo
  documentoPagarDelete() {
    print("is pagar $_isPagar $_documentosPagados");
    _documentosPagados.removeAt(_isPagar);

    setState(() {
      totalReciboPagado = valorTotalRecibo(_documentosPagados);
    });
  }

  String valorTotalRecibo(List<dynamic> _documentosPagados) {
    double total = 0.0;

    double descuento = 0.0;
    for (int i = 0; i < _documentosPagados.length; i++) {
      total = total + _documentosPagados[i]['monto_pagar'];
      print(total);
    }
    for (int i = 0; i < _dataDescuentoAgregados.length; i++) {
      descuento = descuento + _dataDescuentoAgregados[i]['monto_descontar'];
      print(descuento);
    }
    numeroAletra(totalRecibo);
    setState(() {
      totalRecibo = total.toStringAsFixed(2);
      totalReciboDescuento = descuento.toStringAsFixed(2);
    });
    total = total - descuento;
    print(total.toStringAsFixed(2));
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
    print("createRecibo createRecibo   $_selectedDate");
    final response = await http.post(
      Uri.parse('$_url/synchronization_cuentaportercero'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, dynamic>{
        "cuentas_por_terceros": [
          for (var i = 0; i < _documentosPagados.length; i++) ...[
            {
              "nit": _nit,
              "id_empresa": id_empresa,
              "id_sucursal": "1",
              "tipo_doc": idReciboUser,
              "numero": _value_automatico,
              "cuota": _documentosPagados[i]['cuota'].toString(),
              "dias": _documentosPagados[i]['dias'].toString(),
              "id_tercero": id_tercero,
              "id_vendedor": "16499706",
              "id_sucursal_tercero": id_sucursal_tercero,
              "fecha":
                  '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
              "vencimiento":
                  '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
              "credito": _documentosPagados[i]['monto_pagar'].toString(),
              "dctomax": "0",
              "debito": "0",
              "id_destino": "0",
              "id_proyecto": "0",
              "id_empresa_cruce":
                  _documentosPagados[i]['id_empresa'].toString(),
              "id_sucursal_cruce":
                  _documentosPagados[i]['id_sucursal'].toString(),
              "tipo_doc_cruce": _documentosPagados[i]['tipo_doc'].toString(),
              "numero_cruce": _documentosPagados[i]['numero'].toString(),
              "cuota_cruce": _documentosPagados[i]['cuota'].toString(),
            },
          ]
        ],
      }),
    );

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 201 && success) {
      print("createRecibo");
      createReciboCartera();
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la creacion del recibo cuentas_por_tercero $msg",
        ),
      );
    }
  }

  Future createReciboCartera() async {
    print("createReciboCarteracreateReciboCarteracreateReciboCartera");
    late int cuota_cruce_cpd = 0;
    late int cuota = 1;
    late int conse = 0;
    numeroAletra(totalReciboPagado);
    final response = await http.post(
      Uri.parse('$_url/synchronization_carteraproveedores'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, dynamic>{
        'cartera_proveedores': [
          {
            "nit": _nit,
            "id_empresa": id_empresa,
            "id_sucursal": "1",
            "id_tipo_doc": idReciboUser,
            "numero": _value_automatico,
            "fecha":
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            "total": totalReciboPagado,
            "vencimiento":
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            "letras": _letras,
            "id_moneda": "COLP",
            "id_tercero": id_tercero,
            "id_sucursal_tercero": id_sucursal_tercero,
            "id_recaudador": "0",
            "fecha_trm":
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
            "trm": "1",
            "observaciones": myControllerObservacion.text,
            "usuario": _user,
            "flag_enviado": " ",
            "cartera_proveedores_det": [
              {
                "consecutivo": conse = conse + 1,
                "cuota": cuota = cuota + 1,
                "id_tercero": id_tercero,
                "id_sucursal_tercero": id_sucursal_tercero,
                "id_empresa_cruce":
                    _documentosPagados[0]['id_empresa'].toString(),
                "id_sucursal_cruce":
                    _documentosPagados[0]['id_sucursal'].toString(),
                "id_tipo_doc_cruce": idReciboUser,
                "numero_cruce": _value_automatico,
                "fecha":
                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                "vencimiento":
                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                "debito": totalReciboPagado,
                "credito": "0",
                "descripcion": _value_itemsTipoPago == '01'
                    ? 'Pago en Efectivo por el valor de $totalReciboPagado '
                    : ' ',
                "id_vendedor": "6220948",
                "id_forma_pago": _value_itemsTipoPago,
                "documento_forma_pago": "",
                "distribucion": "FP",
                "trm": "1",
                "id_recaudador": "6220948",
                "id_suc_recaudador": "1",
                "fecha_trm":
                    '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                "total_factura": "0",
                "id_concepto": "",
                "id_moneda": "COLP",
                "id_destino": "",
                "id_proyecto": "",
                "cuota_cruce": cuota_cruce_cpd = cuota_cruce_cpd + 1,
                "id_banco": _value_itemsBanco
              },
              for (var i = 0; i < _documentosPagados.length; i++) ...[
                {
                  "consecutivo": conse = conse + 1,
                  "cuota": cuota =
                      int.parse(_documentosPagados[i]['cuota'].toString()),
                  "id_tercero": id_tercero,
                  "id_sucursal_tercero": id_sucursal_tercero,
                  "id_empresa_cruce":
                      _documentosPagados[i]['id_empresa'].toString(),
                  "id_sucursal_cruce":
                      _documentosPagados[i]['id_sucursal'].toString(),
                  "id_tipo_doc_cruce": _documentosPagados[i]['tipo_doc'],
                  "numero_cruce": _documentosPagados[i]['numero'],
                  "fecha":
                      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                  "vencimiento": _documentosPagados[i]['vencimiento'],
                  "debito": '0',
                  "credito": _documentosPagados[i]['monto_pagar'],
                  "descripcion": ' Abonó el documento',
                  "id_vendedor": "6220948",
                  "id_forma_pago": "",
                  "documento_forma_pago": "",
                  "distribucion": "DC",
                  "trm": "1",
                  "id_recaudador": "6220948",
                  "id_suc_recaudador": "1",
                  "fecha_trm":
                      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                  "total_factura": "0",
                  "id_concepto": "",
                  "id_moneda": "COLP",
                  "id_destino": "",
                  "id_proyecto": "",
                  "cuota_cruce": cuota_cruce_cpd =
                      int.parse(_documentosPagados[i]['cuota'].toString()),
                  "id_banco": _value_itemsBanco
                },
           
                for (var i = 0; i < _dataDescuentoAgregados.length; i++) ...[
                  {
                    "consecutivo": conse = conse + 1,
                    "cuota": 3,
                    "id_tercero": id_tercero,
                    "id_sucursal_tercero": id_sucursal_tercero,
                    "id_empresa_cruce":
                        _documentosPagados[i]['id_empresa'].toString(),
                    "id_sucursal_cruce": "1",
                    "id_tipo_doc_cruce": idReciboUser,
                    "numero_cruce": _value_automatico,
                    "fecha":
                        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                    "vencimiento": _documentosPagados[i]['vencimiento'],
                    "debito": _dataDescuentoAgregados[i]['monto_descontar'],
                    "credito": "0",
                    "descripcion":
                        'Pago de descuento ${_dataDescuentoAgregados[i]['monto_descontar']} ',
                    "id_vendedor": "6220948",
                    "id_forma_pago": '',
                    "documento_forma_pago": "",
                    "distribucion": "CN",
                    "trm": "1",
                    "id_recaudador": "6220948",
                    "id_suc_recaudador": "1",
                    "fecha_trm":
                        '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                    "total_factura": "0",
                    "id_concepto": _dataDescuentoAgregados[i]['id_concepto'],
                    "id_moneda": "COLP",
                    "id_destino": "",
                    "id_proyecto": "",
                    "cuota_cruce": cuota_cruce_cpd = cuota_cruce_cpd + 1,
                    "id_banco": _value_itemsBanco
                  }
                ]
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
      _body = {
        'nit': _nit,
        'id_tipo_doc': idReciboUser,
        'consecutivo': _value_automatico,
      };
      final response = await http
          .post(Uri.parse("$_url/consecutivo_recibo_app"), body: (_body));
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var success = jsonResponse['success'];

      if (response.statusCode == 200 && success) {
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
                      'Creación de recibo exitoso',
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
                            setState(() {
                              _clientShow = true;
                              _productosShowCat = false;
                              _productosShow = false;
                              _formNewClientShowDescuento = false;
                              _formNewClientShow = false;
                            });
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
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Error en la creacion del recibo",
        ),
      );
    }
  }

  /////api
  Future<void> numeroAletra(String numero) async {
    final response = await http.get(
      Uri.parse(
          'https://numeros-a-letras1.p.rapidapi.com//api/NAL/?num=$numero'),
      // Send authorization headers to the backend.
      headers: <String, String>{
        'X-RapidAPI-Key': "3e8840a8ebmsh4150b6af5da1551p196300jsn0ea9a90219af",
        'X-RapidAPI-Host': "numeros-a-letras1.p.rapidapi.com"
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        _letras = jsonResponse['letras'];
      });
      print("asdasd $_letras");
    }
  }
}
