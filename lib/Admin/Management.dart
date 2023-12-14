import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Management_Admin extends StatefulWidget {
  const Management_Admin({super.key});

  @override
  State<Management_Admin> createState() => _Management_AdminState();
}

class _Management_AdminState extends State<Management_Admin> {
  int _listofProducts =
      0; // Default value, will be updated with the actual count
  final int _newOrders = 0;
  final int _processOrders = 0;
  final int _Deliver = 0;
  final int _Cancelled = 0;

  @override
  void initState() {
    super.initState();
    _fetchListOfProducts(); // Fetch the actual count of products
    // Add similar functions to fetch counts for other sections if needed
  }

  // Function to fetch the count of products from Firebase
  void _fetchListOfProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('product').get();

      setState(() {
        _listofProducts = querySnapshot.size;
      });
    } catch (e) {
      print('Error fetching the list of products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Order Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // List of products section
              _buildOrderSection(
                title: 'Number of Products',
                count: _listofProducts,
                icon: Icons.list,
              ),
              const SizedBox(height: 20),
              // New orders section
              _buildOrderSection(
                title: 'New Orders',
                count: _newOrders,
                icon: Icons.shopping_bag_outlined,
                onPressed: _incrementNewOrders,
              ),
              const SizedBox(height: 20),
              // Processed orders section
              _buildOrderSection(
                title: 'Processed Orders',
                count: _processOrders,
                icon: Icons.checklist_rtl,
              ),
              const SizedBox(height: 20),
              // Delivered orders section
              _buildOrderSection(
                title: 'Delivered Orders',
                count: _Deliver,
                icon: Icons.delivery_dining_outlined,
              ),
              const SizedBox(height: 20),
              // Cancelled orders section
              _buildOrderSection(
                title: 'Cancelled Orders',
                count: _Cancelled,
                icon: Icons.remove_shopping_cart_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSection({
    required String title,
    required int count,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.green.shade500,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _incrementNewOrders() {
    // Implement your logic to handle incrementing new orders
    // For example, you can navigate to a screen to process new orders.
  }
}
