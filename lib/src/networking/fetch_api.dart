import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quotespremium/src/models/data_quote.dart';
import 'package:http/http.dart' as http;

class FetchApiClass extends ChangeNotifier {
  DataQuote _dataQuote = new DataQuote();
  Originator originator = new Originator();
  String _currentLanguage;
  bool isLoading = true;

  FetchApiClass() {
    _dataQuote.originator = originator;
  }

  setLang(String lang) {
    _currentLanguage = lang;
  }

  setDataQuote(DataQuote content) {
    _dataQuote = content;
    isLoading = false;
    notifyListeners();
  }

  DataQuote getData() {
    return _dataQuote;
  }

  Future<DataQuote> fetchQuote() async {
    final response = await http.get(
      'https://quotes15.p.rapidapi.com/quotes/random/?language_code=$_currentLanguage',
      headers: {
        "x-rapidapi-host": "quotes15.p.rapidapi.com",
        "x-rapidapi-key": "e9492e81femsh34b99eb6aa85e90p1311eejsnce09d6dad505",
      },
    );
    final Map parsedData = json.decode(response.body); // El objeto completo

    DataQuote parsedQuote = DataQuote.fromJson(
        parsedData); // Objeto construido solo con los campos pedidos

    return parsedQuote;
  }
}
