import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/AddToCart.dart';
import 'package:organica_project/Customer/Cart.dart';
import 'package:organica_project/Customer/Orders.dart';
import 'package:organica_project/Customer/Profile.dart';
import 'package:organica_project/CustomerAccount.dart';
import 'package:organica_project/productData.dart';

class DashboardCustomer extends StatefulWidget {
  const DashboardCustomer({super.key});

  @override
  State<DashboardCustomer> createState() => _DashboardCustomerState();
}

class _DashboardCustomerState extends State<DashboardCustomer> {
  int _selectedIndex = 0;
  String userName = '';
  List<String> cartItems = [];
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController searchController = TextEditingController();
  late final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your main content here
          Positioned(
            top: 40,
            left: 350,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Cart(
                      cartItems: [],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          Positioned(
            top: 40,
            right: 170,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('CustomerAccount')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.exists) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  userName = userData['fname'] ?? 'User';
                }
                return Text(
                  'Welcome ${userName.isNotEmpty ? userName : 'User'}!',
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Column(
              children: [
                TextFormField(
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 200, top: 30),
                  child: Text('Available Products',
                      style: GoogleFonts.raleway(fontSize: 20)),
                ),
                const SizedBox(height: 30),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('product')
                      .snapshots(),
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
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Orders(
                        userId: '',
                        userData: {},
                      )),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  customerAccount: CustomerAccount(
                    id: user.uid,
                    fname: userName,
                    lname: 'LastName',
                    email: 'user@example.com',
                    phoneNumber: '123456789',
                    address: '123 Street, City',
                  ),
                  userData: {},
                ),
              ),
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

    return Column(
      children: [
        SizedBox(
          height: 570,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return _buildProductItem(
                Product.fromJson(
                    filteredProducts[index].data() as Map<String, dynamic>),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(Product product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductPage(product: product)),
                );
              },
              child: Container(
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
          const SizedBox(height: 10),
          Text(
            product.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
}
