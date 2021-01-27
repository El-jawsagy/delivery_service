import 'dart:convert';

import 'package:bosta_clone_app/model/pickup/person_model.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/utilities/API/api_paths.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonPickUpLocationProvider extends ChangeNotifier {
  AllStates _personPickupsLocationState = AllStates.Init;

  // AllStates _createPersonPickupState = AllStates.Init;
  String _errorMassage, _massage;
  int statusCodeGet, statusCodeCreate;
  List<PersonModel> _personPickupsLocation = [];
  PersonModel _selectedPersonPickupLocation;

  // PickupLocationModel _singlePickup;

  PersonPickUpLocationProvider() {
    statusCodeGet = 0;
  }

  List<PersonModel> get allPersonPickupsLocation => _personPickupsLocation;

  PersonModel get selectedPersonInLocation => _selectedPersonPickupLocation;

  String get error => _errorMassage;

  String get massage => _massage;

  AllStates get stateOfPersonPickupLocation => _personPickupsLocationState;

  // AllStates get stateOfCratePersonPickupLocation => _createPersonPickupState;

  Future<bool> getAllPersonInPickupsLocation(int locationId) async {
    statusCodeGet = 0;

    _personPickupsLocation.clear();
    _selectedPersonPickupLocation = PersonModel(
        id: 0,
        firstName: await Preference.getLanguage() == "ar" ? "اختار" : "choose",
        lastName: "");
    _personPickupsLocation.add(_selectedPersonPickupLocation);
    notifyListeners();
    try {
      String url = APIPaths.pickupsLocation +
          "/$locationId?locale=${await Preference.getLanguage()}";
      print(url);

      _personPickupsLocationState = AllStates.Loading;
      notifyListeners();

      var response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + await Preference.getToken()
        },
      );

      print(response.body);
      print(response.statusCode);

      var getResponse = jsonDecode(response.body);

      statusCodeGet = response.statusCode;
      if (response.statusCode == 200) {
        var data = getResponse["persons"];
        List<PersonModel> tempPersonInLocation = data.map<PersonModel>((item) {
          print(item);
          return PersonModel.fromJson(item);
        }).toList();
        print("i'am here");

        print(tempPersonInLocation);
        _personPickupsLocation.addAll(tempPersonInLocation);
        _personPickupsLocationState = AllStates.Done;
        notifyListeners();
        return true;
      } else if (response.statusCode != 200) {
        print(getResponse["message"]);

        _errorMassage = getResponse["message"];
        print(_errorMassage);
        _personPickupsLocationState = AllStates.Init;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _personPickupsLocationState = AllStates.Init;
    notifyListeners();
    return false;
  }


  selectPickUpLocation(personId) {
    for (var i in _personPickupsLocation) {
      if (personId == i.id) {
          _selectedPersonPickupLocation = i;
      }
    }
    notifyListeners();
  }
}
// Future<bool> createSinglePickup() async {
//   try {
//     String url = APIPaths.pickupsLocation +
//         "?locale=${await Preference.getLanguage()}";
//     print(url);
//
//     _createPersonPickupState = AllStates.Loading;
//     notifyListeners();
//
//     var response = await http.get(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Authorization": "Bearer " + await Preference.getToken()
//       },
//     );
//     print(response.body);
//     print(response.statusCode);
//
//     var data = jsonDecode(response.body);
//     statusCodeGet = response.statusCode;
//     if (response.statusCode == 201) {
//       _massage = data["message"];
//       _createPersonPickupState = AllStates.Done;
//       notifyListeners();
//       return true;
//     } else if (response.statusCode != 200) {
//       _errorMassage = data["message"];
//       _createPersonPickupState = AllStates.Done;
//       notifyListeners();
//       return false;
//     }
//   } catch (e) {
//     throw "we have an error";
//   }
//   _createPersonPickupState = AllStates.Done;
//   notifyListeners();
//   return false;
// }

