import '../../Common/Constant.dart';
import 'dart:io';

class validateConexion {

   static Future<bool?> checkInternetConnection() async {
    bool value = false;
    try {
      final response = await InternetAddress.lookup('${Constant.Validate_URL}');
      if (response.isNotEmpty) {      
        value = true;
      }
    } on SocketException catch (err) {     
      value = false;
    }
 
    return value;
  }

}