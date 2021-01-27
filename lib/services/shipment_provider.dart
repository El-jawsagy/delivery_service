import 'dart:convert';

import 'package:bosta_clone_app/model/shipment/shipment_model.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/utilities/API/api_paths.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShipmentsProvider extends ChangeNotifier {
  AllStates _shipmentState = AllStates.Init;
  AllStates _crateShipmentState = AllStates.Init;
  String _errorMassage, _massage;
  int _statusCodeGetAll, _statusCodeCreate;
  List<ShipmentModel> _shipments = [];
  int _counter = 1;

  ShipmentsProvider() {
    getAllShipment();
  }

  List<ShipmentModel> get allShipment => _shipments;

  String get error => _errorMassage;

  String get massage => _massage;

  AllStates get state => _shipmentState;

  AllStates get stateOfCreate => _crateShipmentState;

  int get responseCodeOfShipments => _statusCodeGetAll;

  int get responseCodeOfCreateShipment => _statusCodeCreate;

  //this function used to create a all shipment in a specific page.
  Future<bool> getAllShipment() async {
    try {
      String url = APIPaths.shipment +
          "?locale=${await Preference.getLanguage()}&page=$_counter";
      print(url);

      _shipmentState = AllStates.Loading;
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
      _shipmentState = AllStates.Done;
      notifyListeners();
      var data = jsonDecode(response.body);
      _statusCodeGetAll = response.statusCode;
      if (response.statusCode == 200) {
        if (_counter == 1) {
          _shipments = data
              .map<ShipmentModel>((item) => ShipmentModel.fromJson(item))
              .toList();
        } else {
          _shipments.addAll(data
              .map<ShipmentModel>((item) => ShipmentModel.fromJson(item))
              .toList());
        }

        return true;
      } else if (response.statusCode != 200) {
        _errorMassage = data["message"];
        _shipmentState = AllStates.Done;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _shipmentState = AllStates.Done;
    notifyListeners();
    return false;
  }

  //this function used to create a new shipment.
  Future<bool> createSingleShipment({
    receiverName,
    receiverPhone,
    receiverAddress,
    receiverCityId,
    receiverAreaId,
    receiverBuildingNumber,
    receiverFloor,
    receiverApartment,
    packageTypeId,
    packageNumberOfItems,
    packageDescription,
  }) async {
    _statusCodeCreate = 0;

    try {
      String url =
          APIPaths.shipment + "?locale=${await Preference.getLanguage()}";
      print(url);

      _crateShipmentState = AllStates.Loading;
      notifyListeners();
      Map<String, dynamic> bodyOfData = {
        "receiver_name": receiverName.toString(),
        "receiver_phone": receiverPhone.toString(),
        "receiver_address": receiverAddress.toString(),
        "receiver_city_id": receiverCityId.toString(),
        "receiver_area_id": receiverAreaId.toString(),
        "receiver_building_number": receiverBuildingNumber.toString(),
        "receiver_floor": receiverFloor.toString(),
        "receiver_apartment": receiverApartment.toString(),
        "package_type_id": packageTypeId.toString(),
        "package_number_of_items": packageNumberOfItems.toString(),
        "package_description": packageDescription.toString(),
      };
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
        _massage = data["message"];
        _crateShipmentState = AllStates.Done;
        notifyListeners();
        return true;
      } else if (response.statusCode == 422) {
        if (data.containsKey("receiver_name")) {
          _errorMassage = data["receiver_name"][0];
        } else if (data.containsKey("receiver_address")) {
          _errorMassage = data["receiver_address"][0];
        } else if (data.containsKey("receiver_phone")) {
          _errorMassage = data["receiver_phone"][0];
        } else if (data.containsKey("receiver_city_id")) {
          _errorMassage = data["receiver_city_id  "][0];
        } else if (data.containsKey("receiver_area_id")) {
          _errorMassage = data["receiver_area_id"][0];
        } else if (data.containsKey("receiver_building_number")) {
          _errorMassage = data["receiver_building_number"][0];
        } else if (data.containsKey("receiver_floor")) {
          _errorMassage = data["receiver_floor"][0];
        } else if (data.containsKey("receiver_apartment")) {
          _errorMassage = data["receiver_apartment"][0];
        } else if (data.containsKey("package_type_id")) {
          _errorMassage = data["package_type_id"][0];
        }
        _crateShipmentState = AllStates.Init;
        notifyListeners();
        return false;
      } else {
        _errorMassage = data["message"];
        _crateShipmentState = AllStates.Init;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _crateShipmentState = AllStates.Done;
    notifyListeners();
    return false;
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

  clearAllShipments() {
    _shipments.clear();
    notifyListeners();
  }
}
