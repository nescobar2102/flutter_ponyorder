import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

 
import '../../db/operationDB.dart';
import '../../models/usuario.dart';

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
  String _url = 'http://178.62.80.103:5000';
  final myControllerUsers = TextEditingController();
  final myControllerPassword = TextEditingController();

  late String _user, _password;

  bool focus = false;
  bool focusPass = false;
  bool isOnline = false;
  bool _isLoading = false;
  final String hintText = '';
  bool _validate = true;
  bool _validatePass = true;
  bool _passwordVisible = false;

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

  // Perform login
  void validateAndSubmit() async {
    _user = myControllerUsers.text;
    _password = myControllerPassword.text;

    _user.isEmpty ? _validate = false : _validate = true;
    _password.isEmpty ? _validatePass = false : _validatePass = true;
      if (_validate && _validatePass) {
        _submitDialog(context);
          final user =  await OperationDB.getLogin(_user.trim());
          if (user != false) {
            final pass =  await OperationDB.getLoginPassw(_user.trim(),_password.trim());
            if (pass) {
                    setState(() {
                        savePref(1, _user.trim(), user[0]['nit'],
                            user[0]['id_tipo_doc_pe'], user[0]['id_tipo_doc_rc']);

                        _loginStatus = LoginStatus.signIn;
                        });
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'home');
                } else {
                  Navigator.pop(context);
                  _showBarMsg("Clave Inválida",false);
                }
          } else {
            Navigator.pop(context);
            _showBarMsg("Usuario no existe",false);
          }
      }else {
        if(!_validate){
          _showBarMsg("Ingrese el usuario",true);
        }else
        if(!_validatePass){
          _showBarMsg("Ingrese la clave",true);
        }
      }
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
    //  bool isOnline = await hasNetwork();
    print('isOnline : $isOnline');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
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
    getUsuariosSincronizacion();    
    getPref();
  }

  /////api obtiene todos los usuarios de la bd postgres
  Future getUsuariosSincronizacion() async {
    print("ingresa a la sincronizacion");
    final response =
    await http.get(Uri.parse("$_url/users_all"));
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var success = jsonResponse['success'];
    var msg = jsonResponse['msg'];
    if (response.statusCode == 200 && success) {
      var data = jsonResponse['data'];
      if(data.length > 0) {
      print("la data que se obtiene de la api $data");
     await  OperationDB.deleteDataUsuario();
      for (int i = 0; i < data.length; i++) {
          final user = Usuario(id:i+1,usuario: data[i]['usuario'],
                password:  data[i]['clave'],
                nit:  data[i]['nit'],
                id_tipo_doc_pe:  data[i]['id_tipo_doc_pe'],
                id_tipo_doc_rc:  data[i]['id_tipo_doc_rc']);
              print("manda a inserta usuariosssss $user");
              await OperationDB.insertUser(user) ;
        }
      final allUsuarios=   await OperationDB.usuariosAll();
      print("Allusuaruis $allUsuarios");
      } 
    } else {
      _showBarMsg(msg,false);
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
          child: new ElevatedButton(
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

  Widget textFormFieldPass(hintText, controller, icon,  maxLength) {
    final _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Focus(
        onFocusChange: (e) {
          setState(() {
            print("eee $e");
            focusPass = e;
          });
        },
        child: TextField(
          controller: controller,
          autofocus: false,
          textInputAction: TextInputAction.done,
            onSubmitted: (String str){
              setState((){
                validateAndSubmit();
              });
            },
          style: TextStyle(fontSize: 16.5),
          obscureText: !_passwordVisible,
          decoration: InputDecoration(
            errorText:
            focusPass  && controller.text.isEmpty ? 'Es requerido' : null,
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
                color: focusPass ? Color(0xff0090ce) : Color(0xffc7c7c7),
              ),
            ),
            hintStyle: TextStyle(fontSize: 17.0, color: Color(0xffc7c7c7)),
            labelStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
            alignLabelWithHint: true,
            suffixIcon: InkWell(
              onTap: _togglePasswordView,
              child: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }
  
  Widget textFormField(hintText, controller, icon,  maxLength) {
    final _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Focus(
        onFocusChange: (e) {
          setState(() {
            print("eee usuario $e");
            focus = e;
          });
        },
        child: TextField(
          controller: controller,
          autofocus: false,
          style: TextStyle(fontSize: 16.5),
          obscureText: false,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            errorText:
             focus  && controller.text.isEmpty ? 'Es requerido' : null,
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
                      'Versión D-18-11-2022',
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
              textFormField('Ingrese su usuario', myControllerUsers,
                  Icons.account_circle,  20 ),
              SizedBox(height: 25.0),
              Text(
                'Contraseña',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 5.0),
              textFormFieldPass('* * * * * * * *', myControllerPassword,
                  Icons.vpn_key, 20),
              SizedBox(
                height: 20.0,
              ),
              showPrimaryButton(),
            ],
          ),
        ),
      ),
    );
  }

  savePref(int value, String user, String nit, String idPedidoUser,
      String idReciboUser) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt("value", value);
      prefs.setString("user", user);
      prefs.setString("nit", nit);
      prefs.setString("idPedidoUser", idPedidoUser);
      prefs.setString("idReciboUser", idReciboUser);
    });
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
