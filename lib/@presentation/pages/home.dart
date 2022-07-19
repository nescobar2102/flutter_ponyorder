import 'package:app_pony_order/@presentation/components/btnForm.dart';
import 'package:app_pony_order/@presentation/components/btnSmall.dart';
import 'package:app_pony_order/@presentation/components/inputCallback.dart';
import 'package:app_pony_order/@presentation/components/itemCategoryOrderEdit.dart';
import 'package:app_pony_order/@presentation/components/itemCategoryOrderHistoryRecibo.dart';
import 'package:app_pony_order/@presentation/components/itemClient.dart';
import 'package:app_pony_order/@presentation/components/itemDocumentClient.dart';
import 'package:app_pony_order/@presentation/components/itemProductOrder.dart';
import 'package:app_pony_order/@presentation/components/itemProductOrderHistory.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _clientShow = false;
  bool _formShow = false;
  bool _formOrderShow = false;
  bool _formRecipeShow = false;
  bool _formHistoryShow = false;
  bool _formNewClientShow = false;
  bool _checkedCartera = true;
  bool _checkedPedido = false;
  bool _checkedRecibo = false;
  bool? _checked = false;
  bool isOnline = true;
  bool _isLoading = false;
  String _nit = '900054835';
  //data
  bool focus = false;
  late String _search = '@';
  late int _count;
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

  List<Map<String, dynamic>> _itemsTypeDoc = [
    {"value": "", "label": "Seleccione"},
    {"value": "13", "label": "Cédula de Ciudadanía"},
    {"value": "31", "label": "Número de indentificación Tributaria - Nit"}
  ];
  List<Map<String, dynamic>> _itemsDepartamento = [
    {"value": "", "label": "Seleccione"},
    {"value": "11", "label": "Bogota"},
    {"value": "05", "label": "Antioquia"},
    {"value": "76", "label": "Valle del Cauca"}
  ];
  List<Map<String, dynamic>> _itemsClasification = [
    {"value": "", "label": "Seleccione"}
  ];
  List<Map<String, dynamic>> _itemsMedioContacto = [
    {"value": "", "label": "Seleccione"},
    {"value": "01", "label": "Página Web"},
    {"value": "02", "label": "Email marketing"},
    {"value": "03", "label": "Referido"}
  ];
  List<Map<String, dynamic>> _itemsZona = [
    {"value": "", "label": "Seleccione"},
    {"value": "01", "label": "ZONA NORTE"},
    {"value": "02", "label": "ZONA PACIFICA"}
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

  @override
  void initState() {
    super.initState();
    print("----------iniciando");
    searchClient();
  }

  /// This implementation is just to simulate a load data behavior
  /// from a data base sqlite or from a API
  ///
  /////api
  Future getItemTypeIdentication() async {
    final response = await http
        .get(Uri.parse("http://localhost:3000/app_tipoidentificacion_all"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object object $data");
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  Future getItemDepartamento() async {
    final response =
        await http.get(Uri.parse("http://localhost:3000/app_depto/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object app_depto $data");

      setState(() {
        //_item_type_identification = data;
      });
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  Future getItemClasification() async {
    final response = await http
        .get(Uri.parse("http://localhost:3000/app_tipoidentificacion_all"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object object $data");

      setState(() {
        //_item_type_identification = data;
      });
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  Future getItemMedioContacto() async {
    final response = await http
        .get(Uri.parse("http://localhost:3000/app_medioContacto/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object app_medioContacto $data");

      setState(() {
        //_item_type_identification = data;
      });
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  Future getItemZona() async {
    final response =
        await http.get(Uri.parse("http://localhost:3000/app_zona/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object app_zona $data");
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  Future getItemCiudad() async {
    final response =
        await http.get(Uri.parse("http://localhost:3000/app_ciudades/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object object $data");
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  Future getItemBarrio() async {
    final response =
        await http.get(Uri.parse("http://localhost:3000/app_barrio/$_nit"));

    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];

      print("object app_barrio $data");

      setState(() {
        //_item_type_identification = data;
      });
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }
//fin data

  final myControllerSearch = TextEditingController();

  final GlobalKey<ScaffoldState> _drawerscaffoldkey =
      new GlobalKey<ScaffoldState>();

  Future<void> searchClient() async {
    print("searchClient------------------------------ $_search");
    _body = {
      'nit': _nit,
      'nombre': (_search.isNotEmpty && _search != '') ? _search : null,
    };
    final response = await http
        .post(Uri.parse("http://localhost:3000/clientes"), body: (_body));
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      _datClient = jsonResponse['data'];
      _count = jsonResponse['count'];
      setState(() {
        if (_count > 0) {
          print("mosrtart el clienteeeeeeeeeeeeeeeeeee $_datClient");
          _clientShow = true;
          _clientShow ? _client(context, _datClient) : Container();
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));

      //  Navigator.pushNamed(context, 'home');
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  Future<void> _saveClient() async {
    print("Save client");
    print('Entrando a save clientes $_value_itemsTypeDoc');

    final response =
        await http.post(Uri.parse("http://localhost:3000/nuevo_cliente_app"),
            body: ({
              "id_tercero": myControllerNroDoc.text,
              "id_sucursal_tercero": "1",
              "id_tipo_identificacion": _value_itemsTypeDoc,
              "dv": myControllerDv.text,
              "nombre": myControllerPrimerNombre.text,
              "direccion": myControllerDireccion.text,
              "id_pais": "57",
              "id_depto": _value_itemsDepartamento,
              "id_ciudad": _value_itemsCiudad,
              "id_barrio": _value_itemsBarrio,
              "telefono": myControllerTelefono.text,
              "nombre_sucursal": myControllerRazonSocial.text,
              "primer_apellido": myControllerPrimerApellido.text,
              "segundo_apellido": myControllerSegundoApellido.text,
              "primer_nombre": myControllerPrimerNombre.text,
              "segundo_nombre": myControllerSegundoNombre.text,
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
                    // width: _size.width,
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      );
      setState(() {
        _clientShow = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));

      //  Navigator.pushNamed(context, 'home');
    } else {
      print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$msg")));
    }
  }

  // Perform login
  void validateAndSubmit() {
    print('Entrando a buscar clientes');
    _search = myControllerSearch.text;
    setState(() {
      print("buscar cliente");
      _isLoading = true;
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
          endDrawer: _shoppingCart(context),
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
                                  _formNewClientShow
                              ? Container()
                              : TextField(
                                  controller: myControllerSearch,
                                  decoration: InputDecoration(
                                    hintText: 'Buscar cliente',
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
                                ),
                          SizedBox(height: 10.0),
                          _clientShow
                              ? _client(context, _datClient)
                              : Container(),
                          _formShow ? _form(context) : Container(),
                          _formOrderShow ? _formOrder(context) : Container(),
                          _formRecipeShow ? _formRecipe(context) : Container(),
                          _formHistoryShow
                              ? _formHistory(context)
                              : Container(),
                          _formNewClientShow
                              ? _formNewClient(context)
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

  void callbackOrder() {
    //pedido
    setState(() {
      _formOrderShow = true;
      _clientShow = false;
    });
  }

  void callbackHistory() {
    //historial
    setState(() {
      _formHistoryShow = true;
      _clientShow = false;
    });
  }

  void callbackRecipe() {
    //recibo
    setState(() {
      _clientShow = false;
      _formRecipeShow = true;
    });
  }

  Widget _client(BuildContext context, data) {
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
                    //_getValue();
                    getItemTypeIdentication();
                    getItemDepartamento();
                    getItemClasification();
                    getItemMedioContacto();
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
                Text('Juan3 Pablo Jimenez',
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
            'Jiménez Pérez Juan4 Pablo',
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
      // height: _size.height - AppBar().preferredSize.height - 70,
      width: _size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clientes / Nuevo reciboo',
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
                'Jiménez Pérez Juan5 Pablo',
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
                SizedBox(
                  height: 20.0,
                ),
                ItemDocumentClient(callback: () {}),
                SizedBox(
                  height: 10.0,
                ),
                ItemDocumentClient(callback: () {}),
                SizedBox(
                  height: 10.0,
                ),
                ItemDocumentClient(callback: () {}),
                SizedBox(
                  height: 10.0,
                ),
                ItemDocumentClient(callback: () {}),
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
                          callback: () {}),
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
              _itemForm(
                context,
                'Recibo N°',
                '14408',
                null,
              ),
              ElevatedButton(onPressed: _pickDateDialog, child: Text('Fecha')),
              SizedBox(height: 10),
              _itemForm(
                  context,
                  '',
                  _selectedDate ==
                          null //ternary expression to check if date is null
                      ? 'No date was chosen!'
                      : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  null),
              _itemForm(context, 'Nombre', 'Jiménez Pérez Juan6 Pablo', null),
              _itemForm(context, 'Total cartera', '22554', null),
              _itemSelectForm(
                  context, 'Banco', 'Banco de occidente', 'Selecciona'),
              _itemSelectForm(context, 'N° cheque', '', 'Selecciona '),
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
        _itemForm(context, 'Pedido', 'Automático', null),
        _itemSelectForm(context, 'Fecha', '12/10/21', 'Selecciona fecha'),
        _itemForm(context, 'Nombre', 'Jiménez Pérez Juan1 Pablo', null),
        _itemSelectForm(context, 'Dir. envío factura', 'Cr 74 # 37 - 38',
            'Selecciona fecha'),
        _itemSelectForm(context, 'Dir. envío mercancía', 'Cr 74 # 37 - 38',
            'Selecciona fecha'),
        _itemForm(context, 'Orden de compra', '', null),
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
        _itemForm(context, 'Cupo crédito', '1.200.000', null),
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
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          initialValue: 'circle',
          icon: Icon(Icons.format_shapes),
          labelText: 'Tipo de documento',
          items: _itemsTypeDoc,
          onChanged: (val) => setState(() => _value_itemsTypeDoc = val),
          // onChanged: (val) => print(val),
          onSaved: (val) => print(val),
          //  onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        _itemForm(context, 'N° de documento', '', myControllerNroDoc),
        _itemForm(context, 'DV.', 'PersonaNatural', myControllerDv),
        _itemForm(context, 'Primer nombre', '', myControllerPrimerNombre),
        _itemForm(context, 'Segundo nombre', '', myControllerSegundoNombre),
        _itemForm(context, 'Primer apellido', '', myControllerPrimerApellido),
        _itemForm(context, 'Segundo apellido', '', myControllerSegundoApellido),
        _itemForm(context, 'Razón social', '', myControllerRazonSocial),
        _itemForm(context, 'Dirección', '', myControllerDireccion),
        _itemForm(context, 'Email', '', myControllerEmail),
        _itemForm(context, 'Teléfono fijo', '', myControllerTelefono),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          initialValue: 'circle',
          icon: Icon(Icons.format_shapes),
          labelText: 'Clasificación',
          items: _itemsClasification,
          onChanged: (val) => setState(() => _value_itemsClasification = val),
          //onChanged: (val) => print(val),
          //onSaved: (val) => print(val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          initialValue: 'circle',
          icon: Icon(Icons.format_shapes),
          labelText: 'Medio contacto',
          items: _itemsMedioContacto,
          onChanged: (val) => setState(() => _value_itemsMedioContacto = val),
          //onChanged: (val) => print(val),
          //onSaved: (val) => print(val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          initialValue: 'circle',
          icon: Icon(Icons.format_shapes),
          labelText: 'Zona',
          items: _itemsZona,
          onChanged: (val) => setState(() => _value_itemsZona = val),
          //onChanged: (val) => print(val),
          //onSaved: (val) => print(val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          initialValue: 'circle',
          icon: Icon(Icons.format_shapes),
          labelText: 'Departamento',
          items: _itemsDepartamento,
          onChanged: (val) => setState(() => _value_itemsDepartamento = val),
          //onChanged: (val) => print(val),
          //onSaved: (val) => print(val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          initialValue: 'circle',
          icon: Icon(Icons.format_shapes),
          labelText: 'Ciudad',
          items: _itemsCiudad,
          onChanged: (val) => setState(() => _value_itemsCiudad = val),
          //onChanged: (val) => print(val),
          //onSaved: (val) => print(val),
          onSaved: (val) => setState(() => _valueSaved = val ?? ''),
          validator: (val) {
            setState(() => _valueToValidate = val ?? '');
            return null;
          },
        ),
        SelectFormField(
          type: SelectFormFieldType.dropdown, // or can be dialog
          initialValue: 'circle',
          icon: Icon(Icons.format_shapes),
          labelText: 'Barrio',
          items: _itemsBarrio,
          onChanged: (val) => setState(() => _value_itemsBarrio = val),
          //onChanged: (val) => print(val),
          //onSaved: (val) => print(val),
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
      BuildContext context, String label, String hintText, controller) {
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

  // Widget _ItemClient(BuildContext context) {
  Widget _ItemClient(hintText, data) {
    print('-----------Howdy, ${data['nombre']}!');
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
                          onTap: callbackOrder,
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
                          onTap: callbackRecipe,
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
                          onTap: callbackHistory,
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
}
