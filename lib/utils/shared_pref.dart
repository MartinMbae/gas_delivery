import 'package:shared_preferences/shared_preferences.dart';

Future setUserId(String id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('id', id);
}

Future<String?> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('id');
}

Future setPhoneNumber(String phone) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('phone', phone);
}

Future<String?> getPhoneNumber() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('phone');
}

Future setName(String name) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('name', name);
}

Future<String?> getName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('name');
}

Future setEmail(String email) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('email', email);
}

Future<String?> getEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('email');
}

Future<void> clearAllPreferences() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.clear();
}
