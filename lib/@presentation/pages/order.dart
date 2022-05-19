import 'package:app_pony_order/@presentation/components/inputCallback.dart';
import 'package:app_pony_order/@presentation/components/itemCategoryOrder.dart';
import 'package:app_pony_order/@presentation/components/itemOrder.dart';
import 'package:app_pony_order/@presentation/components/itemProductOrder.dart';
import 'package:app_pony_order/@presentation/components/itemCategoryOrderEdit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _clientShow = false;
  bool _formShow = false;
  bool _formShowEdit = false;
  bool _formShowCategories = false;
  bool _formShowCategoriesList = false;
  bool _formShowCategoriesAdd = false;
  bool? _checked = false;

  // CALENDAR

  DateTime _currentDate = DateTime(2019, 2, 3);
  DateTime _currentDate2 = DateTime(2019, 2, 3);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2019, 2, 3));
  DateTime _targetDateTime = DateTime(2019, 2, 3);
  
  CalendarCarousel<Event>? _calendarCarousel;
  CalendarCarousel<Event>? _calendarCarouselNoHeader;

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2019, 2, 10): [
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        new DateTime(2019, 2, 25),
        new Event(
          date: new DateTime(2019, 2, 25),
          title: 'Event 5',
          icon: _eventIcon,
        ));

    _markedDateMap.add(
        new DateTime(2019, 2, 10),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 4',
          icon: _eventIcon,
        ));

    _markedDateMap.addAll(new DateTime(2019, 2, 11), [
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 1',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 2',
        icon: _eventIcon,
      ),
      new Event(
        date: new DateTime(2019, 2, 11),
        title: 'Event 3',
        icon: _eventIcon,
      ),
    ]);

     _calendarCarousel = CalendarCarousel<Event>(
        onDayPressed: (date, events) {
          setState(() {
            _currentDate = date;
          });
          this.setState(() => _currentDate = date);
          events.forEach((event) => print(event.title));
        },
        weekdayTextStyle: TextStyle(
          color: Color(0xff06538D),
          fontWeight: FontWeight.w300
        ),
        weekendTextStyle: TextStyle(
          color:Color(0xff707070),
          backgroundColor: Colors.transparent,
          fontWeight: FontWeight.bold
        ),
        daysTextStyle: TextStyle(
          color: Color(0xff707070),
          backgroundColor: Colors.transparent,
          fontWeight: FontWeight.bold
        ),
        headerTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 22.0
        ),
        // dayButtonColor: Colors.yellow,
        //          weekDays: null, /// for pass null when you do not want to render weekDays
        // headerText: 'Custom Header',
        weekFormat: false,
        // markedDatesMap: _markedDateMap,
        height: 350.0,
        // selectedDateTime: _currentDate2,
        showIconBehindDayText: true,
  //          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        markedDateShowIcon: true,
        markedDateIconMaxShown: 2,
        selectedDayTextStyle: TextStyle(
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          color: Colors.white,
        ),
        markedDateIconBuilder: (event) {
          return event.icon ?? Icon(Icons.help_outline);
        },
        // minSelectedDate: _currentDate.subtract(Duration(days: 360)),
        // maxSelectedDate: _currentDate.add(Duration(days: 360)),
        todayButtonColor: Color(0xff06538D),
        todayBorderColor: Color(0xff06538D),
        markedDateMoreShowTotal: true
    );
    super.initState();
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
                          _formShow || _formShowEdit || _formShowCategories
                              ? Container()
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Búsqueda de pedidos', style: TextStyle(
                                    fontSize: 16.0, color: Color(0xff0f538d),
                                    fontWeight: FontWeight.w600
                                  ),),
                                  SizedBox(height: 10.0),
                                  InputCallback(
                                      hintText: 'Identificacion, nombre, o N° de pedido',
                                      iconCallback: Icons.search,
                                      callback: () => {
                                            setState(() {
                                              _clientShow = true;
                                            })
                                          }),
                                  SizedBox(height: 10.0),
                                  InputCallback(
                                      hintText: '12/10/21 - 22/10/21',
                                      iconCallback: Icons.search,
                                      callback: () {
                                          showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Container(
                            height: 550.0,
                            width: _size.width * 0.8,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10.0),
                                Text(
                                  'Ingrese un rango de fechas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff06538D),
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height:12.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Desde',
                                          style: TextStyle(
                                            color: Color(0xff06538D),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w300
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                        GestureDetector(
                                          child: Container(
                                            width: _size.width * 0.35 - 8,
                                            height: 40.0,
                                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(width: 1.0,color: Color(0xffC7C7C7)),
                                              borderRadius: BorderRadius.circular(5.0)
                                            ),
                                            child: Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  ' -- / -- / --',
                                                  style: TextStyle(
                                                    color: Color(0xffC7C7C7),
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Color(0xffC7C7C7),
                                                  size: 16.0,)
                                              ],
                                            ),
                                          ),
                                          onTap: () => {
                                            showDatePicker(
                                              context: context, 
                                              initialDate: DateTime(2021), 
                                              firstDate: DateTime(2021), 
                                              lastDate: DateTime(2022))
                                          },
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Hasta',
                                          style: TextStyle(
                                            color: Color(0xff06538D),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w300
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                        GestureDetector(
                                          child: Container(
                                            width: _size.width * 0.35 - 8,
                                            height: 40.0,
                                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(width: 1.0,color: Color(0xffC7C7C7)),
                                              borderRadius: BorderRadius.circular(5.0)
                                            ),
                                            child: Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  ' -- / -- / --',
                                                  style: TextStyle(
                                                    color: Color(0xffC7C7C7),
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Color(0xffC7C7C7),
                                                  size: 16.0,)
                                              ],
                                            ),
                                          ),
                                          onTap: () => {
                                            showDatePicker(
                                              context: context, 
                                              initialDate: DateTime(2021), 
                                              firstDate: DateTime(2021), 
                                              lastDate: DateTime(2022))
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  child: _calendarCarousel,
                                ),
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
                                              'Limpiar',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          onTap: () {},
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
                    );     
                                          }),
                                ],
                              ),
                          SizedBox(height: 10.0),
                          _clientShow ? _client(context) : Container(),
                          _formShow ? _form(context) : Container(),
                          _formShowEdit ? _formEdit(context) : Container(),
                          _formShowCategories ? _formCategories(context) : Container(),
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
        Text('Se encontraron 6 resultados',
            style: TextStyle(
                color: Color(0xff0f538d),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic)),
        SizedBox(height: 10.0),
        ItemOrder(callback: ()=> {
          setState(() {
                    _clientShow = false;
                    _formShow = true;
                  })
        }),
        SizedBox(height: 10.0),
        ItemOrder(callback: ()=> {
          setState(() {
                    _clientShow = false;
                    _formShow = true;
                  })
        }),
        SizedBox(height: 10.0),
        ItemOrder(callback: ()=> {
          setState(() {
                    _clientShow = false;
                    _formShow = true;
                  })
        }),
        SizedBox(height: 10.0),
        ItemOrder(callback: ()=> {
          setState(() {
                    _clientShow = false;
                    _formShow = true;
                  })
        }),
        SizedBox(height: 10.0),
        ItemOrder(callback: ()=> {
          setState(() {
                    _clientShow = false;
                    _formShow = true;
                  })
        }),
        SizedBox(height: 10.0),
        ItemOrder(callback: ()=> {
          setState(() {
                    _clientShow = false;
                    _formShow = true;
                  })
        }),
        SizedBox(height: 10.0),
        ItemOrder(callback: ()=> {
          setState(() {
                    _clientShow = false;
                    _formShow = true;
                  })
        }),
        SizedBox(height: 10.0),
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

  Widget _form(BuildContext context) {
    final _size = MediaQuery.of(context).size;
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
          'Jimenez Pérez Juan Pablo',
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue),
        ),
        SizedBox(height: 15.0,),
        ItemOrder(callback: ()=>{},),
        SizedBox(height: 15.0,),
        Text(
          'Items del pedido',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(height:10.0),
        Text(
          'Este pedido tiene 4 items',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
              color: Color(0xff06538D)),
        ),
        SizedBox(height:10.0),
        ItemProductOrder(callback: (){
          showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Container(
                                height: 210.0,
                                width: _size.width * 0.8,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.0),
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.warning, color: Color(0xff06538D),size: 25.0),
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
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                      width: _size.width * 0.35 - 10,
                                      height: 41.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Color(0xffCB1B1B)),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
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
                                              'Eliminar',
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
                        );
        }),
        SizedBox(height:10.0),
        ItemProductOrder(callback: (){}),
        SizedBox(height:10.0),
        ItemProductOrder(callback: (){}),
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
                          'Editar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      onTap: () {
                        setState(() {
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

  Widget _formCategories(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nuevo pedido',
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff06538D)),
        ),
        SizedBox(height: 10.0),
        Text(
          'Jiménez Pérez Juan Pablo',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.blue),
        ),
        SizedBox(height: 10.0),
        InputCallback(
          hintText: 'Buscar categoria',
          iconCallback: Icons.search,
          callback: () => {}),
        SizedBox(height: 10.0),

        _formShowCategoriesList 
        
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
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
                  onTap: () => {
                    setState(() {
                          _formShowCategoriesList = false;
                        })
                  },
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
            SizedBox(height: 15.0),
            Text(
              'Abarrotes',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff06538D)),
            ),
            SizedBox(height: 10.0),
            Container(
              width: _size.width,
              height: 45.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
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
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Center(
                            child: Text('Arroz',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700
                                ),),
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5.0),
                      color:  Colors.blue,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        onTap: () => {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Center(
                            child: Text('Aceites',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700
                                ),),
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5.0),
                      color:  Colors.blue,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        onTap: () => {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Center(
                            child: Text('Azúcares y endulzantes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700
                                ),),
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5.0),
                      color:  Colors.blue,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        onTap: () => {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Center(
                            child: Text('Granos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700
                                ),),
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(5.0),
                      color:  Colors.blue,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5.0),
                        onTap: () => {},
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Center(
                            child: Text('Pastas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700
                                ),),
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            _formShowCategoriesAdd ? ItemCategoryOrderEdit(): ItemCategoryOrder(callback: ()=> {
              setState(() {
                _formShowCategoriesAdd = true;
              })
            }),
            SizedBox(height: 10.0),
            ItemCategoryOrder(callback: ()=> {}),
            SizedBox(height: 10.0),
            ItemCategoryOrder(callback: ()=> {}),
          ],
        )
        
        : Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Image(image: AssetImage('assets/images/Grupo 326.png'),width: _size.width* 0.5 - 25),
                  onTap: () => {
                    setState(() {
                          _formShowCategoriesList = true;
                        })
                  },  
                ),
                Image(image: AssetImage('assets/images/Grupo 272.png'),width: _size.width* 0.5 - 25,)
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(image: AssetImage('assets/images/Grupo 327.png'),width: _size.width* 0.5 - 25,),
                Image(image: AssetImage('assets/images/Grupo 279.png'),width: _size.width* 0.5 - 25,)
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(image: AssetImage('assets/images/Grupo 329.png'),width: _size.width* 0.5 - 25,),
                Image(image: AssetImage('assets/images/Grupo 277.png'),width: _size.width* 0.5 - 25,)
              ],
            )
          ],
        ),


        SizedBox(height: 20.0),
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
        SizedBox(height: 20.0),
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
                          _formShowCategories = false;
                          _formShowEdit = true;
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
                      color: _formShowCategoriesAdd ? Colors.blue : Color(0xff707070)),
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
                      onTap: _formShowCategoriesAdd 
                      ? () {
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
                                      'Edición de pedido exitosa',
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
                                            _clientShow = false;
                                            _formShow = false;
                                            _formShowEdit = false;
                                            _formShowCategories = false;
                                            _formShowCategoriesList = false;
                                            _formShowCategoriesAdd = false;
                                            _checked = false;
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
                      
                      : () {
                        showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Container(
                            height: 200.0,
                            width: _size.width * 0.7,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10.0),
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
                                  'Debes asignar productos para realizar el pedido',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      height: 1.4,
                                      color: Color(0xff06538D),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 20.0),
                                Container(
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
        SizedBox(height: 10.0,),
        _itemForm(context, 'Pedido N°', 'Automático'),
        _itemSelectForm(context, 'Fecha', '12/01/21',
          ''),
        _itemForm(context, 'Nombre', 'Jiménez Pérez Juan Pablo'),
        _itemSelectForm(context, 'Dir. envío factura', 'Cr 74 # 37 - 38',
            ''),
        _itemSelectForm(context, 'Dir. envío mercancía', 'Cr 74 # 37 - 38',
        ''),
        _itemForm(context, 'Orden de compra', ''),
        _itemSelectForm(context, 'Forma de pago', '7 días',
        ''),
        SizedBox(height: 30.0,),
        Container(
          height: 1,
          width: _size.width,
          color: Color(0xffC7C7C7),
        ),
        SizedBox(height: 30.0,),
        Text('Crédito',
        style: TextStyle(
          color: Colors.blue,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w700,
          fontSize: 16.0
        )),
        SizedBox(height:10.0),
        _itemForm(context, 'Cupo crédito', '1.200.000'),
        _itemSelectForm(context, 'Total Cartera', '347.281',
        ''),
        SizedBox(height: 50.0,),
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
                          //aqui
                          _formShow = true;
                          _formShowEdit = false;
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
                        });
                      },
                    ),
                  ),
                ))
          ],
        ),
        SizedBox(height: 10.0,)
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
