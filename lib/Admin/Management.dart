import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Management_Admin extends StatefulWidget {
  const Management_Admin({super.key});

  @override
  State<Management_Admin> createState() => _Management_AdminState();
}

class _Management_AdminState extends State<Management_Admin> {
  int _listofProducts = 0;
  int _newOrders = 0;
  int _processOrders = 0;
  int _Deliver = 0;
  int _Cancelled = 0;

  void _incrementListOfProducts() {
    setState(() {
      _listofProducts++;
    });
  }

  void _incrementNewOrders() {
    setState(() {
      _newOrders++;
    });
  }

  void _incrementProcessOrders() {
    setState(() {
      _processOrders++;
    });
  }

  void _incrementDeliver() {
    setState(() {
      _Deliver++;
    });
  }

  void _incrementCancelled() {
    setState(() {
      _Cancelled++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            // New orders section
            _buildOrderSection(
              title: 'List of Products',
              count: _listofProducts,
              icon: Icons.list, // Replaced imagePath with icon
              onPressed: _incrementListOfProducts,
            ),
            const SizedBox(height: 20),
            // New orders section
            _buildOrderSection(
              title: 'New Orders',
              count: _newOrders,
              icon: Icons.shopping_bag_outlined, // Replaced imagePath with icon
              onPressed: _incrementNewOrders,
            ),
            const SizedBox(height: 20),

            // Processed orders section
            _buildOrderSection(
              title: 'Processed Orders',
              count: _processOrders, // Placeholder count
              icon: Icons.checklist_rtl,
            ),
            const SizedBox(height: 20),
            _buildOrderSection(
              title: 'Delivered Orders',
              count: _Deliver, // Placeholder count
              icon: Icons.delivery_dining_outlined,
            ),
            const SizedBox(height: 20),
            _buildOrderSection(
              title: 'Cancelled Orders',
              count: _Cancelled, // Placeholder count
              icon: Icons.remove_shopping_cart_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSection({
    required String title,
    required int count,
    required IconData icon, // Changed imagePath to IconData
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
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
                  color: Colors.white, // Set the color to white
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.white,
              ), // Displaying the icon
            ],
          ),
        ],
      ),
    );
  }
}
