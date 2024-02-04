import 'package:flutter/material.dart';

class PasswordVisibilityProvider extends ChangeNotifier {
  bool _isObscure = true;
  bool _isObscure1 = true;

  bool get isObscure => _isObscure;
  bool get isObscure1 => _isObscure1;

  void toggleVisibility() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void toggleVisibility1() {
    _isObscure1 = !_isObscure1;
    notifyListeners();
  }
}
