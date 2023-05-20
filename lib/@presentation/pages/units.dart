import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../db/operationDB.dart';


class UnitsPage extends StatefulWidget {
  @override
  _UnitsPageState createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  bool _clientShow = false;
  late int _checked = 0;
  bool _isConnected = true;
  bool focus = false;
  late String _search = '@';
  //usuario login
  String _user = '';
  String _nit = '';

  late int _countProductos = 0;
  List<dynamic> _datProductos = [];
  final myControllerSearch = TextEditingController();
  final myControllerBuscarProd = TextEditingController();
  final myControllerBuscarCatego = TextEditingController();

  //CARRITO
  late String nombre_tercero = '';
  List<dynamic> _cartProductos = [];
  bool _formShowCategories = false;
  bool _productosShowCat = false;

  late String id_tercero = '';
  String idPedidoUser = '';
  String id_vendedor = '';
  late String _value_itemsListPrecio = '';
  late String _itemSelect = '';
  late double _precio = 0;
  late double _descuento = 0;
  late double limiteCreditoTercero = 0;
  late String listaPrecioTercero = '';
  late String _value_automatico = ''; //numero de pedido
  late String id_empresa = '';
  late String id_suc_vendedor = '';
  List<dynamic> _datClasificacionProductos = [];
  late int _countClasificacion = 0;

  late int _countClasificacionNivel = 0;
  List<dynamic> _datClasificacionProductosNivel = [];
  late String idClasificacion = '01';
  late String _id_padre = '-';
  late String totalPedido = '0.00';
  late String totalSubTotal = '0.00';
  late String totalDescuento = '0.00';
  late String _letras = '';
  String _value_itemsFormaPago = '';
  int _cantidadProducto = 1;
  late String id_direccion = '';
  late String id_direccion_factura = '';
  String fecha_pedido = '';
  late String id_tipo_pago = '';

  //variables de pedidos
  bool selectItem = false;
  final myControllerNroPedido = TextEditingController();
  final myControllerDescuentos = TextEditingController(text: "0");
  final myControllerObservacion = TextEditingController();
  final myControllerCantidad = TextEditingController(text: "1");
  final myControllerOrdenCompra = TextEditingController();
  final myControllerCantidadCart = TextEditingController();
  late String _fecha = '';
  late DateTime _selectedDate = DateTime.now();

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();
  //api

  @override
  void initState() {
    _fecha = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    super.initState();
    _loadDataUserLogin();
  }

  _loadDataUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('user') ?? '');
      _nit = (prefs.getString('nit') ?? '');
      idPedidoUser = (prefs.getString('idPedidoUser') ?? '');
      id_vendedor = (prefs.getString('id_vendedor') ?? '');
      if (_nit != '') {
        searchClasificacionProductos('2', '', false);
      }

    });
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
      _showBarMsg('Error', false);
    }
  }

  String expresionRegular(double numero) {
    NumberFormat f = new NumberFormat("###,###,###.00#", "es_US");
    String result = f.format(numero);
    return result;
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

  Future<void> searchClasificacionProductos(
      String nivel, String id_padre, bool pedido) async {
    _search = myControllerBuscarCatego.text.isNotEmpty
        ? myControllerBuscarCatego.text.trim().trim()
        : '@';

    var data = await OperationDB.getClasificacionProductos(
        _nit, nivel, id_padre, pedido, _search);
    if (data != false) {
      _datClasificacionProductos = data;
      _countClasificacion = data.length;
      setState(() {
        if (_countClasificacion > 0) {
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
          if (!pedido) {
            idClasificacion = '${_datClasificacionProductos[0]['id_padre']}';

            searchProductos();
            _formShowCategories = false;
            _clientShow = true;
            _clientShow
                ? _client(context, _datClasificacionProductos)
                : Container();
          } else {
            _clientShow = false;
            _formShowCategories = true;
            getListPrecio();
          }
        }
      });
    } else {
      _showBarMsg('ERROR SCP', false);
    }
  }

  Future<void> searchProductos() async {
    final _search = myControllerSearch.text.isNotEmpty
        ? myControllerSearch.text.trim()
        : '@';

    final data = await OperationDB.getItemsAllUnit(id_vendedor,_nit, idClasificacion, _fecha,_search);
    if (data != false) {
      _datProductos = data;
      _countProductos = _datProductos.length;

      setState(() {
        if (_datProductos.isNotEmpty) {
          _clientShow = true;
          _clientShow ? _client(context, _datProductos) : Container();
        }
      });
    } else {
      setState(() {
        _countProductos = 0;
        _datProductos = [];
      });
    }
  }


  Future<bool> _onWillPop() async {
    if (_drawerscaffoldkey.currentState!.isDrawerOpen && _nit != '') {
      Navigator.pop(context);
      return false;
    }
    return false;
  }

  //vistas
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
          title: Text(
            'Unidades',
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
          body: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Column(
                        children: [
                          _clientShow
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Búsqueda de unidades de productos',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff0f538d),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextField(
                                      controller: myControllerSearch,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (String str) {
                                        setState(() {
                                          searchProductos();
                                        });
                                      },
                                      onChanged: (text) {
                                        if (text.isEmpty) {
                                          searchProductos();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Ingrese nombre del producto',
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
                                          onTap: searchProductos,
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
                                    ),
                                  ],
                                )
                              : SizedBox(height: 2.0),
                          SizedBox(height: 10.0),
                          _clientShow ? _client(context, null) : Container(),
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

  Widget InputCallbackf(
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
          onChanged: (text) {
            if (text.isEmpty) {
              callback();
            }
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

  Widget itemUnits(BuildContext context, String idItem, String descripcion,
      String cantidad) {

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
                color: Color.fromARGB(255, 194, 198, 200)),
            width: _size.width,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 16.0,
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
                      child: Text(idItem,
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
                      child: Text(cantidad,
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _client(BuildContext context, data) {
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
              for (var i = 0; i < _countClasificacion; i++) ...[
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
                            '${_datClasificacionProductos[i]['descripcion']}',
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
                              '${_datClasificacionProductos[i]['id_padre']}';
                          searchProductos();
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
        Text('Se encontraron $_countProductos productos',
            style: TextStyle(
                color: Color(0xff0f538d),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic)),
        SizedBox(height: 10.0),
        SizedBox(
          height: _size.height - 300,
          child: ListView(
            children: [
              for (var i = 0; i < _countProductos; i++) ...[
                itemUnits(
                    context,
                    '${_datProductos[i]['id_item']}',
                    '${_datProductos[i]['descripcion']}',
                    '${_datProductos[i]['cantidad']} - ${_datProductos[i]['id_unidad_compra']}'),
                SizedBox(height: 5.0),
              ],
            ],
          ),
        ),
      ],
    );
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
                child: ListTile(
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
                  onTap: () => Navigator.pushNamed(context, 'home'),
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
                child: const ListTile(
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
}
