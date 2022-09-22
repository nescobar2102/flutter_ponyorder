import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(delegate: SliverChildListDelegate([_list(context)]))
        ],
      ),
    );
  }

  Widget _list(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 30.0),
        width: _size.width,
        color: Colors.white,
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/Logo version 2.png')),
            SizedBox(height: 50.0),
            SizedBox(height: 1.0),
            _item(context, Icons.money, 'Transacciones',
                () => {Navigator.pushNamed(context, 'home')}),
            Container(
              width: _size.width,
              color: Colors.white,
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consultas',
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Color(0xff707070),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 1.0),
                        color: Color(0xff707070),
                        height: 1.5,
                        width: _size.width * 0.8)
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right_sharp,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            _item(context, Icons.document_scanner, 'Pedidos', () => {Navigator.pushNamed(context, 'order')}),
            SizedBox(height: 1.0),
            _item(
                context, Icons.text_snippet_rounded, 'Recibos de caja', () => {Navigator.pushNamed(context, 'receipts')}),
            SizedBox(height: 1.0),
            _item(context, Icons.attach_money_sharp, 'Cuota de venta', () => {Navigator.pushNamed(context, 'sale')}),
            SizedBox(height: 1.0),
            _item(context, Icons.shopping_bag_rounded, 'Unidades', () => {Navigator.pushNamed(context, 'units')}),
            SizedBox(height: 1.0),
            _item(context, Icons.remove_red_eye, 'Visitados', () => {Navigator.pushNamed(context, 'visiteds')}),
            SizedBox(height: 1.0),
            _item(context, Icons.backup, 'Sincronizacion', () => {Navigator.pushNamed(context, 'data')}),
            SizedBox(height: 1.0),
            Container(
              width: _size.width,
              color: Color(0xff06538D),
              child: ListTile(
                 onTap: () async {
 
                               SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                       preferences.clear();
                      preferences.setInt("value", 0);
                        Navigator.pushNamed(context, 'login');
                        Navigator.pushNamed(context, 'login');
                        
                        }, 
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                minLeadingWidth: 20.0,
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 25.0,
                ),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                trailing: Icon(
                  Icons.chevron_right_sharp,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context, IconData icon, String text, VoidCallback callback) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      color: Color(0xff0091CE),
      child: ListTile(
        onTap: callback,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        minLeadingWidth: 20.0,
        leading: Icon(
          icon,
          color: Colors.white,
          size: 25.0,
        ),
        title: Text(
          text,
          style: TextStyle(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(
          Icons.chevron_right_sharp,
          color: Colors.white,
          size: 25.0,
        ),
      ),
    );
  }
}
