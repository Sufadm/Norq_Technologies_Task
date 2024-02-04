import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:norq_technologies/controller/quantity.dart';
import 'package:norq_technologies/model/hive_model.dart';
import 'package:norq_technologies/view/const/const.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<ProductModels> cartItems;
  late List<QuantityProvider> quantityProviders;
  double netTotal = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final box = await Hive.openBox<ProductModels>('purchase_box');
    setState(() {
      cartItems = box.values.toList();
      quantityProviders =
          List.generate(cartItems.length, (_) => QuantityProvider());
      updateNetTotal();
    });
  }

  void removeProduct(ProductModels product) async {
    final box = await Hive.openBox<ProductModels>('purchase_box');
    await box.delete(product.key);
    fetchCartItems();
  }

  void updateNetTotal() {
    double total = 0.0;
    for (int i = 0; i < cartItems.length; i++) {
      final double parsedPrice = double.tryParse(
            cartItems[i].price.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0.0;

      total += parsedPrice * quantityProviders[i].quantity;
    }
    setState(() {
      netTotal = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart Items",
          style: GoogleFonts.lato(fontSize: 17),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: cartItems.isEmpty
            ? const Center(child: Text('No product in the cart.'))
            : Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 2,
                  ),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index];

                    return ChangeNotifierProvider.value(
                      value: quantityProviders[index],
                      child: CartItem(
                        product: product,
                        onProductRemoved: () {
                          removeProduct(product);
                          updateNetTotal();
                        },
                        updateNetTotal: updateNetTotal,
                      ),
                    );
                  },
                ),
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 128, 158, 173),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Net Total: ₹$netTotal",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final ProductModels product;
  final VoidCallback onProductRemoved;
  final VoidCallback updateNetTotal;

  const CartItem({
    Key? key,
    required this.product,
    required this.onProductRemoved,
    required this.updateNetTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.network(product.image),
          ),
        ),
        Consumer<QuantityProvider>(
          builder: (context, quantityProvider, _) {
            final double parsedPrice = double.tryParse(
                  product.price.replaceAll(RegExp(r'[^0-9.]'), ''),
                ) ??
                0.0;
            final totalPrice = parsedPrice * quantityProvider.quantity;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kHeight20,
                Container(
                  margin: const EdgeInsets.only(right: 17),
                  constraints: const BoxConstraints(
                    maxWidth: 190,
                  ),
                  child: Text(product.title),
                ),
                kHeight10,
                Container(
                  margin: const EdgeInsets.only(right: 17),
                  constraints: const BoxConstraints(
                    maxWidth: 190,
                  ),
                  child: Text(
                    product.description,
                    style: GoogleFonts.lato(fontSize: 10),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "₹$totalPrice",
                      style: GoogleFonts.lato(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 40,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              quantityProvider.decrement();
                              updateNetTotal();
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            width: 20,
                            height: 25,
                            child: Center(
                              child: Text(
                                quantityProvider.quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              quantityProvider.increment();
                              updateNetTotal();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    onProductRemoved();
                    updateNetTotal();
                  },
                  child: const Text("REMOVE"),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
