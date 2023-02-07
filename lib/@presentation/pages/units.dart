import 'package:pony_order/@presentation/components/inputCallback.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart'; 
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../httpConexion/validateConexion.dart';
import '../../Common/Constant.dart';
import '../../db/operationDB.dart';
import '../../models/pedido.dart';

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
  final myControllerBuscarCatego= TextEditingController();

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
  late String id_direccion ='';
  late String id_direccion_factura ='';
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
 
  late DateTime _selectedDate = DateTime.now();

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();
  //api

  @override
  void initState() {
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
        searchClasificacionProductos('2','',false);
      }
        ObtieneCarrito();
    });
  }

  late List<Map<String, dynamic>> itemsListPrecio = [];
  Future  getListPrecio() async {
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
  Future<void> searchClasificacionProductos( String nivel,String id_padre, bool pedido) async {
    _search =  myControllerBuscarCatego.text.isNotEmpty ? myControllerBuscarCatego.text.trim().trim() :'@';


      var data= await  OperationDB.getClasificacionProductos(_nit,nivel,id_padre,pedido,_search);
      if (data != false) {  
       _datClasificacionProductos = data;
      _countClasificacion = data.length;
      setState(() {
        if (_countClasificacion > 0) {        
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
              if(!pedido){
                idClasificacion =
                '${_datClasificacionProductos[0]['id_padre']}';


                searchProductos();
                _formShowCategories = false;
                _clientShow = true;
                _clientShow
                    ? _client(context, _datClasificacionProductos)
                    : Container();

              } else {


                 _clientShow = false;
                 _formShowCategories = true;
                _formShowCategories
                  ? _formCategories(context, _datClasificacionProductos)
                  : Container();
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

    final data = await OperationDB.getItemsAll(_nit, idClasificacion, _search);
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
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "No existen registros",
        ),
      );
    }
  }

  Future<void> searchProductosPedido() async {
    final _search = myControllerBuscarProd.text.isNotEmpty
        ? myControllerBuscarProd.text.trim()
        : '@';
    var data = await OperationDB.getItems(_nit, idClasificacion,_search,listaPrecioTercero);
    if (data != false) {
      setState(() {
        _datProductos = data;
        _countProductos = data.length; 
        _clientShow  = false;
        _formShowCategories = false;
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
        _descuento = double.parse(data[0]['descuento_maximo']);
      });
    } else {
      showTopSnackBar(
        context,
        animationDuration: const Duration(seconds: 1),
        CustomSnackBar.error(
          message: "No se obtuvo el precio de este producto",
        ),
      );
    }
  }

  Future<void> selectProductoNivel() async {
    String _search = '@';
    var data =
        await OperationDB.getClasificacionProductos(_nit, '2',_id_padre,true,_search);
    if (data != false) {
      _datClasificacionProductosNivel = data;
      _countClasificacionNivel = data.length;
      setState(() {
       /* idClasificacion =
            '${_datClasificacionProductosNivel[0]['id_clasificacion']}';*/
        idClasificacion =
        '${_datClasificacionProductosNivel[0]['id_padre']}';
        searchProductosPedido();
      });
    } else {
      showTopSnackBar(
        context,
        animationDuration: const Duration(seconds: 1),
        CustomSnackBar.error(message: "ERROR SPN2"),
      );
    }
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
            badges.Badge(
              badgeContent: Text((_cartProductos.length).toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              child: GestureDetector(
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
              position: badges.BadgePosition.topEnd(top: -5, end: 45),

            ),
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
          endDrawer: _shoppingCart(context, _cartProductos, _cartProductos.length),
          body: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
              Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child:Column(
                        children:  [
                     _clientShow ?   Column(
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
                                   onSubmitted: (String str){
                                     setState((){
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
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Color(0xff0f538d),
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                          color: Color(0xffc7c7c7), width: 1.2),
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
                                        fontSize: 16.0, color: Color(0xffc7c7c7)),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 15,
                                        color: Colors.black),
                                    alignLabelWithHint: true,
                                  ),
                                ),                         
                            ],
                          )  :   SizedBox(height: 2.0),
                          SizedBox(height: 10.0),
                          _clientShow ? _client(context, null) : Container(),
                           _formShowCategories
                              ? _formCategories(
                                  context, _datClasificacionProductos)
                              : Container(),
                          _productosShowCat
                              ? _shoppingCat(context, idClasificacion)
                              : Container(),
                        ],
                      ) ,
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
                      'Nuevo Pedido  ',
                      style: TextStyle(
                          color: Color(0xff0f538d),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Text('$nombre',
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
                            searchProductosPedido();
                          })
                        },
                    controller: myControllerBuscarProd),
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
                            _clientShow  = false;
                            _productosShowCat = false;  
                            _formShowCategories = true;
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
                                      searchClasificacionProductos('2','-',false);
                                 _productosShowCat = false;  
                                 _formShowCategories = false;
                                _clientShow  = true;
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
                              color:  _cartProductos.length > 0  
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
                                    ? editarPedido()
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
                  //
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
                        /*  idClasificacion =
                              '${_datClasificacionProductosNivel[i]['id_clasificacion']}';*/
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
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                  //  AssetImage('assets/images/${data[i]['descripcion']}.png'),
                  AssetImage('assets/images/producto-sin-imagen.png'),
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
                      child: Text('${data[i]['descripcion']}',
                        style: TextStyle(color: Colors.blue,
                            fontSize: 14),),
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
  Widget _ItemProductosOld(data) {
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
                  image:
                    //  AssetImage('assets/images/${data[i]['descripcion']}.png'),
                  AssetImage('assets/images/producto-sin-imagen.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                //idClasificacion = '${data[i]['id_clasificacion']}';
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

  Widget InputCallbackf(BuildContext context,hintText,iconCallback,callback,controller) {
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
            if(text.isEmpty){
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
                if( controller.text.isNotEmpty){
                  callback();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 17.0, right: 12.0),
                child: Icon( iconCallback,
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
                  items: itemsListPrecio,
                  initialValue: listaPrecioTercero,
                  onChanged: (val) => setState(() => {
                    _value_itemsListPrecio = val,
                    if (_value_itemsListPrecio !='0')
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
                          (_itemSelect == data['id_item'])
                              ? '\$ ' + expresionRegular(_precio)
                              : '\$ ' + expresionRegular(double.parse(data['precio'].toString())),
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
                      child: Text(
                          expresionRegular(double.parse(saldo.toString())),
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
                      width: 120.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: (_itemSelect == data['id_item'] && _precio > 0  )  && !validExistCarrito(data['id_item'])
                              || (_itemSelect != data['id_item'] && double.parse(data['precio'].toString()) > 0 )
                                  && !validExistCarrito(data['id_item'])
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
                          onTap: (_itemSelect == data['id_item'] && _precio > 0  ) || (_itemSelect != data['id_item'] && double.parse(data['precio'].toString()) > 0 )
                              ? () {

                              if (validExistCarrito(data['id_item'])) {
                                _showBarMsg('Este producto ya existe en el carrito', false);
                              }else {

                              if(_itemSelect != data['id_item'] && double.parse(data['precio'].toString()) > 0 ) {
                                _precio = double.parse(data['precio'].toString());
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
        "id_precio_item": _value_itemsListPrecio != ''
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

  Future<void> ObtieneCarrito() async {
    final data =
        await OperationDB.getCarrito(_nit, id_tercero, _value_automatico);
    if (data != false) {
      _cartProductos =
          (data as List).map((dynamic e) => e as Map<String, dynamic>).toList();

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
    setState(()   {
      totalPedido =  valorTotal();
    });

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
        id_direccion: id_direccion,
        subtotal: '$totalSubTotal',
        total_costo: totalCosto.toString(),
        total_dcto: '$totalDescuento',
        total: '$totalPedido',
        orden_compra: myControllerOrdenCompra.text.trim(),
        observacion: 'CARRITO',
        letras: _letras,
        id_direccion_factura: id_direccion_factura,
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
      totalProducto =   double.parse(_cartProductos[i]['total'].toString());
      descuento = double.parse(_cartProductos[i]['total_dcto'].toString()) ;

      totalProducto = totalProducto - descuento;
      total_descuento = total_descuento + descuento;
      total = total + totalProducto;
    }
    totalDescuento = total_descuento.toStringAsFixed(2);
    totalPedido = total.toStringAsFixed(2);

    return total.toStringAsFixed(2);
  }

 void removeCarrito() async {
    OperationDB.deleteCarrito();
    _cartProductos = []; 
    totalPedido = '0.00';
    totalSubTotal = '0.00';
    totalDescuento = '0.00';
    totalPedido = valorTotal();
    _letras = '';
    Navigator.pushNamed(context, 'units');
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
                  '¡Espera!',
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
  
  void _showDialog(BuildContext context, int index,bool car) {
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
                            setState(() {
                              OperationDB.deleteProductoCarrito(
                                  _cartProductos[index]['id_item']);
                              _cartProductos.removeAt(index);
        
                              totalPedido = valorTotal();
                            //   numeroAletra(totalPedido.toString());
                            });
                            sendCarritoBD();
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
   late String orden_compra = '';
   late String id_sucursal_tercero = '';



  Future editarPedido() async {
    var data1 = await OperationDB.getidSuc(id_tercero, _nit);
    if (data1 != false) {
      setState(() {
        id_sucursal_tercero = data1[0]['id_sucursal_tercero'].toString();
        id_suc_vendedor = data1[0]['id_suc_vendedor'].toString();
      });
    }

    await numeroAletra(totalPedido.toString());
    _submitDialog(context);
    final val = await validateConexion.checkInternetConnection();
    setState(() {
      _isConnected = val!;      
    });

    late int conse = 0;
    final total_costo =
        double.parse(totalPedido) + double.parse(totalDescuento);
    var flag_pedido = false;
    var flag_pedido_det = false;

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
        id_sucursal_tercero: '$id_sucursal_tercero',
        id_vendedor: id_vendedor,
        id_suc_vendedor: id_suc_vendedor,
        fecha: '$fecha_final',
        vencimiento: '$fecha_final',
        fecha_entrega: '$fecha_final',
        fecha_trm: '$fecha_final',
        id_forma_pago: '$_value_itemsFormaPago',
        id_precio_item: '$listaPrecioTercero',
        id_direccion: '$id_direccion',
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
        id_direccion_factura: '$id_direccion_factura',
        usuario: _user,
        id_tiempo_entrega: "0",
        flag_enviado: "NO");

    flag_pedido = await OperationDB.insertPedido(nuevo_pedido,true);
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
          consecutivo: conse = conse + 1,
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

      flag_pedido_det = await OperationDB.insertPedidoDet(nuevo_pedido_det,true);
    }
    if (flag_pedido && flag_pedido_det) {
      await OperationDB.updateConsecutivo(int.parse(_value_automatico),_nit,idPedidoUser,id_empresa);
      Navigator.pop(context);
      _isConnected ? await edicionPedidoAPI() : modalExitosa();
    } else {
      _showBarMsg('Error en la edicion del pedido ', false);
    }
  }

  Future edicionPedidoAPI() async {
    _submitDialog(context);
    final response = await http.post(
      Uri.parse('${Constant.URL}/synchronization_pedido'),
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
            "id_sucursal_tercero": id_sucursal_tercero,
            "id_vendedor": id_vendedor,
            "id_suc_vendedor": '$id_suc_vendedor',
            "fecha": '$fecha_pedido',
            "vencimiento": '$fecha_pedido',
            "fecha_entrega": '$fecha_pedido',
            "fecha_trm": '$fecha_pedido',
            "id_forma_pago": '$_value_itemsFormaPago',
            "id_precio_item": '$listaPrecioTercero',
            "id_direccion_factura": id_direccion_factura,
            "id_moneda": "COLP",
            "trm": "1",
            "subtotal": '$totalSubTotal',
            "total_costo":
            double.parse(totalPedido) + double.parse(totalDescuento),
            "total_iva": "0",
            "total_dcto": '$totalDescuento',
            "total": '$totalPedido',
            "total_item": "0",
            "orden_compra": orden_compra,
            "estado": "PENDIENTE",
            "flag_autorizado": "SI",
            "comentario": "PRUEBA",
            "observacion": myControllerObservacion.text.trim(),
            "id_direccion": id_direccion,
            "usuario": _user,
            "id_tiempo_entrega": "0",
            "flag_enviado": "SI",
            "app_movil": false,
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
                  "precio_lista": "0",
                  "tasa_iva": "19",
                  "total_iva": "0",
                  "tasa_dcto_fijo": "0",
                  "total_dcto_fijo": "0",
                  "total_dcto": _cartProductos[i]['total_dcto'].toString(),
                  "costo": "0",
                  "subtotal": double.parse(
                      _cartProductos[i]['precio'].toString()) *
                      double.parse(_cartProductos[i]['cantidad'].toString()),
                  "total":
                  (double.parse(_cartProductos[i]['precio'].toString()) *
                      double.parse(
                          _cartProductos[i]['cantidad'].toString())) -
                      double.parse(_cartProductos[i]['dcto'].toString()),
                  "total_item": "0",
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
    Navigator.pop(context);
    if (response.statusCode == 201 && success) {
      await OperationDB.updatePedidoFlag(_value_automatico, _nit);
      //actualizar EL REGISTRO LOCAL COMO FLAG ENVIADO SI
      print("actualizar EL REGISTRO LOCAL COMO FLAG ENVIADO SI");
    } else {
      print("error en la creacion del pedido online $msg");
    //  _showBarMsg('Error en la creacion del pedido ONLINE $msg', false);
    }
    removeCarrito();
    modalExitosa();
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
                        OperationDB.deleteCarrito();
                        Navigator.pushNamed(context, 'units');
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
  
  //productos
  Widget _formCategories(BuildContext context, data) {
    //listado de clientes en el home
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
            callback: () => {searchClasificacionProductos('1','',true)},
            controller: myControllerBuscarCatego),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          height: 420.0,
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
                              searchClasificacionProductos('2','',false);
                          _formShowCategories = false; 
                          _productosShowCat = false;
                             _clientShow  = true;
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
                      color:  ( _cartProductos.length > 0  )
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
                   (_cartProductos.length > 0  )
                            ? editarPedido()
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

  Widget itemUnits(BuildContext context, String idItem, String descripcion,
      String inventario) {
    final nombre = descripcion.length > 35
        ? descripcion.substring(0, 33) + '...'
        : descripcion;
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
            child:
            Padding(
              padding: const EdgeInsets.all(7.0),
              child:Column(
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
                      child: Text(inventario,
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
                          /*idClasificacion =
                              '${_datClasificacionProductos[i]['id_clasificacion']}';*/
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
          height: 535.0,
          child: ListView(
            children: [
              for (var i = 0; i < _countProductos; i++) ...[
                itemUnits(
                    context,
                    '${_datProductos[i]['id_item']}',
                    '${_datProductos[i]['descripcion']}',
                    '${_datProductos[i]['saldo_inventario']} - ${_datProductos[i]['id_unidad_compra']} '),
                SizedBox(height: 5.0),
              ],
            ],
          ),
        ),
      ],
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

  Widget _ItemCategoryOrderEdit(index, idItem, descripcion, cantidad) {
    final nombre = descripcion.length > 35
        ? descripcion.substring(0, 33) + '...'
        : descripcion;
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
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            child: Text(
              '$descripcion',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
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
                                  expresionRegular(
                                      double.parse(cantidad.toString())),
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
                                      if (_cantidadProducto > 1) {
                                        _cantidadProducto = int.parse(
                                            myControllerCantidad.text.trim());
                                        _cantidadProducto--;
                                        myControllerCantidad.text =
                                            _cantidadProducto.toString();
                                        print(
                                            "cantidad resta $_cantidadProducto");
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
                                width: _size.width * 0.5 - 150,
                                height: 30.0,
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
                                      _cantidadProducto =
                                          int.parse(myControllerCantidad.text.trim());
                                      _cantidadProducto++;
                                      myControllerCantidad.text =
                                          _cantidadProducto.toString();
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
                TextField(
                    controller: myControllerDescuentos,
                    keyboardType: TextInputType.number,

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
                      child: ElevatedButton(
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
                          style: ButtonStyle(
                            //backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            if(!validExistCarrito(idItem)) {
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


  Widget _shoppingCart(BuildContext context, data, cant) {
    final _size = MediaQuery.of(context).size;
    final nombre = nombre_tercero.toUpperCase();
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
            cant > 0 ? Column(
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
                      child:Icon(
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
                SizedBox(height: 12.0),
                Text('$nombre',
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
                InputCallbackf(context,
                    'Buscar producto',
                    Icons.search,
                    searchProductosPedido,
                    myControllerBuscarProd),
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
                          Navigator.pop(context);
                          _clientShow = false;
                          _productosShowCat = false;
                                searchClasificacionProductos('1','',true);
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
                      for (var i = 0; i < _cartProductos.length; i++) ...[
                        _ItemCategoryOrderCart(_cartProductos[i], i, true),
                        SizedBox(height: 10.0),
                      ],
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
                                  removeCarrito();
                                  Navigator.of(context)
                                      .pop(); // close the drawer
                             
                                  _formShowCategories = false;
                                  _clientShow = false;
                                  _productosShowCat = false;
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
                              color: (_cartProductos.length > 0)
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
                                    ? editarPedido()
                                    : modalSinPedido();
                              },
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ):   Column(
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
                      child:Icon(
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
                  child:
                  new Column(
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
                                  child:  Image(
                                    height: 250.0,
                                    width: 250.0,
                                    image: AssetImage('assets/images/carrito_vacio.png'),
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
                                          borderRadius: BorderRadius.circular(5.0),
                                          color:
                                          Color(0xff0894FD)
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(5.0),
                                          child: Center(
                                            child: Text(
                                              'Cerrar',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _loadDataUserLogin();
                                           // Navigator.pushNamed(context, 'units');
                                          },
                                        ),
                                      ),
                                    )),
                              ],
                            ),  SizedBox(height: 20.0),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //listado de carrito
  Widget _ItemCategoryOrderCart(data, index, car) {
    var cantidad = int.parse(data['cantidad'].toString());
    double total = 0.0;
    total = data['total'];
    final descripcion = data['descripcion'] ;
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
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal:0.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 300.0, bottom:0.0),
                      child: Icon(
                        Icons.do_disturb_on,
                        color: Color(0xffCB1B1B),
                        size: 20,
                      ),
                    ),
                    onTap: () => {
                      _showDialog(context, index,car),
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        width: _size.width * 0.5 - 75,
                        child: Container(
                          width: _size.width,
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
                                width: _size.width * 0.5 - 150,
                                height: 30.0,
                                child: Center(
                                  child:
                                    TextField(                                  
                                      textAlign: TextAlign.center, 
                                      controller: myControllerCantidadCart,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      
                                     onSubmitted: (String str){
                                     
                                         if (str.isNotEmpty) {
                                      OperationDB.updateCantidadFinal(
                                              _cartProductos[index]['id_item'],
                                              _value_automatico,
                                            int.parse(
                                              myControllerCantidadCart.text.trim()));
                                            myControllerCantidadCart.clear(); 
                                          ObtieneCarrito();
                                        }
                                    },
                                   
                                      decoration: InputDecoration(
                                        hintText:  cantidad.toString(),
                                         hintStyle: TextStyle( color: Color(0xff707070),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700),
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.8,
                                                color: Color(0xff707070))),
                                      )),/*  Text(
                                    cantidad.toString(),
                                    style: TextStyle(
                                        color: Color(0xff707070),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700),
                                  ), */
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
                    //  OperationDB.closeDB();
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


  /////api
  Future<void> numeroAletra(String numero) async {
    _submitDialog(context);
    final val = await validateConexion.checkInternetConnection();
    setState(() {
      _isConnected = val!;      
    });

    if (_isConnected){
      final response = await http.get(Uri.parse("${Constant.URL}/letras/$numero"));
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var success = jsonResponse['success'];
      if (response.statusCode == 200 && success) {
        var data = jsonResponse['data'];
        setState(() {
          _letras = data ;
        });
      } else{
        // _letras = await LetraN.convertirLetras(numero);
      }
    }else{
      // _letras = await LetraN.convertirLetras(numero);
    }

    Navigator.pop(context);
  }

  void _showBarMsg(msg,bool type) {
    showTopSnackBar(
      context,
      animationDuration: const Duration(seconds: 1),
      type ? CustomSnackBar.info(
        message: msg,
      ):CustomSnackBar.error(
        message: msg,
      ) ,
    );
  }
}
