import 'package:pony_order/@presentation/components/btnForm.dart';
import 'package:pony_order/@presentation/components/inputCallback.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderEdit.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderHistoryRecibo.dart';
import 'package:pony_order/@presentation/components/itemClient.dart';
import 'package:pony_order/@presentation/components/itemProductOrder.dart';
import 'package:pony_order/@presentation/components/itemProductOrderHistory.dart';
//import 'package:app_pony_order/@presentation/components/itemUnits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';

class UnitsPage extends StatefulWidget {
  @override
  _UnitsPageState createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  bool _clientShow = false;
  bool _formShow = false;
  bool _formOrderShow = false;
  bool _formRecipeShow = false;
  bool _formHistoryShow = false;
  bool _checkedCartera = true;
  bool _checkedPedido = false;
  bool _checkedRecibo = false;
  bool? _checked = false;

  bool isOnline = true;
  bool _isLoading = false;
  String _nit = '900054835';
  String _url = 'http://10.0.2.2:3000';
 // String _url = 'http://localhost:3000';
  bool focus = false;

  late int _countClasificacion;
  late Object _body;
  List<dynamic> _datClasificacionProductos = [];
  late String _searchProducto = '@';
  late int _countProductos = 0;
  List<dynamic> _datProductos = [];
  late String idClasificacion = '01';
  final myControllerSearch = TextEditingController();

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();
  //api

  @override
  void initState() {
    super.initState();
    print("----------iniciando");
    searchClasificacionProductos();
  }

