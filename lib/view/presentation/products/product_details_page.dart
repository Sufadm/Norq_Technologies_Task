import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:norq_technologies/model/hive_model.dart';
import 'package:norq_technologies/view/const/const.dart';
import 'package:norq_technologies/view/presentation/products/cart_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final String id;
  final String title;
  final String price;
  final String description;
  final String category;
  final String rating;
  final String image;

  const ProductDetailsPage({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.rating,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Image.network(
                            image,
                            height: 350,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          title,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(description,
                            style: GoogleFonts.lato(fontSize: 15)),
                        kHeight10,
                        Text(
                          "Special Price",
                          style: GoogleFonts.lato(
                            color: Colors.green,
                            fontStyle: FontStyle.italic,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "₹$price",
                              style: GoogleFonts.lato(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            kWidth10,
                            Container(
                              width: 60,
                              height: 25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      rating,
                                      style: GoogleFonts.lato(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 19,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        kHeight10,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  color: Colors.orange,
                  child: Center(
                    child: Text(
                      "Buy Now",
                      style: GoogleFonts.lato(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    try {
                      final productModel = ProductModels(
                        id: id.toString(),
                        title: title,
                        price: price,
                        description: description,
                        category: category,
                        rating: rating,
                        image: image,
                      );

                      print("added");

                      final box =
                          await Hive.openBox<ProductModels>('purchase_box');
                      final existingProduct = box.get(productModel.id);
                      if (existingProduct == null) {
                        await box.put(productModel.id, productModel);
                      } else {
                        print('Product already exists in the cart');
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const CartPage();
                      }));
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Container(
                    height: 50,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "Add to Cart",
                        style: GoogleFonts.lato(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
