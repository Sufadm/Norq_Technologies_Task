// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:norq_technologies/controller/quantity.dart';
// import 'package:norq_technologies/model/hive_model.dart';
// import 'package:norq_technologies/view/const/const.dart';
// import 'package:provider/provider.dart';

// Future<List<ProductModels>> getCartItems() async {
//   final box = await Hive.openBox<ProductModels>('purchase_box');
//   return box.values.toList();
// }

// class CartPage extends StatelessWidget {
//   const CartPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Future<List<ProductModels>> getCartItems() async {
//     //   final box = await Hive.openBox<ProductModels>('purchase_box');
//     //   return box.values.toList();
//     // }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: FutureBuilder<List<ProductModels>>(
//           future: getCartItems(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No data in the cart.'));
//             } else {
//               return Expanded(
//                 child: ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     final product = snapshot.data![index];

//                     return ChangeNotifierProvider(
//                       create: (_) => QuantityProvider(),
//                       child: CartItem(product: product),
//                     );
//                   },
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class CartItem extends StatefulWidget {
//   final ProductModels product;

//   const CartItem({Key? key, required this.product}) : super(key: key);

//   @override
//   State<CartItem> createState() => _CartItemState();
// }

// class _CartItemState extends State<CartItem> {
//   late QuantityProvider quantityProvider;
//   late double totalPrice;

//   @override
//   void initState() {
//     super.initState();
//     quantityProvider = Provider.of<QuantityProvider>(context, listen: false);
//     calculateTotalPrice();
//   }

//   void calculateTotalPrice() {
//     final double parsedPrice = double.tryParse(
//           widget.product.price.replaceAll(RegExp(r'[^0-9.]'), ''),
//         ) ??
//         0.0;

//     setState(() {
//       totalPrice = parsedPrice * quantityProvider.quantity;
//     });
//   }

//   void removeProduct() async {
//     final box = await Hive.openBox<ProductModels>('purchase_box');
//     await box.delete(widget.product.key);
//     setState(() {
//       getCartItems();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           height: 200,
//           width: 200,
//           child: Image.network(widget.product.image),
//         ),
//         Consumer<QuantityProvider>(
//           builder: (context, quantityProvider, _) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 kHeight10,
//                 Container(
//                   margin: const EdgeInsets.only(right: 17),
//                   constraints: const BoxConstraints(
//                     maxWidth: 190,
//                   ),
//                   child: Text(widget.product.title),
//                 ),
//                 kHeight10,
//                 Container(
//                   margin: const EdgeInsets.only(right: 17),
//                   constraints: const BoxConstraints(
//                     maxWidth: 190,
//                   ),
//                   child: Text(
//                     widget.product.description,
//                     style: GoogleFonts.lato(fontSize: 10),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   children: [
//                     Text(
//                       "₹$totalPrice",
//                       style: GoogleFonts.lato(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       height: 40,
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.remove),
//                             onPressed: () {
//                               quantityProvider.decrement();
//                               calculateTotalPrice();
//                             },
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(7),
//                               border: Border.all(
//                                 color: Colors.black,
//                                 width: 1.0,
//                               ),
//                             ),
//                             width: 20,
//                             height: 25,
//                             child: Center(
//                               child: Text(
//                                 quantityProvider.quantity.toString(),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.add),
//                             onPressed: () {
//                               quantityProvider.increment();
//                               calculateTotalPrice();
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     removeProduct();
//                   },
//                   child: const Text("REMOVE"),
//                 )
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
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

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final box = await Hive.openBox<ProductModels>('purchase_box');
    setState(() {
      cartItems = box.values.toList();
    });
  }

  void removeProduct(ProductModels product) async {
    final box = await Hive.openBox<ProductModels>('purchase_box');
    await box.delete(product.key);
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: cartItems.isEmpty
            ? const Center(child: Text('No data in the cart.'))
            : CartList(cartItems: cartItems, onProductRemoved: removeProduct),
      ),
    );
  }
}

class CartList extends StatelessWidget {
  final List<ProductModels> cartItems;
  final Function(ProductModels) onProductRemoved;

  const CartList({
    Key? key,
    required this.cartItems,
    required this.onProductRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final product = cartItems[index];

          return ChangeNotifierProvider(
            create: (_) => QuantityProvider(),
            child: CartItem(
              product: product,
              onProductRemoved: () => onProductRemoved(product),
            ),
          );
        },
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final ProductModels product;
  final VoidCallback onProductRemoved;

  const CartItem({
    Key? key,
    required this.product,
    required this.onProductRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: Image.network(product.image),
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
                kHeight10,
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
