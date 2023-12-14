import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organica_project/Customer/Cart.dart';
import 'package:organica_project/Customer/Orders.dart';
import 'package:organica_project/Customer/Profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0; // State variable to track the selected item
  String userName = '';
  List<String> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return Stack(
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
                  builder: (context) => Cart(CartItems: cartItems),
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
                .collection('users')
                .doc('userId') // Replace 'userId' with the actual user ID
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              }

              if (snapshot.hasData && snapshot.data!.exists) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final name = userData['name'] ?? 'User';
                setState(() {
                  userName = name;
                });
                return Text(
                  'Welcome ${userName.isNotEmpty ? userName : 'User'}!',
                  style: GoogleFonts.raleway(
                    fontSize: 32,
                  ),
                );
              }

              return const Text('User not found');
            },
          ),
        ),
        const Positioned(
          top: 100,
          left: 10,
          right: 10,
          child: Column(
            children: [
              // ... (rest of your UI code)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
        // Navigate to a new page based on the index selected
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Orders()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Profile(
                userName: '',
                password: '',
                email: '',
                mobileNumber: '',
              ),
            ),
          );
        }
      },
    );
  }
}
