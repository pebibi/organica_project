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
  String errorMessage = "";
  bool isError = false;

  String selectedCategory = categories.first;
  String selectedAvailability = availabilities.first;

  @override
  void initState() {
    errorMessage = "";
    isError = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
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
            Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Image.asset(
                '../lib/images/LogoO.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 15),
                buildDropdownButton(
                  'Category',
                  categories,
                  selectedCategory,
                  (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                buildDropdownButton(
                  'Availability',
                  availabilities,
                  selectedAvailability,
                  (String? newValue) {
                    setState(() {
                      selectedAvailability = newValue!;
                    });
                  },
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
                buildTextField(supplierAddressController, 'Supplier Address'),
                const SizedBox(height: 20),
                buildTextField(descriptionController, 'Product Description'),
                const SizedBox(height: 20),
                buildElevatedButton('SUBMIT', submitProduct),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdownButton(
    String labelText,
    List<String> items,
    String selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      width: 350, // Set the desired width
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 0, 0, 0),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: DropdownButton<String>(
        hint: const Text('Select Category'),
        value: selectedValue,
        onChanged: onChanged,
        style: GoogleFonts.raleway(
          color: Colors.black,
          fontSize: 16.0,
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(value),
            ),
          );
        }).toList(),
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
      width: 300,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 2, 68, 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.raleway(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> submitProduct() async {
    try {
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

      setState(() {
        isError = false;
        errorMessage = '';
      });

      clearTextFields();
      Navigator.pop(context);
    } catch (error) {
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
