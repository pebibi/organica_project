import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Images extends StatefulWidget {
  const Images({Key? key}) : super(key: key);

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  File? _image;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _image = File(result.files.first.path!);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('uploads/$fileName.jpg');
        await storageRef.putFile(_image!);
        print('Image uploaded successfully!');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
                    _image!,
                    height: 150.0,
                  )
                : Placeholder(
                    fallbackHeight: 150.0,
                    fallbackWidth: double.infinity,
                  ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
