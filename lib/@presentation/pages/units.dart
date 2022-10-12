import 'package:pony_order/@presentation/components/inputCallback.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderEdit.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderHistoryRecibo.dart'; 
import 'package:pony_order/@presentation/components/itemProductOrder.dart';
import 'package:pony_order/@presentation/components/itemProductOrderHistory.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
 

class UnitsPage extends StatefulWidget {
  @override
  _UnitsPageState createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  bool _clientShow = false;  
  late int _checked =0;

  bool isOnline = true;
  bool _isLoading = false;
 
    String _url = 'http://178.62.80.103:5000';
 // String _url = 'http://10.0.2.2:3000';
  bool focus = false;
  //usuario login
  String _user = '';
  String _nit = ''; 


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
     _loadDataUserLogin();   
  }


  _loadDataUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('user') ?? '');
      _nit = (prefs.getString('nit') ?? '');
      print("el usuario es $_user $_nit");
      if (_nit != '') {
         searchClasificacionProductos();
      }
    });
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
    } 
  }

  Future<void> searchProductos() async {
    print("searchProductos------------------------------ $idClasificacion ");
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
        if (_datProductos.isNotEmpty) {
          print("mosrtart los productos $_datProductos");
          _clientShow = true;
          _clientShow ? _client(context, _datProductos) : Container();         
        } 
      });
    } else {    
       setState(() { 
      _countProductos = 0;
      _datProductos = [];  
          });
     showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: msg,
        ),
      );    
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
                           Column(
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
                      color: i == _checked? Color(0xff06538D) : Color(0xff0894FD)),
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
                  minLeadingWidth: 20,
                  leading: const Icon(
                    Icons.remove_red_eye,
                    color: Color(0xff767676),
                    size: 28.0,
                  ),
                  title: Text(
                    'Sincronizacion',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff767676)),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'data'),
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
   
 
}
