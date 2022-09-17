import 'package:pony_order/@presentation/components/inputCallback.dart';
import 'package:pony_order/@presentation/components/itemCategoryOrderEdit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class SalePage extends StatefulWidget{

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  bool _showItems = false;
  bool _showItemsOrder = false;

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();
  
  late TooltipBehavior _tooltip;
 
  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: false, format: 'point.x : point.y%');
    super.initState();
  }

  List<DoughnutSeries<ChartSampleData, String>> _getDefaultDoughnutSeries(String radius) {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          radius: radius,
          explode: true,
          explodeOffset: '10%',
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Ventas', y: 55, text: '55%',pointColor: Color(0xff0894FD)),
            ChartSampleData(x: 'Meta', y: 45, text: '45%',pointColor: Color(0xffBCBBBB)),
          ],
          pointColorMapper: (ChartSampleData data, _) => data.pointColor,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(isVisible: true))
    ];
  }

  @override
  Widget build(BuildContext context){
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
              }
            )
          ],
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
          endDrawer: _shoppingCart(context),
          body: CustomScrollView(
            slivers: [
              SliverList(delegate: SliverChildListDelegate([
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
                          SizedBox(height: 10.0,),
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
      )
    );
  }

  Widget _balance(BuildContext context){
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
            borderRadius: BorderRadius.circular(8.0)
          ),
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
              SfCircularChart(
                // title: ChartTitle(text: 'Composition of ocean water'),
                legend: Legend(
                    isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                series: _getDefaultDoughnutSeries('100%'),
                tooltipBehavior: _tooltip,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_box_rounded,color: Color(0xff0091CE),size: 13.0,),
                      SizedBox(width: 5.0,),
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
                    '\$ 722.669.129',
                      style: TextStyle(
                        fontSize: 13.0, 
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707070)),
                    ),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_box_rounded,color: Color(0xff0091CE),size: 13.0,),
                      SizedBox(width: 5.0,),
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
                    '\$ 427.369.129',
                      style: TextStyle(
                        fontSize: 13.0, 
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707070)),
                    ),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.credit_card,color: Color(0xff0091CE),size: 13.0,),
                      SizedBox(width: 5.0,),
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
                    '\$ 247.281',
                      style: TextStyle(
                        fontSize: 13.0, 
                        fontWeight: FontWeight.w700,
                        color: Color(0xff707070)),
                    ),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_view_month,color: Color(0xff0091CE),size: 13.0,),
                      SizedBox(width: 5.0,),
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
                    '\$ 5.397.819',
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

  Widget _balanceDetail(BuildContext context){
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
        SizedBox(height: 10.0,),
        Text(
          'Se encontró el detalle de 4 productos',
          style: TextStyle(
            fontSize: 15.0, 
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Color(0xff06538D)),
        ),
        SizedBox(height: 10.0,),
        Container(
          width: _size.width,
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffC7C7C7),
            ),
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aceite',
                    style: TextStyle(
                      fontSize: 16.0, 
                      fontWeight: FontWeight.w700,
                      color: Color(0xff06538D)),
                  ),
                  SizedBox(height: 12.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff707070),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Meta',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('2.413.140',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff0091CE),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Venta',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('1.903.140',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: SfCircularChart(
                  series: _getDefaultDoughnutSeries('100%'),
                  tooltipBehavior: _tooltip,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0,),
        Container(
          width: _size.width,
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffC7C7C7),
            ),
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aceite',
                    style: TextStyle(
                      fontSize: 16.0, 
                      fontWeight: FontWeight.w700,
                      color: Color(0xff06538D)),
                  ),
                  SizedBox(height: 12.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff707070),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Meta',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('2.413.140',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff0091CE),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Venta',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('1.903.140',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: SfCircularChart(
                  series: _getDefaultDoughnutSeries('100%'),
                  tooltipBehavior: _tooltip,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0,),
        Container(
          width: _size.width,
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffC7C7C7),
            ),
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aceite',
                    style: TextStyle(
                      fontSize: 16.0, 
                      fontWeight: FontWeight.w700,
                      color: Color(0xff06538D)),
                  ),
                  SizedBox(height: 12.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff707070),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Meta',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('2.413.140',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff0091CE),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Venta',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('1.903.140',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: SfCircularChart(
                  series: _getDefaultDoughnutSeries('100%'),
                  tooltipBehavior: _tooltip,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0,),
        Container(
          width: _size.width,
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffC7C7C7),
            ),
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aceite',
                    style: TextStyle(
                      fontSize: 16.0, 
                      fontWeight: FontWeight.w700,
                      color: Color(0xff06538D)),
                  ),
                  SizedBox(height: 12.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff707070),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Meta',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('2.413.140',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Container(
                        width: 10.0,
                        height: 10.0,
                        color: Color(0xff0091CE),
                      ),
                      SizedBox(width: 12.0,),
                      Text('Venta',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0
                      ),),
                      SizedBox(width: 15.0,),
                      Text('1.903.140',
                      style: TextStyle(
                        color: Color(0xff0091CE),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0
                      ),)
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 100.0,
                height: 100.0,
                child: SfCircularChart(
                  series: _getDefaultDoughnutSeries('100%'),
                  tooltipBehavior: _tooltip,
                ),
              ),
            ],
          ),
        )
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
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
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
                    fontWeight: FontWeight.w600
                  )),
                  SizedBox(height: 12.0,),
                  Text('Búsqueda de productos en el carrito',
                  style: TextStyle(
                    color: Color(0xff0f538d),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500
                  ),),
                  SizedBox(height: 10.0,),
                  InputCallback(
                    hintText: 'Buscar producto',
                    iconCallback: Icons.search,
                    callback: () => {
                 }),
                 SizedBox(height: 15.0),
                 Container(
                  width: 160.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Color(0xff06538D),
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(5.0),
                    color:  Color(0xff06538D),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      onTap: () => {},
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(Icons.arrow_back, color: Colors.white,),
                            SizedBox(width: 5.0),
                            Text('Categorias',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0,),
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
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Total',
                            style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff06538D))),
                            Text('\$ 0',
                            style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff06538D)),)
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
                child: const ListTile(
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
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Color(0xfff4f4f4),
                child: const ListTile(
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
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}