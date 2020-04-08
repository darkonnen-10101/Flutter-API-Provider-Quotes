import 'package:flutter/material.dart';

class ChangeLanguage with ChangeNotifier {
  String _language = 'en';

  get language {
    return _language;
  }

  set languageTraduction(String lang) {
    this._language = lang;

    notifyListeners();
  }
}
