import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organica_project/productData.dart';
import 'package:google_fonts/google_fonts.dart';

const List<String> categories = ['Vegetable', 'Fruits'];
const List<String> availabilities = ['Yes', 'No'];

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierAddressController = TextEditingController();
  late String errorMessage;
  late bool isError;
  String selectedCategory = categories.first;
  String selectedAvailability = availabilities.first;

  @override
  void initState() {
    errorMessage = "";
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Positioned(
                  top: 40,
                  left: 10,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Add Products',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 100,
                  left: MediaQuery.of(context).size.width / 2 - 170,
                  child: GestureDetector(
                    onTap: () {
                      // Add functionality to choose/upload a photo
                      // For example, show a file picker or open the camera
                      // This is a placeholder, add your logic here
                    },
                    child: Container(
                      width: 350,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 87, 187, 139),
                          width: 5.0,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Color.fromARGB(255, 87, 187, 139),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 360,
                  left: MediaQuery.of(context).size.width / 2 - 170,
                  child: SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Container(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          child: DropdownButton<String>(
                            value: selectedAvailability,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedAvailability = newValue!;
                              });
                            },
                            items: availabilities
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildTextField(titleController, 'Product Name'),
                        const SizedBox(height: 20),
                        buildTextField(priceController, 'Product Price'),
                        const SizedBox(height: 20),
                        buildTextField(quantityController, 'Product Quantity'),
                        const SizedBox(height: 20),
                        buildTextField(supplierNameController, 'Supplier Name'),
                        const SizedBox(height: 20),
                        buildTextField(
                            supplierAddressController, 'Supplier Address'),
                        const SizedBox(height: 20),
                        buildTextField(
                            descriptionController, 'Product Description'),
                        const SizedBox(height: 20),
                        buildElevatedButton('SUBMIT', submitProduct),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText) {
    return SizedBox(
      width: 350,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }

  Widget buildElevatedButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 150,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> submitProduct() async {
    try {
      // Validate inputs
      if (titleController.text.isEmpty ||
          priceController.text.isEmpty ||
          quantityController.text.isEmpty ||
          descriptionController.text.isEmpty ||
          supplierAddressController.text.isEmpty ||
          supplierNameController.text.isEmpty) {
        throw 'All fields must be filled';
      }

      final docProduct = FirebaseFirestore.instance.collection('product').doc();
      final newProduct = Product(
        id: docProduct.id,
        title: titleController.text,
        price: double.parse(priceController.text),
        quantity: int.parse(quantityController.text),
        category: selectedCategory,
        available: selectedAvailability,
        supplierName: supplierNameController.text,
        supplierAddress: supplierAddressController.text,
        description: descriptionController.text,
      );

      await docProduct.set(newProduct.toJson());

      // Reset error state
      setState(() {
        isError = false;
        errorMessage = '';
      });

      // Clear text fields and navigate back
      clearTextFields();
      Navigator.pop(context);
    } catch (error) {
      // Handle errors and update error message
      setState(() {
        isError = true;
        errorMessage = 'Error: $error';
      });
    }
  }

  void clearTextFields() {
    setState(() {
      titleController.text = '';
      priceController.text = '';
      quantityController.text = '';
      selectedCategory = categories.first;
      selectedAvailability = availabilities.first;
      supplierNameController.text = '';
      supplierAddressController.text = '';
      descriptionController.text = '';
    });
  }
}
