import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/AddToCart.dart'; // Import your AddToCart model
import 'package:organica_project/Customer/Checkout.dart';
import 'package:organica_project/Customer/UpdateCart.dart';
import 'package:organica_project/productData.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key, required this.cartItems}) : super(key: key);

  final List<String> cartItems;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              StreamBuilder<List<AddToCart>>(
                stream: readUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong! ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final addToCart = snapshot.data!;
                    if (addToCart.isNotEmpty) {
                      double totalPrices = 0;

                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: addToCart.length,
                            itemBuilder: (context, index) {
                              final item = addToCart[index];
                              final isSelected =
                                  selectedItems.contains(item.id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedItems.remove(item.id);
                                    } else {
                                      selectedItems.add(item.id);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  padding: EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : const Color.fromARGB(
                                              255, 255, 255, 255),
                                      width: 5.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        '../lib/images/LogoO.png',
                                        width: 80,
                                        height: 80,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.title}',
                                            style: GoogleFonts.raleway(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Quantity: ${item.quantity}',
                                            style: GoogleFonts.raleway(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Total Price: \₱${(item.quantity * item.price).toStringAsFixed(0)}',
                                            style: GoogleFonts.raleway(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          deleteProduct(item.id);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          size: 24,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateCart(
                                                product: Product(
                                                  id: item.id,
                                                  title: item.title,
                                                  price: item.totalPrice,
                                                  quantity: item.quantity,
                                                  description:
                                                      item.description ?? '',
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          Text(
                              'Total Price: \₱${calculateTotalPrices(addToCart)}'),
                        ],
                      );
                    } else {
                      return Text('No items in the cart.');
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Container(
                width: 400,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: ElevatedButton(
                    onPressed: selectedItems.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(
                                  selectedItems: selectedItems,
                                  userId: 'your_user_id_here',
                                  userData: {},
                                  orderId: 'your_order_id_here',
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedItems.isNotEmpty ? Colors.green : Colors.grey,
                    ),
                    child: Text(
                      'Check Out',
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<AddToCart>> readUsers() {
    return FirebaseFirestore.instance.collection('addToCart').snapshots().map(
        (snapshot) => snapshot.docs
            .map(
                (doc) => AddToCart.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> submitCheckout(List<String> selectedItems, String userId) async {
    try {
      final List<Map<String, dynamic>> cartItems =
          await getCartData(selectedItems);

      double totalPrices = calculateTotalPrice(cartItems);

      await FirebaseFirestore.instance.collection('CheckOut').add({
        'userId': userId,
        'items': cartItems,
        'totalPrice': totalPrices,
        'checkoutDate': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print('Error submitting checkout: $error');
    }
  }

  double calculateTotalPrice(List<Map<String, dynamic>> items) {
    double totalPrices = 0;

    for (final item in items) {
      totalPrices += item['quantity'] * item['price'];
    }

    return totalPrices;
  }

  Future<List<Map<String, dynamic>>> getCartData(
      List<String> selectedItems) async {
    final cartData = <Map<String, dynamic>>[];

    for (final itemId in selectedItems) {
      final itemSnapshot = await FirebaseFirestore.instance
          .collection('addToCart')
          .doc(itemId)
          .get();

      if (itemSnapshot.exists) {
        final itemData = itemSnapshot.data();
        if (itemData != null) {
          cartData.add(itemData as Map<String, dynamic>);
        }
      }
    }

    return cartData;
  }

  Future deleteProduct(String productId) async {
    final docProduct =
        FirebaseFirestore.instance.collection('addToCart').doc(productId);
    docProduct.delete();
  }

  double calculateTotalPrices(List<AddToCart> items) {
    double totalPrices = 0;

    for (final item in items) {
      if (selectedItems.contains(item.id)) {
        totalPrices += item.quantity * item.price;
      }
    }

    return totalPrices;
  }
}
