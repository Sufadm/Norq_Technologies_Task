import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int quantity = 1;

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }
}
