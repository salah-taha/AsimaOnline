import 'dart:convert';

import 'package:asima_online/models/convertion.dart';
import 'package:asima_online/models/currency_api_error.dart';
import 'package:asima_online/models/rates.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  String _url = "https://api.exchangerate-api.com/v4/latest/";
  String apiKey = "defff1f9da263b5ebd3017ac";

  dynamic getRates() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString("currencyParam") ?? '';

    var url = _url + currencyParam;
    final response = await http.get(url);
    final map = json.decode(response.body);

    if (map["base"] == currencyParam) {
      final ratesJSON = map["rates"];
      final ratesObject = new Rates.fromJson(ratesJSON);

      ratesObject.initValues();

      return ratesObject.rates;
    } else {
      final error = new ApiError.fromJson(map);
      return error;
    }
  }

  dynamic getConvertion() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final currencyParam = preferences.getString("currencyParam") ?? '';
    final toParam = preferences.getString("toParam") ?? '';

    var url = _url + currencyParam;
    final response = await http.get(url);
    final map = json.decode(response.body);
    final editedMap = {
      'from': currencyParam,
      'to': toParam,
      'rate': map['rates'][toParam],
    };

    if (map["base"] == currencyParam) {
      final convertionObject = new Convertion.fromJson(editedMap);

      convertionObject.initValues();

      return convertionObject;
    } else {
      final error = new ApiError.fromJson(map);
      return error;
    }
  }
}
