import 'package:pony_order/@presentation/components/inputCallback.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderEdit.dart';

import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:flutter/material.dart';
import '../../db/operationDB.dart';

class VisitedsPage extends StatefulWidget {
  @override
  _VisitedsPageState createState() => _VisitedsPageState();
}

class _VisitedsPageState extends State<VisitedsPage> {
  late String id_vendedor;
  late String fecha1;
  late int _count;
  String _user = '';
  String _nit = '';
  List<dynamic> _datVisits = [];

  late int selectedRadio;
  bool _showItems = false;
  bool _isSelected = true;
  bool _isSelected2 = false;

  final myControllerBuscarProd = TextEditingController();
  final myControllerBuscarCatego= TextEditingController();

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  Future searchVisitados() async {
    final orden = selectedRadio == 1 ? 'ASC' : 'DESC';
    final data = await OperationDB.getVisitados(id_vendedor, fecha1, orden);
    if (data != false) {
      setState(() {
        _datVisits = data;
        _count = data.length;
        _showItems = true;
      });
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: "No existen visitas para hoy"),
      );
    }
  }

  @override
  void initState() {
    fecha1 = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    _count = 0;
    super.initState();
    selectedRadio = 1;
    _loadDataUserLogin();
  }

  _loadDataUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('user') ?? '');
      _nit = (prefs.getString('nit') ?? '');
      id_vendedor = (prefs.getString('id_vendedor') ?? '');
      
      if (_nit != '' &&  id_vendedor!='') {
        searchVisitados();
      }else{
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "No se obtuvo información del vendedor,sincronice los datos",
          ),
        );
      }
    });
  }
 
  
    Future<bool> _onWillPop() async {       
    if( _drawerscaffoldkey.currentState!.isDrawerOpen && _nit!='') { 
          Navigator.pop(context);              
            return false;
      } 
      return false;
    }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop:_onWillPop,
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
            'Visitados',
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
          //  endDrawer: _shoppingCart(context),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Revise los clientes visitados',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff0f538d),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.filter_alt,
                                      color: Color(0xff06538D),
                                      size: 22.0,
                                    ),
                                    onTap: () {
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
                                                  height:_size.height - 400,
                                                  width: _size.width * 0.8,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 15.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 10.0),
                                                      Text(
                                                        'Filtro de búsqueda para clientes visitados',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff06538D),
                                                            fontSize: 22.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(height: 30.0),
                                                      SizedBox(
                                                        child: RadioListTile(
                                                          value: 1,
                                                          groupValue:
                                                              selectedRadio,
                                                          activeColor:
                                                              Colors.blue,
                                                          title: const Text(
                                                              "Más reciente al más antiguo"),
                                                          onChanged: (val) {                                                            
                                                            setState(() {
                                                              selectedRadio =
                                                                  val as int;
                                                              _isSelected =
                                                                  true;
                                                              _isSelected2 =
                                                                  !_isSelected;
                                                             
                                                            });
                                                          },
                                                          selected: _isSelected,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        child: RadioListTile(
                                                          value: 2,
                                                          title: const Text(
                                                              "Más antiguo al más reciente"),
                                                          groupValue:
                                                              selectedRadio,
                                                          activeColor:
                                                              Colors.blue,
                                                          onChanged: (val) {                                                          
                                                            setState(() {
                                                              selectedRadio =
                                                                  val as int;
                                                              _isSelected2 =
                                                                  true;
                                                              _isSelected =
                                                                  !_isSelected2;                                                               
                                                            });
                                                          },
                                                          selected:
                                                              _isSelected2,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 30.0,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: _size.width *
                                                                0.33,
                                                            height: 41.0,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                color: Color(
                                                                    0xffCB1B1B)),
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Cancelar',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.0,
                                                          ),
                                                          Container(
                                                            width: _size.width *
                                                                0.33,
                                                            height: 41.0,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                color: Color(
                                                                    0xff0894FD)),
                                                            child: Material(
                                                              color: Colors
                                                                  .transparent,
                                                              child: InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child: Center(
                                                                  child: Text(
                                                                    'Aceptar',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  setState(() {
                                                                    Navigator.pop(
                                                                        context);
                                                                    searchVisitados();
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
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              _showItems
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.0,
                                            color: Color(0xffC7C7C7),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Clientes visitados',
                                            style: TextStyle(
                                                color: Color(0xff06538D),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '$_count',
                                            style: TextStyle(
                                                color: Color(0xff06538D),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 15.0),
                              for (var i = 0; i < _count; i++) ...[
                                _showItems
                                    ? _itemVisiteds(_datVisits[i])
                                    : Container(),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ]
                            ],
                          ),
                          SizedBox(height: 10.0),
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

  Widget _itemVisiteds(data) {
    final nombre = data['nombre_sucursal'].toUpperCase();
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
              ],
            ),
          )
        ],
      ),
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
                InputCallback(
                    hintText: 'Buscar producto',
                    iconCallback: Icons.search,
                    callback: () => {
                       // _searchProducto();
                      },
                controller:myControllerBuscarProd),
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
                child: const ListTile(
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
}
