import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:organica_project/Customer/Profile.dart';
import 'package:organica_project/Customer/dashboardCustomer.dart';
import 'package:organica_project/CustomerAccount.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key, required String userId, required Map userData})
      : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int _selectedIndex = 1;
  String userName = 'John Doe';

  final List<Order> orders = [
    Order(id: '1', productName: 'Broccoli', quantity: '2 kls', price: '200'),
  ];

  get userUid => null;

  @override
  void initState() {
    super.initState();
    // Retrieve the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Access the UID
      String userUid = user.uid;
      // Set up the user's name (replace it with your logic to get the user's name)
      String userName =
          'John Doe'; // Replace this with your logic to get the user's name
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];

            return GestureDetector(
              onTap: () {
                // Navigate to the order details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetails(order: order),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Image.asset(
                        '../lib/images/LogoO.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ${order.id}',
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Product name: ${order.productName}',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Quantity: ${order.quantity}',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Price: ${order.price}',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
          // Navigate to a new page based on the index selected
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardCustomer(),
              ),
            );
          } else if (index == 2) {
            // Navigate to the Profile page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  customerAccount: CustomerAccount(
                    id: userUid, // Use the user UID here
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
}

class Order {
  final String id;
  final String productName;
  final String quantity;
  final String price;

  Order({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}

class OrderDetails extends StatelessWidget {
  final Order order;

  const OrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.id} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product name: ${order.productName}'),
            const SizedBox(height: 10),
            Text('Quantity: ${order.quantity}'),
            const SizedBox(height: 10),
            Text('Price: ${order.price}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
