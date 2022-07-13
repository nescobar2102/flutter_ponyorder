import 'package:app_pony_order/models/user.dart';
import 'dart:async';
import 'package:app_pony_order/data/database_helper.dart';

class LoginCtr {
  DatabaseHelper con = new DatabaseHelper();

//insertion
  Future<int> saveUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  //deletion
  Future<int> deleteUser(User user) async {
    var dbClient = await con.db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<User> getLogin(String user, String password) async {
    var dbClient = await con.db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM user WHERE username = '$user' and password = '$password'");
    if (res.length > 0) {
      print("aaaaaaaaaaaaaaaa");
      return new User.fromMap(res.first);
    }
    print("bbbbbbbbbbbbb");
    return User.fromMap({null});
  }

  /*
 Future<List<User>> getAllUser() async {
    var dbClient = await con.db;
    var res = await dbClient.query("user");
    List<User> list =
       res.length > 0 ? res.map((c) => User.fromMap(c)).toList() : null;

    return list;
  }*/
}
