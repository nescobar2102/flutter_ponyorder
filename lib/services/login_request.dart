import 'dart:async';

import 'package:app_pony_order/models/user.dart';
import 'package:app_pony_order/data/CtrQuery/login_ctr.dart';
import 'package:app_pony_order/utils/api_client.dart';

class LoginRequest {
  LoginCtr con = new LoginCtr();

  Future<User> getLogin(String username, String password) {
    var result = con.getLogin(username, password);

    return result;
  }
 
  }
  