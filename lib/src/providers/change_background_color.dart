import 'package:flutter/material.dart';

class ChangeBackgroundColor with ChangeNotifier {
  Color _backgroundBase = Colors.white;

  get backgroundBase {
    return _backgroundBase;
  }

  set backgroundColor(Color backgroundColor) {
    this._backgroundBase = backgroundColor;

    notifyListeners();
  }
}
