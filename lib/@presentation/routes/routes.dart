import 'package:pony_order/@presentation/pages/home.dart';
import 'package:pony_order/@presentation/pages/login.dart';
import 'package:pony_order/@presentation/pages/menu.dart';
import 'package:pony_order/@presentation/pages/order.dart';
import 'package:pony_order/@presentation/pages/receipts.dart';
import 'package:pony_order/@presentation/pages/sale.dart';
import 'package:pony_order/@presentation/pages/units.dart';
import 'package:pony_order/@presentation/pages/visiteds.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    'login': (BuildContext context) => LoginPage(),
    'home': (BuildContext context) => HomePage(),
    'menu': (BuildContext context) => MenuPage(),
    'order': (BuildContext context) => OrderPage(),
    'receipts': (BuildContext context) => ReceiptsPage(),
    'units': (BuildContext context) => UnitsPage(),
    'visiteds': (BuildContext context) => VisitedsPage(),
    'sale': (BuildContext context) => SalePage()
  };
}
