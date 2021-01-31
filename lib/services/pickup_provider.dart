import 'dart:convert';

import 'package:bosta_clone_app/model/pickup/pickup_model.dart';
import 'package:bosta_clone_app/model/shipment/shipment_model.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/utilities/API/api_paths.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PickUpProvider extends ChangeNotifier {
  AllStates _pickupsState = AllStates.Init;
  AllStates _singlePickupState = AllStates.Init;
  AllStates _createPickupState = AllStates.Init;
  String _errorMessage, _message, _messageCreate;
  int _statusCodeGetAll,
      _statusCodeGetSingle,
      _statusCodeCreate,
      _singlePickupId;
  List<PickupModel> _pickups = [];
  PickupModel _singlePickup;
  int _counter = 1;

  PickUpProvider() {
    getAllPickups();
    _statusCodeGetAll = 0;
    _statusCodeGetSingle = 0;
    _statusCodeCreate = 0;
  }

  List<PickupModel> get allPickups => _pickups;

  PickupModel get pickup => _singlePickup;

  int get pickupId => _singlePickupId;

  String get error => _errorMessage;

  String get message => _message;

  String get messageCreate => _messageCreate;

  AllStates get stateOfPickups => _pickupsState;

  AllStates get stateOfSinglePickup => _singlePickupState;

  AllStates get stateOfCreatePickup => _createPickupState;

  int get responseCodeOfPickups => _statusCodeGetAll;

  int get responseCodeOfSinglePickup => _statusCodeGetSingle;

  int get responseCodeOfCreatePickup => _statusCodeCreate;

  Future<bool> getAllPickups() async {
    try {
      String url = APIPaths.pickups +
          "?locale=${await Preference.getLanguage()}&page=$_counter";
      print(url);

      _pickupsState = AllStates.Loading;
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
      _pickupsState = AllStates.Done;
      notifyListeners();
      var data = jsonDecode(response.body);
      _statusCodeGetAll = response.statusCode;
      if (response.statusCode == 200) {
        if (_counter == 1) {
          _pickups = data
              .map<PickupModel>((item) => PickupModel.fromJson(item))
              .toList();
        } else {
          _pickups.addAll(data
              .map<PickupModel>((item) => PickupModel.fromJson(item))
              .toList());
        }
        return true;
      } else if (response.statusCode != 200) {
        _errorMessage = data["message"];
        _pickupsState = AllStates.Done;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _pickupsState = AllStates.Done;
    notifyListeners();
    return false;
  }

  Future<bool> getSinglePickup(int pickupId) async {
    _statusCodeGetSingle = 0;
    _singlePickupId = pickupId;
    notifyListeners();

    try {
      String url = APIPaths.pickups +
          "/$pickupId" +
          "?locale=${await Preference.getLanguage()}";
      print(url);

      _singlePickupState = AllStates.Loading;
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
      _singlePickupState = AllStates.Done;
      notifyListeners();
      var data = jsonDecode(response.body);
      _statusCodeGetSingle = response.statusCode;
      if (response.statusCode == 200) {
        _singlePickup = PickupModel.fromJson(data["pickup"]);
        _singlePickup.shipment = ShipmentModel.fromJson(data["shipment"]);
        return true;
      } else if (response.statusCode > 500) {
        _errorMessage = data["message"];
        return false;
      } else if (response.statusCode == 422) {
        _errorMessage = data["message"];
      } else if (response.statusCode == 401) {
        _errorMessage = data["message"];
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _singlePickupState = AllStates.Done;
    notifyListeners();
    return false;
  }

  Future<bool> createSinglePickup({
    shipmentId,
    pickupLocationId,
    personId,
    repeat,
    repeatStartDate,
    repeatEndDate,
    repeatType,
    date,
    notes,
  }) async {
    _statusCodeCreate = 0;
    notifyListeners();

    Map<String, dynamic> bodyOfData = {
      "shipment_id": shipmentId.toString(),
      "pickup_location_id": pickupLocationId.toString(),
      "person_id": personId.toString(),
      "repeat": repeat.toString(),
      "repeat_start_date": repeatStartDate.toString(),
      "repeat_end_date": repeatEndDate.toString(),
      "repeat_type": repeatType.toString(),
      "date": date.toString(),
      "notes": notes.toString(),
    };
    try {
      String url =
          APIPaths.pickups + "?locale=${await Preference.getLanguage()}";
      print(url);

      _singlePickupState = AllStates.Loading;
      notifyListeners();

      var response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + await Preference.getToken()
        },
        body: bodyOfData,
      );
      print(response.body);
      print(response.statusCode);
      var data = jsonDecode(response.body);
      _statusCodeCreate = response.statusCode;
      if (response.statusCode == 201) {
        _messageCreate = data["message"];
        _createPickupState = AllStates.Done;
        notifyListeners();
        return true;
      } else if (response.statusCode == 422) {
        _errorMessage = data["message"];
        _singlePickupState = AllStates.Init;
        notifyListeners();
        return false;
      } else {
        _errorMessage = data["message"];
        _singlePickupState = AllStates.Init;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
  }

  increaseCounter() {
    if (_statusCodeGetAll != 404) {
      _counter = _counter + 1;
    }

    notifyListeners();
  }

  resetCounter() {
    _counter = 1;
    notifyListeners();
  }

  clearAllPickups() {
    _pickups.clear();
    notifyListeners();
  }
}
