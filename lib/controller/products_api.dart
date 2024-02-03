import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:norq_technologies/model/product_model.dart';

Future<List<ProductModel>> fetchProducts() async {
  const url = "https://fakestoreapi.com/products";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);
    List<ProductModel> products =
        jsonList.map((json) => ProductModel.fromJson(json)).toList();
    return products;
  } else {
    print("Error: ${response.statusCode}, ${response.reasonPhrase}");
    return [];
  }
}
