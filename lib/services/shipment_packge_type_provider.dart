import 'dart:convert';

import 'package:bosta_clone_app/model/shipment/shipment_package_type_model.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/utilities/API/api_paths.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PackageTypesProvider extends ChangeNotifier {
  AllStates _packageTypesState = AllStates.Init;

  String _errorMassage;
  int statusCode, _selectedTypeId;
  List<PackageTypeModel> _types = [];
  List<String> _typesName = [];

  String _selectedType;

  PackageTypesProvider() {
    getAllTypes();
    statusCode = 0;
  }

  List<PackageTypeModel> get allPackageTypes => _types;

  List<String> get allPackageTypesName => _typesName;

  String get selectedType => _selectedType;

  int get packageTypeId => _selectedTypeId;

  String get error => _errorMassage;

  AllStates get stateOfPackageType => _packageTypesState;

  Future<bool> getAllTypes() async {
    _types.clear();
    _typesName.clear();
    _selectedType = await Preference.getLanguage() == "ar" ? "اختار" : "choose";
    _typesName.add(_selectedType);

    notifyListeners();
    try {
      String url =
          APIPaths.packageTypes + "?locale=${await Preference.getLanguage()}";
      print(url);

      _packageTypesState = AllStates.Loading;
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
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        for (var i in data) {
          _typesName.add(i["name"]);
        }
        print(_typesName);
        _types = data
            .map<PackageTypeModel>((item) => PackageTypeModel.fromJson(item))
            .toList();

        _packageTypesState = AllStates.Done;
        notifyListeners();

        return true;
      } else if (response.statusCode != 200) {
        _errorMassage = data["message"];
        _packageTypesState = AllStates.Done;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _packageTypesState = AllStates.Done;
    notifyListeners();
    return false;
  }

  selectType(type) {
    _selectedType = type;
    for (var i in _types) {
      if (i.name == type) {
        if (i.id!= 0) {
          _selectedTypeId =i.id;
        }
      }
    }
    notifyListeners();
  }

}
