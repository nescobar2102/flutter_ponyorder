import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import '../../db/OperationDB.dart';

class SalePage extends StatefulWidget {
  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  late String id_vendedor;
  late int _count;
  String _user = '';
  String _nit = '';
  late double total_cuota = 0;
  late double total_venta = 0;
  late double total_pedido = 0;
  late double total_recibo = 0;
  late double porcentaje = 0;

  List<dynamic> _datBalance = [];
  List<dynamic> _datSale = [];
  late String _fecha;
  final myControllerBuscarProd = TextEditingController();

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  late ValueNotifier<double> _valueNotifier;

  @override
  void initState() {
    _count = 0;
    _valueNotifier = ValueNotifier(0.0);
    _fecha = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    _loadDataUserLogin();
    super.initState();
  }

  String expresionRegular(double numero) {
    NumberFormat f = new NumberFormat("###,###,###.00#", "es_US");
    String result = f.format(numero);
    return result;
  }

  Future searchBalanceApi() async {
    _datBalance = await OperationDB.getCBalance(_nit, id_vendedor, _fecha);
    if (_datBalance != null) {
      for (int i = 0; i < _datBalance.length; i++) {
        if (_datBalance[i]['tipo'] == 'MES') {
          total_cuota = _datBalance[i]['total_cuota'] != null
              ? double.parse(_datBalance[i]['total_cuota'].toString())
              : 0.00;
          total_venta = _datBalance[i]['total_venta'] != null
              ? double.parse(_datBalance[i]['total_venta'].toString())
              : 0.00;
          porcentaje = _datBalance[i]['balance_general'] != null
              ? double.parse(_datBalance[i]['balance_general'].toString())
              : 0.00;
        }
        if (_datBalance[i]['tipo'] == 'DIA_RECIBO') {
          total_recibo = _datBalance[i]['total_venta'] != null
              ? double.parse(_datBalance[i]['total_venta'].toString())
              : 0.00;
        }
        if (_datBalance[i]['tipo'] == 'DIA_PEDIDO') {
          total_pedido = _datBalance[i]['total_venta'] != null
              ? double.parse(_datBalance[i]['total_venta'].toString())
              : 0.00;
        }
      }
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "No se obtuvo datos",
        ),
      );
    }
  }

  Future searchSaleApi() async {
    final allSale = await OperationDB.getCuotaValue(_nit, id_vendedor);
    if (allSale != null) {
      setState(() {
        _datSale = allSale;
        _count = _datSale.length;
      });
    }
  }

  String id_sucursal_tercero_cliente = '';
  String id_forma_pago_cliente = '';
  String id_precio_item_cliente = '';
  String id_lista_precio_cliente = '';
  String id_suc_vendedor_cliente = '';

  _loadDataUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = (prefs.getString('user') ?? '');
      _nit = (prefs.getString('nit') ?? '');
      id_vendedor = (prefs.getString('id_vendedor') ?? '');
      id_sucursal_tercero_cliente =
          (prefs.getString('id_sucursal_tercero') ?? '');
      id_forma_pago_cliente = (prefs.getString('id_forma_pago') ?? '');
      id_precio_item_cliente = (prefs.getString('id_precio_item') ?? '');
      id_lista_precio_cliente = (prefs.getString('id_lista_precio') ?? '');
      id_suc_vendedor_cliente = (prefs.getString('id_suc_vendedor') ?? '');
      print("el usuario es $_user $_nit $id_vendedor");

      if (_nit != '' && id_vendedor != '') {
        searchBalanceApi();
        searchSaleApi();
      } else {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message:
                "No se obtuvo información del vendedor,sincronice los datos",
          ),
        );
      }
    });
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
    final _size = MediaQuery.of(context).size;
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
              'Cuota de venta',
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
                        width: _size.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _balance(context),
                            SizedBox(
                              height: 10.0,
                            ),
                            _balanceDetail(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]))
              ],
            ),
          ),
        ));
  }

  Widget _balance(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: _size.width,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffC7C7C7),
              ),
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance general',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff06538D)),
              ),
              DashedCircularProgressBar.aspectRatio(
                aspectRatio: 1.25, // width ÷ height
                valueNotifier: _valueNotifier,
                progress: double.parse(porcentaje.toString()),
                startAngle: 225,
                sweepAngle: 270,
                foregroundColor: Colors.blue,
                backgroundColor: const Color(0xffeeeeee),
                foregroundStrokeWidth: 15,
                backgroundStrokeWidth: 15,
                animation: true,
                seekSize: 6,
                seekColor: const Color(0xffeeeeee),
                child: Center(
                  child: ValueListenableBuilder(
                      valueListenable: _valueNotifier,
                      builder: (_, double value, __) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${value.toInt()}%',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_box_rounded,
                        color: Color(0xff0091CE),
                        size: 13.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Presupuesto',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0091CE)),
                      ),
                    ],
                  ),
                  Text(
                    '\$ ' +
                        expresionRegular(double.parse(total_cuota.toString())),
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707070)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_box_rounded,
                        color: Color(0xff0091CE),
                        size: 13.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Ventas del mes',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0091CE)),
                      ),
                    ],
                  ),
                  Text(
                    '\$ ' +
                        expresionRegular(double.parse(total_venta.toString())),
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707070)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Color(0xff0091CE),
                        size: 13.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Ventas hoy',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0091CE)),
                      ),
                    ],
                  ),
                  Text(
                    '\$ ' +
                        expresionRegular(double.parse(total_pedido.toString())),
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707070)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_view_month,
                        color: Color(0xff0091CE),
                        size: 13.0,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        'Recaudado hoy',
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0091CE)),
                      ),
                    ],
                  ),
                  Text(
                    '\$ ' +
                        expresionRegular(double.parse(total_recibo.toString())),
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707070)),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _balanceDetail(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalles de balance de productos',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: Color(0xff06538D)),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Se encontró el detalle de $_count productos',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: Color(0xff06538D)),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: 310.0,
          child: ListView(
            children: [
              for (var i = 0; i < _count; i++) ...[
                Container(
                  width: _size.width,
                  padding:
                      EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xffC7C7C7),
                      ),
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_datSale[i]['nombre']}',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff06538D)),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10.0,
                              height: 10.0,
                              color: Color(0xff707070),
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              'Meta',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              '\$ ' +
                                  expresionRegular(double.parse(
                                      _datSale[i]['cuota'].toString())),
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10.0,
                              height: 10.0,
                              color: Color(0xff0091CE),
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              'Venta',
                              style: TextStyle(
                                  color: Color(0xff0091CE),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              '\$ ' +
                                  expresionRegular(double.parse(
                                      _datSale[i]['venta'].toString())),
                              style: TextStyle(
                                  color: Color(0xff0091CE),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: DashedCircularProgressBar.aspectRatio(
                            aspectRatio: 2, // width ÷ height
                            valueNotifier: ValueNotifier(
                                _datSale[i]['porcentaje'] != null
                                    ? double.parse(
                                        _datSale[i]['porcentaje'].toString())
                                    : 0),
                            progress: _datSale[i]['porcentaje'] != null
                                ? double.parse(
                                    _datSale[i]['porcentaje'].toString())
                                : 0,
                            startAngle: 225,
                            sweepAngle: 270,
                            foregroundColor: Colors.blue,
                            backgroundColor: const Color(0xffeeeeee),
                            foregroundStrokeWidth: 15,
                            backgroundStrokeWidth: 15,
                            animation: true,
                            seekSize: 6,
                            seekColor: const Color(0xffeeeeee),
                            child: Center(
                              child: ValueListenableBuilder(
                                  valueListenable: ValueNotifier(_datSale[i]
                                              ['porcentaje'] !=
                                          null
                                      ? double.parse(
                                          _datSale[i]['porcentaje'].toString())
                                      : 0.00),
                                  builder: (_, double value, __) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${value.toInt()}%',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 26.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ],
                  ),
                ),
                SizedBox(height: 10.0),
              ]
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
                    // OperationDB.closeDB();
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
