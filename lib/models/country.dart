import 'dart:convert';
import 'package:flutter/services.dart';

class Countries {
  _getFiles() async {
    Future<String> loadAsset() async {
      return await rootBundle.loadString('assets/countries.json');
    }

    String assets = await loadAsset();
    List countriesWithStates = jsonDecode(assets);
    return countriesWithStates;
  }

  getStates(int selectedCountryNum) async {
    List countriesWithStates = await _getFiles();
    List<dynamic> states = new List<dynamic>();
    for (dynamic state in countriesWithStates) {
      states.add(state['states']);
    }
    return states[selectedCountryNum];
  }

  getCountries() async {
    List countriesWithStates = await _getFiles();
    List countries = new List();
    for (dynamic country in countriesWithStates) {
      countries.add(country['name']);
    }
    return countries;
  }
}
