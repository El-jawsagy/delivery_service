import 'dart:convert';

import 'package:bosta_clone_app/model/location/area_model.dart';
import 'package:bosta_clone_app/model/location/city_model.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/utilities/API/api_paths.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CitiesProvider extends ChangeNotifier {
  AllStates _citiesState = AllStates.Init;
  AllStates _areasState = AllStates.Init;

  String _errorMassage;
  int statusCode;
  List<CityModel> _cities = [];
  List<AreaModel> _areas = [];

  CityModel _selectedCity;
  AreaModel _selectedArea;

  CitiesProvider() {
    getAllCities();
    statusCode = 0;
  }

  List<CityModel> get allCities => _cities;

  List<AreaModel> get allAreas => _areas;

  CityModel get selectedCity => _selectedCity;

  AreaModel get selectedArea => _selectedArea;

  String get error => _errorMassage;

  AllStates get stateOfCities => _citiesState;

  AllStates get stateOfAreas => _areasState;

  Future<bool> getAllCities() async {
    _cities.clear();
    _selectedCity = CityModel(
        id: 0,
        name: await Preference.getLanguage() == "ar" ? "اختار" : "choose");
    _cities.add(_selectedCity);

    notifyListeners();
    try {
      String url =
          APIPaths.cities + "?locale=${await Preference.getLanguage()}";
      print(url);

      _citiesState = AllStates.Loading;
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
        _cities.addAll(
            data.map<CityModel>((item) => CityModel.fromJson(item)).toList());
        _citiesState = AllStates.Done;
        notifyListeners();

        return true;
      } else if (response.statusCode != 200) {
        _errorMassage = data["message"];
        _citiesState = AllStates.Done;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _citiesState = AllStates.Done;
    notifyListeners();
    return false;
  }

  Future<bool> getAllAreas(int idOfCity) async {
    _areas.clear();
    _selectedArea = AreaModel(
        id: 0,
        name: await Preference.getLanguage() == "ar" ? "اختار" : "choose");

    _areas.add(_selectedArea);

    notifyListeners();
    try {
      String url = APIPaths.cities +
          "/$idOfCity?locale=${await Preference.getLanguage()}";
      print(url);

      _areasState = AllStates.Loading;
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
        _areas.addAll(
            data.map<AreaModel>((item) => AreaModel.fromJson(item)).toList());

        _areasState = AllStates.Done;
        notifyListeners();
        return true;
      } else if (response.statusCode != 200) {
        _errorMassage = data["message"];
        _areasState = AllStates.Init;
        notifyListeners();
        return false;
      }
    } catch (e) {
      throw "we have an error";
    }
    _areasState = AllStates.Init;
    notifyListeners();
    return false;
  }

  selectCity(city) {
    for (var i in _cities) {
      if (i.id == city) {
        _selectedCity = i;
      }
    }
    notifyListeners();
  }

  selectArea(area) {
    for (var i in _areas) {
      if (i.id == area) {
        _selectedArea = i;
      }
    }
    notifyListeners();
  }
}
