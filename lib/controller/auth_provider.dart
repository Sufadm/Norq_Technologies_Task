import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void setError(String message) {
    error = message;
    notifyListeners();
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}

class ProfileModel {
  String? uid;
  final String email;
  final String password;
  final String confirmPassword;

  ProfileModel({
    this.uid,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'password': password,
      'confirmpassword': confirmPassword,
      'email': email,
    };
  }

  static ProfileModel fromJson(Map<String, dynamic> json) => ProfileModel(
      uid: json['id'],
      password: json['password'],
      email: json['email'],
      confirmPassword: json['confirmPassword']);
}
