class User {
  
  String nit;
  String clave;
  String usuario;
  
  User({this.nit, this.clave, this.usuario});
  User.empty();

  Map<String, dynamic> toMap() {
    return {'nit': nit, 'usuario': usuario, 'clave': clave};
  }
}
 