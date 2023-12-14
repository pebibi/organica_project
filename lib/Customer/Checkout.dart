import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/Success.dart';

class checkout extends StatefulWidget {
  const checkout({super.key});

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 400,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3.0),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    bottom: 20,
                    right: 280,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          '../assets/images/LogoO.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product name: Broccoli',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Quantity: 2 kls',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Price: 200',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 230),
              child: Text('Customer Details',
                  style: GoogleFonts.raleway(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 150),
              child: Text('Name: Jhonna Mae Awayan',
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                  )),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 170),
              child: Text('Address: Toril, Davao City',
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                  )),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 220),
              child: Text('Email: j@gmail.com',
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                  )),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 140),
              child: Text('Phone Number: 0912345678',
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                  )),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 400,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuccessPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Place Order',
                    style: GoogleFonts.raleway(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
