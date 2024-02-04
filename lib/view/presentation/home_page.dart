import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:norq_technologies/controller/products_api.dart';
import 'package:norq_technologies/model/product_model.dart';
import 'package:norq_technologies/view/presentation/products/cart_page.dart';
import 'package:norq_technologies/view/presentation/products/product_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Future<List<ProductModel>> products = fetchProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const CartPage();
                  }));
                },
                child: const Icon(Icons.shopping_cart)),
          )
        ],
        title: Text(
          "Products Page",
          style: GoogleFonts.lato(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: FutureBuilder<List<ProductModel>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No products available"),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    ProductModel product = snapshot.data![index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductDetailsPage(
                              id: product.id.toString(),
                              title: product.title,
                              price: product.price.toString(),
                              description: product.description,
                              category: product.category,
                              rating: product.rating.toString(),
                              image: product.image);
                        }));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black26)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              product.image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              product.title.split(' ').take(2).join(' '),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "\$${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
