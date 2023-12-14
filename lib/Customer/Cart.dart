import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/Checkout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key, required List<String> CartItems});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 400,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.green,
                    width: 3.0,
                  ),
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
                            border: Border.all(
                              color: Colors.green,
                              width: 2.0,
                            ),
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
              const SizedBox(height: 20),
              SizedBox(
                  width: 400,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: ElevatedButton(
                      onPressed: isSelected
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const checkout(),
                                ),
                              );
                            },
                      child: Text(
                        'Check Out',
                        style: GoogleFonts.raleway(fontSize: 20),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
