import 'dart:convert';

import 'package:bosta_clone_app/model/user_model.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/bosta_clone_app/lib/utilities/API/api_paths.dart';

class AuthProvider extends ChangeNotifier {
  AuthStates _authState = AuthStates.unAuthenticated;
  AuthStates _verifyCodeState = AuthStates.unAuthenticated;
  String _errorMessage;
  String _message;
  String _token;
  int _statusCodeOfResendCode;
  int _statusCodeOfVerifyCode;
  int _statusCode;

  UserModel _user;

  AuthProvider() {
    SharedPreferences.getInstance().then((value) {
      SharedPreferences preferences = value;
      if (preferences.getString("token") == null ||
          preferences.getString("token") == "null") {
        _token = preferences.getString("token");
        _authState = AuthStates.unAuthenticated;
        notifyListeners();
      } else {
        _token = preferences.getString("token");

        getUser(preferences.getString("token"));
      }
    });
  }

  UserModel get user => _user;

  String get error => _errorMessage;

  String get message => _message;

  String get token => _token;
  int get stateCode => _statusCode;

  AuthStates get state => _authState;
  AuthStates get verifyCodeState => _verifyCodeState;

  Future<bool> getUser(token) async {
    try {
      String url = APIPaths.user + "?locale=${await Preference.getLanguage()} ";
      _authState = AuthStates.authenticating;
      notifyListeners();
      print(url);
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + await Preference.getToken()
      });

      print(response.body);
      print(response.statusCode);

      _authState = AuthStates.authenticated;
      notifyListeners();
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _user = UserModel.fromJson(data);
        _authState = AuthStates.authenticated;

        return true;
      } else if (response.statusCode > 500) {
        _errorMessage = "can't reach server";
        _authState = AuthStates.unAuthenticated;
        notifyListeners();
      } else if (response.statusCode == 301 ||
          response.statusCode == 302 ||
          response.statusCode == 303 ||
          response.statusCode == 307 ||
          response.statusCode == 308) {
        _errorMessage = "redirect";
        _authState = AuthStates.unAuthenticated;
        notifyListeners();
      } else if (response.statusCode == 401) {
        _errorMessage = data["message"];
      }
    } catch (e) {
      throw "we have an error";
    }
    _authState = AuthStates.unAuthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> singIn(email, password) async {
    try {
      String url =
          APIPaths.signIn + "?locale=${await Preference.getLanguage()}";
      _authState = AuthStates.authenticating;
      notifyListeners();
      print({"email": email, "password": password});

      var response = await http.post(url,
          body: {"email": email, "password": password},
          headers: {"Accept": "application/json"});
      print(response.body);
      print(response.statusCode);
      _statusCode = response.statusCode;
      var data = jsonDecode(response.body);
      notifyListeners();

      if (response.statusCode == 200) {
        await setToken(data["token"]);
        print(Preference.getToken());
        _user = UserModel.fromJson(data["user"]);
        _authState = AuthStates.authenticated;
        notifyListeners();
        return true;
      } else if (response.statusCode != 200) {
        _errorMessage = data["message"];
        _authState = AuthStates.unAuthenticated;
        notifyListeners();
      }
    } catch (e) {
      throw "we have an error";
    }
    _authState = AuthStates.unAuthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> singUp(
    firstName,
    lastName,
    phone,
    email,
    password,
    subscriptionType,
  ) async {
    try {
      String url = APIPaths.signUp;
      _authState = AuthStates.authenticating;
      notifyListeners();
      Map<String, dynamic> formData = {
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": "+2$phone",
        "password_confirmation": password,
        "subscribtion_type": subscriptionType.toString(),
      };
      print({
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": "+2$phone",
        "password_confirmation": password,
        "subscribtion_type": subscriptionType,
      });
      print(url);
      var response = await http.post(
        url,
        body: formData,
        headers: {"Accept": "application/json"},
      );
      print(response.body);
      print(response.statusCode);

      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        setToken(data["token"]);
        _user = UserModel.fromJson(data["user"]);
        _authState = AuthStates.authenticated;
        notifyListeners();
        return true;
      } else if (response.statusCode == 422) {
        if (data.containsKey("first_name")) {
          _errorMessage = data["first_name"][0];
        } else if (data.containsKey("last_name")) {
          _errorMessage = data["last_name"][0];
        } else if (data.containsKey("email")) {
          _errorMessage = data["email"][0];
        } else if (data.containsKey("subscribtion_type")) {
          _errorMessage = data["subscribtion_type"][0];
        } else if (data.containsKey("phone_number")) {
          _errorMessage = data["phone_number"][0];
        } else if (data.containsKey("password")) {
          _errorMessage = data["password"][0];
        }
        _authState = AuthStates.unAuthenticated;
        notifyListeners();
        return false;
      } else if (response.statusCode != 201) {
        _errorMessage = data["message"];
        _authState = AuthStates.unAuthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _authState = AuthStates.unAuthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> verifyPhoneNumber(numberFromMessage) async {
    try {
      String url = APIPaths.verifyPhoneNumber +
          "?locale=${await Preference.getLanguage()}";
      _verifyCodeState = AuthStates.authenticating;
      notifyListeners();
      print({
        "verification_code": numberFromMessage,
      });

      var response = await http.post(url, body: {
        "verification_code": numberFromMessage,
      }, headers: {
        "Authorization": "Bearer " + await Preference.getToken(),
        "Accept": "application/json"
      });
      print(response.body);
      _statusCodeOfVerifyCode= response.statusCode;

      print(response.statusCode);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _verifyCodeState = AuthStates.authenticated;
        notifyListeners();
        return true;
      } else if (response.statusCode != 200) {
        _errorMessage = data["message"];
        _verifyCodeState = AuthStates.unAuthenticated;
        notifyListeners();
      }
    } catch (e) {
      throw "we have an error";
    }
    _verifyCodeState = AuthStates.unAuthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> resendVerifyCode() async {
    try {
      String url =
          APIPaths.resendCode + "?locale=${await Preference.getLanguage()}";
      _authState = AuthStates.authenticating;
      notifyListeners();

      var response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer " + await Preference.getToken(),
          "Accept": "application/json"
        },
      );
      print(response.body);
      _statusCodeOfResendCode = response.statusCode;
      print(response.statusCode);
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _message = data["message"];
        _authState = AuthStates.authenticated;
        notifyListeners();
        return true;
      } else if (response.statusCode != 200) {
        _errorMessage = data["message"];
        _authState = AuthStates.unAuthenticated;
        notifyListeners();
      }
    } catch (e) {
      throw "we have an error";
    }
    _authState = AuthStates.unAuthenticated;
    notifyListeners();
    return false;
  }

  Future<bool> logout() async {
    try {
      SharedPreferences.getInstance().then((value) async {
        SharedPreferences preferences = value;
        await preferences.remove("token");
      });
      _authState = AuthStates.unAuthenticated;
      notifyListeners();
    } catch (e) {
      throw "we have an error";
    }
  }
}

setToken(String token) async {
  print("i set token");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("finish");

  prefs.setString("token", token);
}
