import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_pony_order/models/user.dart';
import 'package:app_pony_order/services/login_request.dart';
import 'package:app_pony_order/services/login_response.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0xfff8f8f8);
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum LoginStatus { notSignIn, signIn }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => Duration(milliseconds: 2250);
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final myControllerUsers = TextEditingController();
  final myControllerPassword = TextEditingController();

  late String _user, _password;

  bool focus = false;
  bool isOnline = true;
  bool _isLoading = false;
  final String hintText = '';

  // Perform login
  void validateAndSubmit() {
    print('Entrando a validar');
    _user = myControllerUsers.text;
    _password = myControllerPassword.text;

    setState(() {
      _isLoading = true;
      login();
    });
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  var value;
  getPref() async {
   //   bool isOnline = await hasNetwork();
    print('isOnline : $isOnline');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
      print('_loginStatus body: $_loginStatus');

      if (_loginStatus == LoginStatus.signIn) {
        // Navigator.pushNamed(context, 'home');
      }
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future<void> login() async {
    if (myControllerUsers.text.isNotEmpty &&
        myControllerPassword.text.isNotEmpty) {
      final response = await http.post(Uri.parse("http://localhost:3000/login"),
          body: ({
            'username': myControllerUsers.text,
            'password': myControllerPassword.text
          }));
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var success = jsonResponse['success'];
      var msg = jsonResponse['msg'];
      if (response.statusCode == 200 && success) {
        var data = jsonResponse['data'];
        print('Number of books about http: $msg $success $data.');
        savePref(1, myControllerUsers.text, myControllerPassword.text);
        _loginStatus = LoginStatus.signIn;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$msg")));

        Navigator.pushNamed(context, 'home');
      } else {
        print("Wronggooooooooooooooooooooooooooo en la apli intente de nuevo");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$msg")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Ingrese las credenciales")));
    }
  }
  //visual

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          _background(context),
          CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                _form(context),
              ]))
            ],
          ),
        ],
      ),
    );
  }

  //nn
  Widget showPrimaryButton() {
    final _size = MediaQuery.of(context).size;
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          width: _size.width,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0)),
            color: Color(0xff0091CE),
            child: Center(
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget _background(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      height: 500,
      color: Colors.white,
      child: CustomPaint(
        painter: CurvePainter(),
      ),
    );
  }

  Widget _backgroundBottom(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      height: 350,
      color: Colors.white,
      child: CustomPaint(
        painter: CurvePainter(),
      ),
    );
  }

  Widget textFormField(hintText, controller, icon) {
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
          autofocus: true,
          style: TextStyle(fontSize: 16.5),
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.only(top: 30, bottom: 0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Color(0xff0090ce),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Color(0xffc7c7c7), width: 1.2),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 12.0),
              child: Icon(
                icon,
                color: focus ? Color(0xff0090ce) : Color(0xffc7c7c7),
              ),
            ),
            hintStyle: TextStyle(fontSize: 17.0, color: Color(0xffc7c7c7)),
            labelStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
            alignLabelWithHint: true,
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _bar = MediaQuery.of(context).padding.top;
    //safeArea for android
    return SafeArea(
      bottom: false,
      top: true,
      child: Container(
        width: _size.width,
        height: _size.height - _bar,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Image(
                        image: AssetImage('assets/images/Logo version 1.png')),
                    Text(
                      'Versión D-18-11-2021',
                      style: TextStyle(
                          color: Color(0xff06538D),
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'Usuario',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5.0),
              textFormField(
                'Ingrese su usuario',
                myControllerUsers,
                Icons.account_circle,
              ),
              SizedBox(height: 25.0),
              Text(
                'Contraseña',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5.0),
              textFormField(
                '* * * * * * * *',
                myControllerPassword,
                Icons.vpn_key,
              ),
              SizedBox(
                height: 40.0,
              ),
              showPrimaryButton(),
            ],
          ),
        ),
      ),
    );
  }

  savePref(int value, String user, String pass) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt("value", value);
      prefs.setString("user", user);
      prefs.setString("pass", pass);
    });
  }
}
