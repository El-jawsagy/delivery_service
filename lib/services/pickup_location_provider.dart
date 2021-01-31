import 'dart:convert';

import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/utilities/API/api_paths.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/bosta_clone_app/lib/model/pickup/pickup_location_model.dart';

class PickUpLocationProvider extends ChangeNotifier {
  AllStates _pickupsLocationState = AllStates.Init;
  // AllStates _createPickupState = AllStates.Init;
  String _errorMassage, _message;
  int statusCodeGet, statusCodeCreate;
  List<PickupLocationModel> _pickupsLocation = [];

  PickupLocationModel
      _selectedPickupLocation; // PickupLocationModel _singlePickup;

  PickUpLocationProvider() {
    statusCodeGet = 0;
  }

  List<PickupLocationModel> get allPickupsLocation => _pickupsLocation;

  PickupLocationModel get selectedLocation => _selectedPickupLocation;

  String get error => _errorMassage;

  String get message => _message;

  AllStates get stateOfPickupLocation => _pickupsLocationState;

  // AllStates get stateOfCratePickupLocation => _createPickupState;

  Future<bool> getAllPickupsLocation() async {
    statusCodeGet = 0;
    _pickupsLocation.clear();
    _selectedPickupLocation = PickupLocationModel(
      id: 0,
      name: await Preference.getLanguage() == "ar" ? "اختار" : "choose",
    );
    _pickupsLocation.add(_selectedPickupLocation);
    notifyListeners();
    try {
      String url = APIPaths.pickupsLocation +
          "?locale=${await Preference.getLanguage()}";
      print(url);

      _pickupsLocationState = AllStates.Loading;
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

      var data = jsonDecode(response.body);
      statusCodeGet = response.statusCode;
      if (response.statusCode == 200) {
        List<PickupLocationModel> tempPickups = data
            .map<PickupLocationModel>(
                (item) => PickupLocationModel.fromJson(item))
            .toList();
        _pickupsLocation.addAll(tempPickups);
        _pickupsLocationState = AllStates.Done;
        notifyListeners();
        return true;
      } else if (response.statusCode != 200) {
        _errorMassage = data["message"];
        _pickupsLocationState = AllStates.Done;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _pickupsLocationState = AllStates.Done;
    notifyListeners();
    return false;
  }



  selectPickUpLocation(location) {
    for (var i in _pickupsLocation) {
      if (i.id == location) {
        _selectedPickupLocation = i;
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
//     _createPickupState = AllStates.Loading;
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
//       _createPickupState = AllStates.Done;
//       notifyListeners();
//       return true;
//     } else if (response.statusCode != 201) {
//       _errorMassage = data["message"];
//       _createPickupState = AllStates.Done;
//       notifyListeners();
//       return false;
//     }
//   } catch (e) {
//     throw "we have an error";
//   }
//   _createPickupState = AllStates.Done;
//   notifyListeners();
//   return false;
// }