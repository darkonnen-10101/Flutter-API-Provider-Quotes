import 'package:flutter/material.dart';
import 'package:linear_gradient/linear_gradient.dart';

class ChangeGradient with ChangeNotifier {
  int _orientation = LinearGradientStyle.ORIENTATION_HORIZONTAL;
  int _gradientColor = LinearGradientStyle.GRADIENT_TYPE_COOL_SKY;
  bool _valueState = false;

  get gradientOrientation {
    return _orientation;
  }

  get gradientColor {
    return _gradientColor;
  }

  get valueState {
    return _valueState;
  }

  set gradientOrientation(int gradientOrientation) {
    this._orientation = gradientOrientation;

    notifyListeners();
  }

  set gradientColor(int gradientColor) {
    this._gradientColor = gradientColor;

    notifyListeners();
  }

  set valueState(bool valueState) {
    this._valueState = valueState;

    notifyListeners();
  }
}
