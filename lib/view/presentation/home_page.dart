import 'package:flutter/material.dart';
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
        leading: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CartPage();
              }));
            },
            child: const Icon(Icons.card_travel)),
        title: const Text("Product Page"),
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
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
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
                      child: Card(
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
