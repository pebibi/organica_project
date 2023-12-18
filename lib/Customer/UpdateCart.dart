import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/Customer/Cart.dart';
import 'package:organica_project/productData.dart';

class UpdateCart extends StatefulWidget {
  final Product product;

  const UpdateCart({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<UpdateCart> createState() => _UpdateCartState();
}

class _UpdateCartState extends State<UpdateCart> {
  int quantity = 1;
  String errorMessage = "";
  bool isError = false;
  List<String> cartItems = [];
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    errorMessage = "";
    isError = false;
    super.initState();
    _quantityController.text = quantity.toString();
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
      _quantityController.text = quantity.toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        _quantityController.text = quantity.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Image.asset(
                        '../lib/images/LogoO.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.product.title,
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: _decrementQuantity,
                          icon: Icon(Icons.remove),
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                quantity = int.tryParse(value) ?? 1;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: _incrementQuantity,
                          icon: Icon(Icons.add),
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Text('Quantity: $quantity kg',
                            style: GoogleFonts.raleway(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Price Per Kilo:',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '\₱${(widget.product.price).toStringAsFixed(2)}',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Total:',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '\₱${(quantity * widget.product.price).toStringAsFixed(0)}',
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 50, top: 20),
                        child: Text(
                          'Product Description',
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        widget.product.description,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        updateProduct(widget.product.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 2, 68, 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Update the Cart',
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProduct(String id) async {
    try {
      final docProduct =
          FirebaseFirestore.instance.collection('addToCart').doc(id);

      final total = quantity * widget.product.price;

      docProduct.update({
        'title': widget.product.title,
        'price': widget.product.price,
        'totalPrice': total,
        'description': widget.product.description,
        'quantity': quantity,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Cart(cartItems: []),
        ),
      );
    } catch (error) {
      setState(() {
        isError = true;
        errorMessage = 'Error: $error';
      });
    }
  }
}