  Future<void> searchClasificacionProductos() async {
    print("searchClasificacionProductos------------------------------ ");
    _body = {
      'nit': _nit,
      'nombre': '@',
    };
    final response = await http.post(Uri.parse("$_url/clasificacion_productos"),
        body: (_body));
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
          _clientShow = true;
          _clientShow
              ? _client(context, _datClasificacionProductos)
              : Container();
          searchProductos();
        }
      });
    } else {
         showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
   /*    print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));*/
    } 
  }

  Future<void> searchProductos() async {
    print("searchProductos------------------------------ $idClasificacion ");
    _body = {
      'nit': _nit,
      'id_clasificacion': '$idClasificacion',
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
        if (_countProductos > 0) {
          print("mosrtart los productos $_datProductos");
          _clientShow = true;
          _clientShow ? _client(context, _datProductos) : Container();
        }
      });
    } else {
   /*    print(
          "Wronggooooooooooooooooooooooooooo Wronggooooooooooooooooooooooooooo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg"))); */
     showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );
    }
  }

  /// This implementation is just to simulate a load data behavior
  /// from a data base sqlite or from a API
  ///
  /////api
  Future getItemTypeIdentication() async {
    //calisifacionde item
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
   /*    print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg"))); */
    }
  }

  // Perform login
  void validateAndSubmit() {
    print('Entrando a buscar productos con la clasificacion $idClasificacion');
    _searchProducto = myControllerSearch.text;
    setState(() {
      print("buscar produxtos $_searchProducto");
      _isLoading = true;
      searchProductos();
    });
  }

  //vistas
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
          endDrawer: _shoppingCart(context),
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
                          _formShow ||
                                  _formOrderShow ||
                                  _formRecipeShow ||
                                  _formHistoryShow
                              ? Container()
                              : Column(
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
                                    InputCallback(
                                        hintText: 'Ingrese nombre de sección',
                                        iconCallback: Icons.search,
                                        callback: () => {
                                              setState(() {
                                                _clientShow = true;
                                              })
                                            }),
                                  ],
                                ),
                          SizedBox(height: 10.0),
                          _clientShow ? _client(context, null) : Container(),
                          _formShow ? _form(context) : Container(),
                          _formOrderShow ? _formOrder(context) : Container(),
                          _formRecipeShow ? _formRecipe(context) : Container(),
                          _formHistoryShow
                              ? _formHistory(context)
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

  Widget itemUnits(BuildContext context, String idItem, String descripcion,
      String inventario) {
    final _size = MediaQuery.of(context).size;
    return Column(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                descripcion,
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                    child: Text(inventario,
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
                      color: i == 0 ? Color(0xff06538D) : Color(0xff0894FD)),
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
                          idClasificacion =
                              '${_datClasificacionProductos[i]['id_clasificacion']}';
                          print(
                              "----------filtrar por categoria $idClasificacion");
                          validateAndSubmit();
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
        for (var i = 0; i < _countProductos; i++) ...[
          SizedBox(height: 10.0),
          itemUnits(
              context,
              '${_datProductos[i]['id_item']}',
              '${_datProductos[i]['descripcion']}',
              '${_datProductos[i]['saldo_inventario']} - UND '),

          //   '${_datProductos[i]['saldo_inventario']} - UND ${_datProductos[i]['id_unidad_compra']}'),
        ],
      ],
    );
  }

  Widget _shoppingCart(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: _size.width,
        height: _size.height,
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
                Text('Juan Pablo Jimenez',
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
                /*    InputCallback(
                    hintText: 'Buscar producto',
                    iconCallback: Icons.search,
                    callback: () => {}), */
                TextField(
                  controller: myControllerSearch,
                  decoration: InputDecoration(
                    hintText: 'Buscar producto',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(top: 20, bottom: 0, left: 15.0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Color(0xff0f538d),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          BorderSide(color: Color(0xffc7c7c7), width: 1.2),
                    ),
                    suffixIcon: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17.0, right: 12.0),
                        child: Icon(
                          Icons.search,
                          color: focus ? Color(0xff0f538d) : Color(0xffc7c7c7),
                        ),
                      ),
                      onTap: validateAndSubmit,
                    ),
                    hintStyle:
                        TextStyle(fontSize: 16.0, color: Color(0xffc7c7c7)),
                    labelStyle: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15,
                        color: Colors.black),
                    alignLabelWithHint: true,
                  ),
                ),
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
                      onTap: () => {},
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
                      ItemCategoryOrderEdit(),
                      SizedBox(height: 10.0),
                      ItemCategoryOrderEdit(),
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
                        '\$ 0',
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
                              onTap: () {},
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
                              onTap: () {},
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
            'Jiménez Pérez Juan Pablo',
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
                      child: Text('123456789',
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
                      child: Text('7661231231',
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
      height: 40.0,
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

  Widget _formRecipe(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clientes / Nuevo reciboo',
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(height: 20.0),
        _itemForm(context, 'Recibo N°', '14408'),
        _itemSelectForm(context, 'Fecha', '12/10/21', 'Selecciona fecha'),
        _itemForm(context, 'Nombre', 'Jiménez Pérez Juan Pablo'),
        _itemForm(context, 'Total cartera', '22554'),
        _itemSelectForm(
            context, 'Banco', 'Banco de occidente', 'Selecciona fecha'),
        _itemSelectForm(context, 'N° cheque', '', 'Selecciona fecha'),
        SizedBox(height: 30.0),
        Container(width: _size.width, height: 1.0, color: Color(0xffC7C7C7)),
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
                          _formRecipeShow = false;
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
                      onTap: () {},
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(height: 10.0)
      ],
    );
  }

  Widget _formOrder(BuildContext context) {
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
        _itemForm(context, 'Pedido', 'Automático'),
        _itemSelectForm(context, 'Fecha', '12/10/21', 'Selecciona fecha'),
        _itemForm(context, 'Nombre', 'Jiménez Pérez Juan Pablo'),
        _itemSelectForm(context, 'Dir. envío factura', 'Cr 74 # 37 - 38',
            'Selecciona fecha'),
        _itemSelectForm(context, 'Dir. envío mercancía', 'Cr 74 # 37 - 38',
            'Selecciona fecha'),
        _itemForm(context, 'Orden de compra', ''),
        _itemSelectForm(context, 'Forma de pago', '7 días', 'Selecciona fecha'),
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
        _itemForm(context, 'Cupo crédito', '1.200.000'),
        _itemSelectForm(
            context, 'Total cartera', '347.281', 'Selecciona fecha'),
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
                      onTap: () {},
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
        _itemSelectForm(context, 'Tipo de documento', 'Cédula de identidad',
            'Seleccione su tipo de documento'),
        _itemForm(context, 'N° de documento', '7213123'),
        _itemForm(context, 'DV.', 'PersonaNatural'),
        _itemForm(context, 'Primer nombre', 'Juan'),
        _itemForm(context, 'Segundo nombre', 'Pablo'),
        _itemForm(context, 'Primer apellido', 'PersonaNatural'),
        _itemForm(context, 'Segundo apellido', 'Pérez'),
        _itemForm(context, 'Razón social', ''),
        _itemForm(context, 'Dirección', ''),
        _itemForm(context, 'Email', ''),
        _itemForm(context, 'Teléfono fijo', ''),
        _itemSelectForm(context, 'Clasificación', 'Persona natural',
            'Seleccione su medio de contacto'),
        _itemSelectForm(context, 'Medio contacto', 'Tienda',
            'Seleccione clasificación de persona'),
        _itemSelectForm(
            context, 'Zona', 'Cali', 'Seleccione la zona de residencia'),
        _itemSelectForm(context, 'Departamento', 'Valle del cauca',
            'Seleccione su departamento'),
        _itemSelectForm(context, 'Ciudad', 'Cali', 'Seleccione su ciudad'),
        _itemSelectForm(
            context, 'Barrio', '7 de agosto', 'Seleccione su barrio'),
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
                        showDialog<String>(
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
                        );
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

  Widget _itemForm(BuildContext context, String label, String hintText) {
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
                color: Color(0xff06538D),
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
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
                    // showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => Dialog(
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(10.0))),
                    //       child: Container(
                    //         height: 333.0,
                    //         width: _size.width * 0.7,
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 20.0, vertical: 15.0),
                    //         child: Column(
                    //           children: [
                    //             SizedBox(height: 10.0),
                    //             Text(
                    //               title,
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                   color: Color(0xff06538D),
                    //                   fontSize: 22.0,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //             SizedBox(height: 30.0),
                    //             CheckboxListTile(
                    //                 title: Text('DNI'),
                    //                 value: this._checked,
                    //                 onChanged: (bool? value) {
                    //                   setState(() {
                    //                     print(value);
                    //                     this._checked = value;
                    //                   });
                    //                 }),
                    //             CheckboxListTile(
                    //                 title: Text('DNI'),
                    //                 value: this._checked,
                    //                 onChanged: (bool? value) {
                    //                   setState(() {
                    //                     print(value);
                    //                     this._checked = value;
                    //                   });
                    //                 }),
                    //             CheckboxListTile(
                    //                 title: Text('DNI'),
                    //                 value: this._checked,
                    //                 onChanged: (bool? value) {
                    //                   setState(() {
                    //                     print(value);
                    //                     this._checked = value;
                    //                   });
                    //                 }),
                    //             Container(
                    //               width: _size.width,
                    //               height: 41.0,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   color: Color(0xff0894FD)),
                    //               child: Material(
                    //                 color: Colors.transparent,
                    //                 child: InkWell(
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                   child: Center(
                    //                     child: Text(
                    //                       'Aceptar',
                    //                       style: TextStyle(
                    //                           color: Colors.white,
                    //                           fontSize: 18,
                    //                           fontWeight: FontWeight.w700),
                    //                     ),
                    //                   ),
                    //                   onTap: () {
                    //                     Navigator.pop(context);
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )),
                    // );
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
}
