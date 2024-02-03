import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String error = '';
  String email = '';
  String password = '';
  String confirmpassword = '';
  bool loading = false;

  void phonenumber(String value) {
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void updatePasswordagain(String value) {
    confirmpassword = value;
    notifyListeners();
  }

  void setError(String message) {
    error = message;
    notifyListeners();
  }
}
