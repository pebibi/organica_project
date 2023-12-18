import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Checkout extends StatefulWidget {
  final List<String> selectedItems;
  final String userId;
  final Map<String, dynamic> userData;
  final String orderId;

  const Checkout({
    Key? key,
    required this.selectedItems,
    required this.userId,
    required this.userData,
    required this.orderId,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  late Future<List<Map<String, dynamic>>> _cartDataFuture;

  @override
  void initState() {
    super.initState();
    _cartDataFuture = getCartData(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _cartDataFuture,
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final cartData = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 20),
                for (final item in cartData)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 3.0),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ListTile(
                      title: Text('Product: ${item['title']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: ${item['quantity']}'),
                          Text('Price: ${item['price']}'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(right: 230),
                  child: Text(
                    'Customer Details',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Display user profile data
                Padding(
                  padding: const EdgeInsets.only(right: 150),
                  child: Text(
                    'Name: ${widget.userData['name']}',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 170),
                  child: Text(
                    'Address: ${widget.userData['address']}',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 220),
                  child: Text(
                    'Email: ${widget.userData['email']}',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 140),
                  child: Text(
                    'Phone Number: ${widget.userData['phoneNumber']}',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Display total price
                Padding(
                  padding: const EdgeInsets.only(right: 140),
                  child: Text(
                    'Total Price: \₱${calculateTotalPrice(cartData)}',
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: ElevatedButton(
                      onPressed: () async {
                        await submitCheckout(
                            widget.selectedItems, widget.userId);
                        // Optionally, you can navigate to a success page or show a confirmation message
                      },
                      child: const Text(
                        'Place Order',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
        'orderId': widget.orderId, // Added orderId
      });

      // Clear the items from the cart after successful checkout
      await clearCart(selectedItems);
    } catch (error) {
      print('Error submitting checkout: $error');
      // Optionally, you can show an error message to the user
    }
  }

  double calculateTotalPrice(List<Map<String, dynamic>> items) {
    double totalPrices = 0;

    for (final item in items) {
      totalPrices += (item['quantity'] ?? 0) * (item['price'] ?? 0);
    }

    return totalPrices;
  }

  Future<void> clearCart(List<String> selectedItems) async {
    for (final itemId in selectedItems) {
      await FirebaseFirestore.instance
          .collection('addToCart')
          .doc(itemId)
          .delete();
    }
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
}
