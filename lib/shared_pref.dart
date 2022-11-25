import 'package:shared_preferences/shared_preferences.dart';
import 'package:task1/model/user_model.dart';

Future _pref = SharedPreferences.getInstance();

//set data
Future setSP(User user) async {
  final SharedPreferences sp = await _pref;
  sp.setString("username", user.username!);
  sp.setString("email", user.email!);
  sp.setInt("number", user.number!);
  sp.setString("gender", user.gender!);
  sp.setString("birthDate", user.birthDate!);
  sp.setString("password", user.password!);
}