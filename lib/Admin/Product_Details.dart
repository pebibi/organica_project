import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Admin/Add_Data.dart';
import 'package:organica_project/Admin/Management.dart';
import 'package:organica_project/Admin/Update_Data_Product.dart';
import 'package:organica_project/productData.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController searchController = TextEditingController();

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
              return Text(
                'Something went wrong! ${snapshot.error}',
                style: TextStyle(
                    color:
                        Color.fromARGB(189, 255, 0, 0)), // Set the color here
              );
            } else if (snapshot.hasData && snapshot.data!.exists) {
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
            return Text(
              'Something went wrong! ${snapshot.error}',
              style: TextStyle(color: Color.fromARGB(189, 255, 0, 0)),
            );
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
    List<QueryDocumentSnapshot> filteredProducts = products.where((product) {
      final String title = product['title'].toString().toLowerCase();
      final String query = searchController.text.toLowerCase();
      return title.contains(query);
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 500,
              height: 90,
              child: TextFormField(
                controller: searchController,
                onChanged: (query) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.raleway(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 200, bottom: 30),
            child: Container(
              child: Text(
                'Products :',
                textAlign: TextAlign.left,
                style: GoogleFonts.raleway(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProducts.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildProductItem(
                Product.fromJson(
                    filteredProducts[index].data() as Map<String, dynamic>),
              );
            },
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
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              child: Image.asset(
                '../lib/images/LogoO.png',
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
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
              MaterialPageRoute(builder: (context) => const Management_Admin()),
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
