import 'package:pony_order/@presentation/components/inputCallback.dart';
import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:select_form_field/select_form_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../httpConexion/validateConexion.dart';
import '../../Common/Constant.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../db/operationDB.dart';
import '../../models/pedido.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _clientShow = false;
  bool _formShow = false;
  bool _formShowEdit = false;
  bool _formShowCategories = false;
  bool _productosShowCat = false;

  bool focus = false;
  late String _search = '@';
  String _user = '';
  String _nit = '';
  late String id_tercero = '';
  late String orden_compra = '';
  String idPedidoUser = '';
  String id_vendedor = '';
  String fecha_pedido = '';
  bool _isConnected = false;
  List<dynamic> _datPedido = [];
  late int _count;

  List<dynamic> _datDetallePedido = [];
  final myControllerOrdenCompra = TextEditingController();
  final myControllerNroPedido = TextEditingController();
  final myControllerSearch = TextEditingController();
  final myControllerBuscarProd = TextEditingController();
  final myControllerBuscarCatego= TextEditingController();

  late String _saldoCartera = '0.00';
  late String id_tipo_pago = '';
  late String forma_pago_tercero = '';
  late String limite_credito = '0';
  late String id_sucursal_tercero = '';
  late String nombre_tercero = '';

  //pantalla 2 de seleccion de productos para pedidos
  late String _searchProducto = '@';
  late int _countProductos = 0;
  List<dynamic> _datProductos = [];
  List<dynamic> _cartProductos = [];

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

  //variables de pedidos
  bool selectItem = false;
  final myControllerDescuentos = TextEditingController(text: "0");
  final myControllerObservacion = TextEditingController();
  final myControllerCantidad = TextEditingController(text: "1"); 
    final myControllerCantidadCart = TextEditingController();
  String _value_itemsFormaPago = '';
  int _cantidadProducto = 1;
  late int _checked = 0;

  late String id_direccion = '';
  late String id_direccion_factura = '';
  bool isEdit = false;

  @override
  void initState() {
    _datPedido = [];
    _count = 0;
    _dateCount = '';
    _range = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString() +
        ' - ' +
        DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();

    fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    fecha2 = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    super.initState();
    _loadDataUserLogin();
  }

  //Method for showing the date picker
  //datepicker
  late String _dateCount;
  late String _range;
  late String fecha1;
  late String fecha2;
  late int _seePedido;

  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
        fecha1 =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
        fecha2 = DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      }
    });
  }

  String id_sucursal_tercero_cliente = '';
  String id_forma_pago_cliente = '';
  String id_precio_item_cliente = '';
  String id_lista_precio_cliente = '';
  String id_suc_vendedor_cliente = '';

  // Perform login
  _loadDataUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(()  {
      _user = (prefs.getString('user') ?? '');
      _nit = (prefs.getString('nit') ?? '');
      idPedidoUser = (prefs.getString('idPedidoUser') ?? '');
      id_vendedor = (prefs.getString('id_vendedor') ?? '');
      id_sucursal_tercero_cliente = (prefs.getString('id_sucursal_tercero') ?? '');
      id_forma_pago_cliente = (prefs.getString('id_forma_pago') ?? '');
      id_precio_item_cliente = (prefs.getString('id_precio_item') ?? '');
      id_lista_precio_cliente = (prefs.getString('id_lista_precio') ?? '');
      id_suc_vendedor_cliente = (prefs.getString('id_suc_vendedor') ?? '');

      if (_nit != '' && id_vendedor!='') {
        searchPedido();
      }else{
        _showBarMsg('No se obtuvo información del vendedor,sincronice los datos', false);
       }

    });
    await ObtieneCarrito();
  }

  String expresionRegular(double numero) {
    NumberFormat f = new NumberFormat("###,###,###.00#", "es_US");
    String result = f.format(numero);
    return result;
  }

  Future<void> searchPedido() async {
    _submitDialog(context);
    _search = myControllerSearch.text;
    final search_ = (_search.isNotEmpty && _search != '') ? _search : '@';
    final data = await OperationDB.getHistorialPedidos(
        id_vendedor, fecha1, fecha2, search_);
    if (data != false) {
      setState(() {
        if (data.length > 0) {
          _datPedido = data;
          _count = data.length;
          _clientShow = true;
        }
      });
    } else {
      setState(() {
        _datPedido = [];
        _count = 0;
      });
      _showBarMsg('No existen pedidos', false);
    }
    Navigator.pop(context);
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
    } else {
       _cartProductos = [];
    }
    setState(()   {
      totalPedido =  valorTotal();
    });
   
  }

  Future<void> saldoCartera() async {
    var data =
        await OperationDB.getSaldoCartera(id_tercero, id_sucursal_tercero);
    if (data != false) {
      setState(() {
        _saldoCartera =
        data[0]['DEBITO'] != null ? data[0]['DEBITO'].toString() : '0';
      });
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
      _direccionClient = [];
      _direccionClienMercancia = [];
      searchClientDireccion();
    } else {
      _showBarMsg('No se obtuvo  el saldo', false);
    }
  }

  late List<Map<String, dynamic>> _direccionClient = [];
  late List<Map<String, dynamic>> _direccionClienMercancia = [];
  Future<void> searchClientDireccion() async {
    final allDireccionMercancia = await OperationDB.getDireccion(_nit, id_tercero,'Mercancia');
    if (allDireccionMercancia != false) {
      _direccionClienMercancia = (allDireccionMercancia as List)
          .map((dynamic e) => e as Map<String, dynamic>)
          .toList();
    }else{
      _showBarMsg('El cliente no registra dirección', false);
    }

    final allDireccion = await OperationDB.getDireccion(_nit, id_tercero,'Factura');
    if (allDireccion != false && allDireccionMercancia != false) {
      setState(() {
        _direccionClient = (allDireccion as List)
            .map((dynamic e) => e as Map<String, dynamic>)
            .toList();

        _clientShow = false;

      });
    } else {
      _showBarMsg('El cliente no registra dirección', false);
    }
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

  //descuentos poara el recibo
  Future<void> searchDetallePedido(numeroPedido) async {
    final data =
        await OperationDB.getHistorialPedidosDetalle(numeroPedido, _nit);
    if (data != false) {
      setState(() {
        _datDetallePedido = data;
        for (var i = 0; i < data.length; i++) {
          _addProductoPedidoItems(_datDetallePedido[i]);
        }
        _clientShow = false;
        _formShow = true;
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "No se pudo obtener el detalle",
        ),
      );
    }
    saldoCartera();
  }

  late DateTime _selectedDate = DateTime.now();
  void _pickDateDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime(1950),
            //what will be the previous supported year in picker
            lastDate: DateTime(2030)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        fecha_pedido =
            DateFormat('yyyy-MM-dd').format(_selectedDate).toString();
      });
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
    _search =  myControllerBuscarCatego.text.isNotEmpty ? myControllerBuscarCatego.text :'@';
    var data =
        await OperationDB.getClasificacionProductos(_nit, '1', '', true,_search);
    if (data != false) {
      _datClasificacionProductos = data;
      _countClasificacion = data.length;
      setState(() {
        if (_countClasificacion > 0) {
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
          _formShow = false;
          _formShowCategories = true;
          _formShowCategories
              ? _formCategories(context, _datClasificacionProductos)
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

    var data =
        await OperationDB.getClasificacionProductos(_nit, '1', '', true,_search);
    if (data != false) {
      _datClasificacionProductos = data;
      _countClasificacion = data.length;
      setState(() {
        if (_countClasificacion > 0) {
          idClasificacion =
              '${_datClasificacionProductos[0]['id_clasificacion']}';
          _formShow = false;
          _formShowCategories = true;
          _formShowCategories
              ? _formCategories(context, _datClasificacionProductos)
              : Container();
        }
      });
    } else {
      _showBarMsg('ERROR SP1', false);
    }
  }

  Future<void> selectProductoNivel() async {
    var data =
        await OperationDB.getClasificacionProductos(_nit, '2', _id_padre, true,'@');
    if (data != false) {
      _datClasificacionProductosNivel = data;
      _countClasificacionNivel = data.length;
      setState(() {     
        idClasificacion =
        '${_datClasificacionProductosNivel[0]['id_padre']}';
        searchProductosPedido();
      });
    } else {
      _showBarMsg('ERROR SPN2', false);
    }
  }

  Future<void> searchProductosPedido() async {
    final  _search =  myControllerBuscarProd.text.isNotEmpty ? myControllerBuscarProd.text : '@';
    var data = await OperationDB.getItems(_nit, idClasificacion,_search,'');
    if (data != false) {
      setState(() {
        _datProductos = data;
        _countProductos = data.length;
        _formShow = false;
        _clientShow = false;
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
      setState(() {
        _precio = 0;
        _descuento = 0;
      });
      _showBarMsg('No se obtuvo el precio de este producto', false);
    }
  }

  Widget _getCarritoLleno() {
    if (_cartProductos.length > 0) {
      return    Container(
        padding:  const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffCB1B1B),
          border: Border.all(
            color:Color(0xffCB1B1B),
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
            fontWeight:FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

    } else {
      return Container();
    }
  }
  TextEditingController dateinput = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
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
           /* badges.Badge(
              badgeContent: Text((_cartProductos.length).toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),*/
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
            //  position: badges.BadgePosition.topEnd(top: -5, end: 45),

            //),
          ],
         /*   actions: [
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
          ],    */
          title: Text(
            'Pedidos',
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
                      child: Column(
                        children: [
                          _formShow ||
                                  _formShowEdit ||
                                  _formShowCategories ||
                                  _productosShowCat
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Búsqueda de pedidos',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xff0f538d),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 10.0),
                                    TextField(
                                      controller: myControllerSearch,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (String str){
                                        setState((){
                                          searchPedido();
                                        });
                                      },
                                      onChanged: (text) {
                                        if (text.isEmpty) {
                                          searchPedido();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText:
                                            'Identificación, nombre ó N° de pedido',
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
                                          onTap: searchPedido,
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
                                    SizedBox(height: 10.0),
                                    InputCallback(
                                        hintText: '$_range',
                                        iconCallback: Icons.search,
                                        callback: () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                      child: Container(
                                                        height: 300.0,
                                                        width: 110.0,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    20.0,
                                                                vertical: 15.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            getDateRangePicker(),
                                                          ],
                                                        ),
                                                      )));
                                        },
                                        controller: null ),

                                  ],
                                ),
                          SizedBox(height: 10.0),
                          _clientShow ? _client(context) : Container(),
                          _formShow ? _form() : Container(),
                          _formShowEdit ? _formEdit(context) : Container(),
                          _formShowCategories
                              ? _formCategories(
                                  context, _datClasificacionProductos)
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

  Widget _client(BuildContext context) {
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
        SizedBox(
          height: 535.0,
          child: ListView(
            children: [
              for (var i = 0; i < _count; i++) ...[
                itemOrder(_datPedido[i], i),
                SizedBox(height: 10.0),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget itemOrder(data, i) {

    final nombre = data['nombre_sucursal'].length > 24
        ? data['nombre_sucursal'].substring(0, 23)
        : data['nombre_sucursal'];
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
                  nombre.toUpperCase(),
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
                    onTap: () => {
                          setState(() {
                            if (_cartProductos.isNotEmpty && data['id_tercero']!=id_tercero) {
                              modalNuevoPedido(context, data, i);
                            } else {
                              _seePedido = i;
                              searchDetallePedido(data['numero']);
                              id_sucursal_tercero =
                                  '${data['id_sucursal_tercero']}';
                              limite_credito = '${data['limite_credito']}';
                              listaPrecioTercero = '${data['lista_precio'].toString()}';
                              id_tercero = '${data['id_tercero']}';
                              id_empresa = '${data['id_empresa']}';
                              _value_itemsFormaPago = '${data['id_forma_pago'].toString()}';
                              _value_automatico =
                                  '${data['numero'].toString()}';
                              nombre_tercero =
                                  '${data['nombre_sucursal'].toString()}';
                            }
                          })
                        }),
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

  Widget _ItemProductOrder(data, i) {
    final _size = MediaQuery.of(context).size;
    final subtotal = double.parse(data['cantidad'].toString()) * double.parse(data['precio'].toString());
    final total = subtotal - double.parse(data['total_dcto'].toString());
    final descripcion = data['descripcion'].length >= 30
        ? data['descripcion'].substring(0, 30) + '...'
        : data['descripcion'];
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
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                 descripcion.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff707070),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _showDialog(context, i);
                    },
                    icon: Icon(
                      Icons.do_disturb_on_rounded,
                      color: Color(0xffCB1B1B),
                      size: 20.0,
                    )),
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
                                  double.parse(total.toString())),
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
             textInputAction: TextInputAction.done,
          onChanged: (text) {
            if(text.isEmpty){
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
                  initialValue:itemsListPrecio.length > 0 ?  itemsListPrecio[0]['value'] : null,
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
                      child:Text(
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
                      width: 140.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: (_itemSelect == data['id_item'] && _precio > 0  ) && !validExistCarrito(data['id_item'])
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
    final _size = MediaQuery.of(context).size;
    double maxWidth = MediaQuery.of(context).size.width * 0.8;
    return Container(
      width: maxWidth,
      height: 355.0,
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
                      width: _size.width * 0.5 - 140,
                      child: Text(
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
                          height: 30.0,
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_cantidadProducto > 1) {
                                        _cantidadProducto = int.parse(
                                            myControllerCantidad.text);
                                        _cantidadProducto--;
                                        myControllerCantidad.text =
                                            _cantidadProducto.toString();
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
                               width: _size.width> 600 ?_size.width * 0.5 - 330 : _size.width * 0.5 - 130,
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
                                          int.parse(myControllerCantidad.text);
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

  Widget _ItemCategoryOrderEditold(index, idItem, descripcion, cantidad) {
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
            child: Row(
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
                                        _cantidadProducto = int.parse(myControllerCantidad.text);
                                        _cantidadProducto--;
                                        myControllerCantidad.text =
                                            _cantidadProducto.toString();
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
                                      _cantidadProducto = int.parse(myControllerCantidad.text);
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
                          onPressed: () {
                            setState(() {
                              _addProductoPedido(descripcion, idItem);
                            });
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
                            myControllerBuscarProd.clear();
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
                    _searchProducto,
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
                          _formShowEdit = false;
                          _clientShow = false;
                          _formShow = false;
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
                  height:_size.height - 560,
                     child: ListView.builder(
                      itemCount: _cartProductos.length,
                      itemBuilder: (context, i) =>   _ItemCategoryOrderCart(_cartProductos[i], i),
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
                                  _formShow = true;
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
            ):

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
                                    //  Navigator.pushNamed(context, 'order');
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
  Widget _ItemCategoryOrderCart(data, index) {
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
                _showDialog(context, index),
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
                        width: _size.width * 0.5 - 40,
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
                                width:_size.width> 600 ? _size.width* 0.5 - 330 :_size.width * 0.5 - 120,
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
                                      )),
                                  /* Text(
                                    cantidad.toString(),
                                    style: TextStyle(
                                        color: Color(0xff707070),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700),
                                  ),*/
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

  Widget getDateRangePicker() {
    return Container(
        height: 250,
        child: Card(
            child: SfDateRangePicker(
          showActionButtons: true,
          onSelectionChanged: _onSelectionChanged,
          cancelText: 'CANCEL',
          confirmText: 'OK',
          onCancel: () {
            Navigator.pop(context);
          },
          onSubmit: (Object? value) {
            Navigator.pop(context);
            searchPedido();
          },
          selectionMode: DateRangePickerSelectionMode.range,
          initialSelectedRange: PickerDateRange(
              DateTime.now().subtract(Duration(days: 1)), DateTime.now()),
        )));
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
                child: const ListTile(
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

  Widget _form() {
    final _size = MediaQuery.of(context).size;
    final total_d = _cartProductos.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visualice los detalles del pedido',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(height: 15.0),
        Text(
          '${_datPedido[_seePedido]['nombre_sucursal'].toUpperCase()}',
          style: TextStyle(
              fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(
          height: 15.0,
        ),
        itemOrder(_datPedido[_seePedido], _seePedido),
        SizedBox(
          height: 15.0,
        ),
        Text(
          'Items del pedido',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(height: 10.0),
        Text(
          'Este pedido tiene $total_d items',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: Color(0xff06538D)),
        ),
        SizedBox(height: 10.0),
        SizedBox(
          height: _size.height -500,
            child: ListView(
            children: [
              for (var i = 0; i < total_d; i++) ...[
                if (_cartProductos.isNotEmpty) ...[
                  _ItemProductOrder(_cartProductos[i], i),
                  SizedBox(height: 10.0),
                ],
              ]
            ],
          ),
        ),
        SizedBox(height: 10.0),
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
                          isEdit = false;
                          removeCarrito();
                          myControllerOrdenCompra.clear();
                          _formShowEdit = false;
                          _productosShowCat = false;
                          _formShow = false;
                          _clientShow = true;

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
                          'Editar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isEdit = true;
                          _formShow = false;
                          _formShowEdit = true;
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

  Widget _formEdit(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final conse = _datPedido[_seePedido]['numero'];
    nombre_tercero = _datPedido[_seePedido]['nombre_sucursal'];

    if (_selectedDate != '') {
      var dia = (_selectedDate.day).toString();
      var mes = (_selectedDate.month).toString();
      final ano = _selectedDate.year;
      dia = dia.length == 1 ? '0$dia' : dia;
      mes = mes.length == 1 ? '0$mes' : mes;
      fecha_pedido = '$ano-$mes-$dia';
    } else {
      fecha_pedido = _datPedido[_seePedido]['fecha'];
    }

    id_direccion = _datPedido[_seePedido]['id_direccion'];
    id_direccion_factura = _datPedido[_seePedido]['id_direccion_factura'];
    orden_compra = _datPedido[_seePedido]['orden_compra'];
    listaPrecioTercero = _datPedido[_seePedido]['id_precio_item'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Edite los datos del pedido registrado',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(
          height: 10.0,
        ),
        _itemForm(context, 'Pedido N°', '$conse', myControllerNroPedido, true,
            'number', false),
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
                  '$fecha_pedido',
                ),
                Icon(Icons.arrow_drop_down, color: Color(0xff06538D)),
              ],
            ),
          ),
        ),
        _itemForm(
            context, 'Nombre', '$nombre_tercero', null, true, 'text', false),
        SelectFormField(
          style: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
          type: SelectFormFieldType.dropdown, // or can be dialog
          labelText: 'Dir. envío factura',
          items: _direccionClient,
          initialValue: id_direccion_factura,
          onChanged: (val) => setState(() => {
                id_direccion_factura = val,
              }),
        ),
        SelectFormField(
          style: TextStyle(
              color: Color(0xff06538D),
              fontSize: 14.0,
              fontWeight: FontWeight.w600),

          type: SelectFormFieldType.dropdown, // or can be dialog

          labelText: 'Dir. envío mercancia',
          items: _direccionClienMercancia,
          initialValue: id_direccion,
          onChanged: (val) => setState(() => {
                id_direccion = val,
              }),
        ),
        _itemForm(context, 'Orden de compra', orden_compra,
            myControllerOrdenCompra, false, 'text', false),
        _itemForm(context, 'Forma de pago', '$forma_pago_tercero', null, true,
            'text', false),
        SizedBox(
          height: 30.0,
        ),
        Container(
          height: 1,
          width: _size.width,
          color: Color(0xffC7C7C7),
        ),
        SizedBox(
          height: 30.0,
        ),
        Text('Crédito',
            style: TextStyle(
                color: Colors.blue,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                fontSize: 16.0)),
        SizedBox(height: 10.0),
        _itemForm(
            context,
            'Cupo crédito',
            '\$ ' + expresionRegular(double.parse(limite_credito.toString())),
            null,
            true,
            'number',
            false),
        _itemSelectForm(
            context,
            'Total cartera',
            '\$ ' + expresionRegular(double.parse(_saldoCartera.toString())),
            ''),
        SizedBox(
          height: 50.0,
        ),
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
                          _formShowEdit = false;
                          _productosShowCat = false;
                          _clientShow = false;
                          _formShow = true;
                       //   _search = '@';
                        //  searchPedido();
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
                          _formShowEdit = false;
                          _formShowCategories = true;
                          searchClasificacionProductos();
                        });
                      },
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  //productos
  Widget _formCategories(BuildContext context, data) {
    final _size = MediaQuery.of(context).size;
    final nombre = nombre_tercero.toUpperCase();
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
          '$nombre',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff0894FD)),
        ),
        SizedBox(
          height: 10.0,
        ),
        InputCallbackf(context,
            'Buscar Categoria',
            Icons.search,
            searchClasificacionProductos,
            myControllerBuscarCatego),
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
                          removeCarrito();
                          _formShow = false;
                          _formShowCategories = false;
                          _productosShowCat = false;
                          _clientShow = false;
                          _formShowEdit = true;
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
                      color: (_cartProductos.length > 0 && double.parse(totalPedido) > 0)
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
                        (_cartProductos.length > 0)
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
                     // AssetImage('assets/images/${data[i]['descripcion']}.png'),
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
                          _clientShow = false;
                          _productosShowCat = false;
                          _formShowEdit = false;
                          _formShow = false;
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
                  height: _size.height  -480,
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
                                //  myControllerOrdenCompra.clear();
                                  _formShow = false;
                                  _clientShow = false;
                                  _productosShowCat = false;
                                  _formShowCategories = false;
                                  _formShowEdit = true;
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

  _addProductoPedidoItems(data) async {

    final precio = double.parse(data['precio']);
    final total = data['cantidad'] * precio;
    final cantidad = data['cantidad'];

    if(!validExistCarrito(data['id_item'])) {
          _cartProductos.add({
            "descripcion": data['descripcion_item'],
            "id_item": data['id_item'],
            "precio": precio,
            "cantidad": cantidad,
            "total_dcto": double.parse(data['total_dcto']),
            "dcto": data['dcto'] != null ? double.parse(data['dcto']) : 0,
            "id_precio_item": data['id_precio_item'],
            "total": total
          });

      setState(()   {
        totalPedido = valorTotal();
      });
      sendCarritoBD("viene de _addProductoPedidoItems");
    }
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

      setState(()   {
        totalPedido =   valorTotal();
        myControllerCantidad.clear();
        myControllerDescuentos.clear();
        myControllerDescuentos.text = '0';
        myControllerCantidad.text = '1';
        _cantidadProducto = 1;
        sendCarritoBD("_addProductoPedido");
      });
      Navigator.of(context).pop();
      _showBarMsg('Has agregado estos productos a tu carrito', true);

  }

  valorTotal()   {
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
    Navigator.pushNamed(context, 'order');
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


  void removeCarritoEditar(data, i) {
    OperationDB.deleteCarrito();
    _cartProductos = [];
    totalPedido = '0.00';
    totalSubTotal = '0.00';
    totalDescuento = '0.00';
    totalPedido = valorTotal();
    _seePedido = 0;
    _letras = '';
    _seePedido = i;

    searchDetallePedido(data['numero']);
    id_sucursal_tercero = '${data['id_sucursal_tercero']}';
    limite_credito = '${data['limite_credito']}';
    id_tercero = '${data['id_tercero']}';
    id_empresa = '${data['id_empresa']}';
    _value_automatico = '${data['numero'].toString()}';
    listaPrecioTercero = '${data['id_precio_item'].toString()}';
    nombre_tercero = '${data['nombre_sucursal'].toString()}';
    orden_compra = '${data['orden_compra'].toString()}';
  }

  Future sendCarritoBD(String origen) async {

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
        orden_compra: myControllerOrdenCompra.text != '' ?myControllerOrdenCompra.text : orden_compra ,
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

  modalNuevoPedido(BuildContext context, data, index) {
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
        removeCarritoEditar(data, index);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("¡Espera!"),
      content: Text(
          "Tiene productos agregados al carrito, si continúa estos se descartarán."),
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
                            setState(() {
                              OperationDB.deleteProductoCarrito(
                                  _cartProductos[index]['id_item']);
                              _cartProductos.removeAt(index);

                              totalPedido = valorTotal();
                             //numeroAletra(totalPedido.toString());
                            });
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
    print(
        "se manda a editar el pedido $_value_automatico -- idPedidoUser $idPedidoUser");
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
        orden_compra != '' ? orden_compra : myControllerOrdenCompra.text;
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
        observacion: myControllerObservacion.text,
        letras: _letras,
        id_direccion_factura: '$id_direccion_factura',
        usuario: _user,
        id_tiempo_entrega: "0",
        flag_enviado: "NO");

    print("la data que se emvia a editar del pedido $nuevo_pedido");

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
      print("la data que se emvia a editar del pedido detalle $nuevo_pedido_det");
      flag_pedido_det = await OperationDB.insertPedidoDet(nuevo_pedido_det,true);
    }
    if (flag_pedido && flag_pedido_det) {
      !isEdit
          ? await OperationDB.updateConsecutivo(
              int.parse(_value_automatico), _nit, idPedidoUser, id_empresa)
          : null;
      final val = await validateConexion.checkInternetConnection();
      setState(() {
        _isConnected = val!;
      });
      Navigator.pop(context);
      _isConnected ? await edicionPedidoAPI() : modalExitosa();
    } else {
      _showBarMsg('Error en la edición del pedido', false);

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
                  'Edición de pedido exitoso',
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
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'order');
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
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
            "observacion": myControllerObservacion.text,
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
    }
    removeCarrito();
    modalExitosa();
  }


  Widget _itemForm(BuildContext context, String label, String hintText,
      controller, enable, String type, bool isRequired) {
    final _size = MediaQuery.of(context).size;
    var typeInput;
    int cant;
    switch (type) {
      case 'number':
        typeInput = TextInputType.number;
        cant = 15;
        break; // The switch statement must be told to exit, or it will execute every case.
      case 'email':
        cant = 40;
        typeInput = TextInputType.emailAddress;
        break;
      case 'phone':
        cant = 13;
        typeInput = TextInputType.phone;
        break;
      case 'text':
        cant = 30;
        typeInput = TextInputType.text;
        break;
      case 'name':
        cant = 30;
        typeInput = TextInputType.name;
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
          child: TextField(
            readOnly: enable,
            keyboardType: typeInput,
            controller: controller,
            style: TextStyle(
              color: Color(0xff707070),
              fontSize: 14.0,
            ),
            decoration: InputDecoration(
              errorText:
                  isRequired && controller.text.isEmpty ? 'Es requerido' : null,
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

  /////api
  Future<void> numeroAletra(String numero) async {
    _submitDialog(context);
    final val = await validateConexion.checkInternetConnection();
    setState(() {
      _isConnected = val!;
      print("LA CONEXION $_isConnected");
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

    print("la letra convertida en locasl es  $_letras");

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
