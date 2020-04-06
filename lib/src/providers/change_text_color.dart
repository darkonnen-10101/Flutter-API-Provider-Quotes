import 'package:flutter/material.dart';

class ChangeTextColor with ChangeNotifier {
  Color _colorBase = Colors.black;

  get colorBase {
    return _colorBase;
  }

  set textColor(Color colorBase) {
    this._colorBase = colorBase;

    notifyListeners();
  }
}
