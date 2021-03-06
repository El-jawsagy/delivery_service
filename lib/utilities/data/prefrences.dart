import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isArabic = prefs.getString('lang');
    return isArabic;
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    return token;
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.get("name");
    return name;
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.get("email");
    return email;
  }
}

setLang(String lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lang", lang);
}
