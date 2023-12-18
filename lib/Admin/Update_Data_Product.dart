import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organica_project/productData.dart';

const List<String> categories = ['Vegetable', 'Fruits'];
const List<String> availabilities = ['Yes', 'No'];

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
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
    super.initState();
    initializeFields();
  }

  void initializeFields() {
    titleController.text = widget.product.title;
    priceController.text = widget.product.price.toString();
    quantityController.text = widget.product.quantity.toString();
    descriptionController.text = widget.product.description;
    supplierNameController.text = widget.product.supplierName!;
    supplierAddressController.text = widget.product.supplierAddress!;
    selectedCategory = widget.product.category!;
    selectedAvailability = widget.product.available!;
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
                    'Update Product',
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
                width: 350,
                height: 200,
                fit: BoxFit.cover,
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
                Row(
                  children: [
                    Expanded(
                      child: buildElevatedButton('UPDATE', updateProduct),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildElevatedButton('DELETE', deleteProduct),
                    ),
                  ],
                ),
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
      width: 75,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future deleteProduct() async {
    final docProduct =
        FirebaseFirestore.instance.collection('product').doc(widget.product.id);
    docProduct.delete();
    Navigator.pop(context);
  }

  Future updateProduct() async {
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

      final docProduct = FirebaseFirestore.instance
          .collection('product')
          .doc(widget.product.id);
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
