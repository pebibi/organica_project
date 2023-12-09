import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organica_project/Admin/Add_Data.dart';
import 'package:organica_project/Admin/register.dart';
import 'package:organica_project/Admin/Update_Data_Product.dart';
import 'package:organica_project/productData.dart';

class AdminProduct extends StatefulWidget {
  const AdminProduct({Key? key}) : super(key: key);

  @override
  State<AdminProduct> createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('UserAccount')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final name = userData['name'] ?? 'Username not found';
              final email = userData['email'] ?? 'admin@example.com';
              return _buildDrawer(name, email);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('product').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final products = snapshot.data!.docs;
            return _buildProductsList(products);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductsList(List<QueryDocumentSnapshot> products) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 500,
              height: 80,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 250, bottom: 30),
            child: Container(
              child: const Text(
                'Products :',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          for (var product in products)
            _buildProductItem(
              Product.fromJson(product.data() as Map<String, dynamic>),
            ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: () {
              _showProductDescription(product);
            },
            child: Image.asset(
              'Path to image', // Replace with the actual image path
              width: 140,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          product.title,
        ),
      ],
    );
  }

  void _showProductDescription(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Product Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${product.title}'),
              Text('Price: ${product.price}'),
              Text('Quantity: ${product.quantity}'),
              Text('Category: ${product.category}'),
              Text('Available: ${product.available}'),
              Text('Supplier Name: ${product.supplierName}'),
              Text('Supplier Address: ${product.supplierAddress}'),
              Text('Description: ${product.description}'),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProduct(product: product),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Edit Product'),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawer(String username, String email) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                email,
                style: const TextStyle(
                  color: Color.fromARGB(255, 192, 146, 146),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text('Manage Orders'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Register()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_box),
          title: const Text('Add Product'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProduct()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text('Logout'),
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}
